require_relative './list_node'
require 'active_support/core_ext'  # String#titleize
require 'english'                  # $POST_MATCH instead of $' etc.

module Vswiki
  class Parser

    SELF_CLOSING_TAGS = %i(br hr img)  # Ruby 2.0 array of symbols literal syntax

    # regular expressions for parsing markup elements

    # separators/end markers
    RE_END_OF_LINE = /$(\r?\n)*/
    RE_BLANK_LINE = /((\r?\n){2,}|(\r?\n)*\Z)/

    # headings
    RE_HEADING = /\A\s*([=!]{1,6})\s*(.*?)\s*=*#{RE_END_OF_LINE}/

    # horizontal rule
    RE_HR = /\A\s*\-{4,}\s*#{RE_END_OF_LINE}/

    # paragraphs
    RE_PARAGRAPH = /\A(.+?)#{RE_BLANK_LINE}/m

    # links & urls
    RE_VALID_URL_CHARS = /[A-Za-z0-9\-\._~:\/\?#\[\]@!$&'\(\)\*\+,;=]/
    RE_BRACKETED_LINK = /\[\[[^\]]*\]\]/
    RE_BARE_LINK = /(?:[^\[]|\A)(https?:\/\/#{RE_VALID_URL_CHARS}+)/
    RE_BRACKETS = /[\[\]]/

    # ordered & unordered lists
    RE_LI_PREFIX = /\A\s*([*#]+)\s*/
    RE_LIST_BLOCK = /(#{RE_LI_PREFIX}(.*?))#{RE_BLANK_LINE}/m


    # the interface method for converting a string to a wikititle
    #
    # more complex handling for special characters might be needed
    # in the future, but ActiveSupport's titleize + whitespace
    # removal is a decent starting point
    def make_wikititle(str)
      str.titleize.gsub(/\s+/, "") if str
    end

    # the main interface method for wikitext conversion to html
    def to_html(wikitext)
      parse_text_block(wikitext)
    end

    # the rest of the methods are private, not meant to be called
    # directly from outside


    private

    # the main parser loop
    #
    # recursively match the input wikitext block-by-block for known elements and
    # generate the corresponding HTML output

    def parse_text_block(wikitext)
      case wikitext
      when RE_HEADING
        heading_level = Regexp.last_match(1).size
        heading_text = Regexp.last_match(2)
        output = make_tag("h#{heading_level}", heading_text)
      when RE_LIST_BLOCK
        output = make_list(Regexp.last_match(1))
      when RE_HR
        output = make_tag(:hr)
      when RE_PARAGRAPH
        output = make_paragraph(Regexp.last_match(1))
      end

      # recursively parse the rest of the text and add to the output
      output += parse_text_block($POSTMATCH) if $POSTMATCH && !$POSTMATCH.empty?
      output
    end


    def make_list(wikitext)
      list_tree = create_list_tree(wikitext)
      output_list(list_tree)
    end

    def create_list_tree(list_block)
      previous_node = root = ListNode.new("virtual root item", 0, nil)

      list_block.lines.each do |li|
        li_type, li_level, li_text = parse_list_item(li)
        li_text = parse_inline(li_text)
        new_node = ListNode.new(li_text, li_level, li_type)
        add_list_node(previous_node, new_node, li_level)
        previous_node = new_node
      end

      root
    end

    def add_list_node(previous_node, new_node, list_level)
      depth = previous_node.depth

      if list_level > depth
        # deeper nested item, create a new subtree
        previous_node.add_child(new_node)
      elsif list_level < depth
        # higher-up item - need to back up levels
        higher_up_parent = previous_node.parent
        (depth - list_level).times { higher_up_parent = higher_up_parent.parent }
        higher_up_parent.add_child(new_node)
      else
        # same level item, add to the same parent
        previous_node.parent.add_child(new_node)
      end
    end

    def output_list(node)
      output = ""

      # output list node text as <li>, except for the virtual root element (type = nil)
      output << make_tag(:li, node.text) if node.type

      if node.children.any?
        child_list = node.children.                  # for all the subtrees of current node,
          map { |subtree| output_list(subtree) }.    # get the subtree outputs recursively
          reduce(:+)                                 # and concatenate them together
        sublist_type = node.children.first.type
        output << make_tag(sublist_type, child_list) # finally wrap subtree output in an <ul>/<ol>
      end
      output
    end

    # return type, level, text
    def parse_list_item(li)
      type =
        if /\A\s*\*/ =~ li
          :ul
        elsif /\A\s*#/ =~ li
          :ol
        end
      level = li.match(RE_LI_PREFIX)[1].size   # count the *'s or #'s at the beginning
      stripped_text = li.gsub(RE_LI_PREFIX, "").gsub(/\r|\n/, "").strip

      [type, level, stripped_text]
    end


    def make_paragraph(wikitext)
      make_tag(:p, parse_inline(wikitext))
    end

    def parse_inline(wikitext)
      format_wikilinks(wikitext)
    end

    def format_wikilinks(wikitext)
      links = get_bracketed_links(wikitext)
      links += get_bare_external_links(wikitext)
      links.each do |link|
        linktext, linklabel = get_link_text_and_label(link)
        href = linktext.start_with?("http") ? linktext : make_wikititle(linktext)
        wikitext.gsub!(link, make_tag(:a, linklabel, href: href))
      end
      wikitext
    end

    def get_bracketed_links(wikitext)
      wikitext.scan(RE_BRACKETED_LINK)
    end

    def get_bare_external_links(wikitext)
      wikitext.scan(RE_BARE_LINK).flatten
    end

    def get_link_text_and_label(link)
      text, label = link.gsub(RE_BRACKETS, "").split("|")
      [text, label || text]
    end

    def make_tag(tag, content = "", attributes = {})
      output = "<#{tag}"
      attributes.each { |k, v| output << " #{k}=\"#{v}\"" }
      if self_closing?(tag)
        output << " />"
      else
        output << ">#{content}</#{tag}>"
      end
      output
    end

    def self_closing?(tag)
      SELF_CLOSING_TAGS.include?(tag.to_sym)
    end
  end
end
