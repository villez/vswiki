require_relative './list_node'
require 'active_support/core_ext'  # String#titleize

module Vswiki
  class Parser

    SELF_CLOSING_TAGS = %i(br hr img)  # Ruby 2.0 array of symbols literal syntax

    # regular expressions for parsing markup elements

    # separators/end markers
    RE_END_OF_LINE = /(\r?\n)|\Z/
    RE_BLANK_LINE = /((\r?\n){2,}|(\r?\n)*\Z)/

    # headings
    RE_HEADING = /\A\s*([=!]{1,6})\s*(.*?)\s*=*#{RE_END_OF_LINE}/

    # horizontal rule
    RE_HR = /\A\s*\-{4,}\s*#{RE_END_OF_LINE}/

    # paragraphs
    RE_PARAGRAPH = /\A(.+?)#{RE_BLANK_LINE}/m

    # links & urls
    RE_VALID_URL_CHARS = /[A-Za-z0-9\-\._~:\/\?#\[\]@!$&'\(\)\*\+,;=]/
    RE_BRACKETED_LINK = /\A\[\[[^\]]*\]\]/
    RE_BARE_LINK = /\A(?:[^\[]|\A)(https?:\/\/#{RE_VALID_URL_CHARS}+)/
    RE_BRACKETS = /[\[\]]/

    # ordered & unordered lists
    RE_LI_PREFIX = /\A\s*([*#]+)\s*/
    RE_LIST_BLOCK = /(#{RE_LI_PREFIX}(.*?))#{RE_BLANK_LINE}/m

    # fenced & inline code blocks
    RE_CODE_BLOCK = /\A\s*^`{3}(?<lang>\w+)?\r?\n(?<preblock>.+?)^`{3}\s*#{RE_END_OF_LINE}/m
    RE_INLINE_CODE = /\A((`.*?`)|(@{2}.*?@{2}))/

    # inline emphasis & strong
    RE_STRONG_EMPHASIS = /\A('{5})(.*?)('{5})/
    RE_STRONG = /\A('{3})(.*?)('{3})/
    RE_EMPHASIS = /\A('{2})(.*?)('{2})/

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
    # parse the input wikitext block-by-block, matching known elements, and
    # generate the corresponding HTML output

    def parse_text_block(wikitext)
      output = ""
      while not wikitext.blank?
        case wikitext
        when RE_CODE_BLOCK
          lang = Regexp.last_match(:lang)
          opts = (lang ? { class: "language-#{lang}" } : {})
          output << make_tag(:pre, make_tag(:code, Regexp.last_match(:preblock), opts))
        when RE_HEADING
          heading_level = Regexp.last_match(1).size
          heading_text = Regexp.last_match(2)
          output << make_tag("h#{heading_level}", heading_text)
        when RE_LIST_BLOCK
          output << make_list(Regexp.last_match(1))
        when RE_HR
          output << make_tag(:hr)
        when RE_PARAGRAPH
          output <<  make_tag(:p, parse_inline_markup(Regexp.last_match(1)))
        else
          output << wikitext
        end

        # in the next iteration, parse the remaining text not matched this time
        wikitext = Regexp.last_match.post_match
      end
      output
    end

    # parsing markup within a paragraph or a list item (and other elems in the future)
    def parse_inline_markup(wikitext)
      inline_output = ""
      while not wikitext.blank?
        case wikitext
        when RE_INLINE_CODE
          inline_output << make_tag(:code, strip_inline_code_markup(Regexp.last_match(0)))
        when RE_BRACKETED_LINK, RE_BARE_LINK
          inline_output << format_link(Regexp.last_match(0))
        when RE_STRONG_EMPHASIS
          inline_output << make_tag(:strong,
                                    make_tag(:em, parse_inline_markup(Regexp.last_match(2))))
        when RE_STRONG
          inline_output << make_tag(:strong, parse_inline_markup(Regexp.last_match(2)))
        when RE_EMPHASIS
          inline_output << make_tag(:em, parse_inline_markup(Regexp.last_match(2)))
        when /[^`]|@[^@]+/
          # all the rest is output as-is - TBD: need to update when adding new inline markup
          inline_output << Regexp.last_match(0)
        end
        wikitext = Regexp.last_match.post_match
      end
      inline_output
    end

    def make_tag(tag, content = "", attributes = {})
      output = "<#{tag}"
      attributes.each { |k, v| output << " #{k}=\"#{v}\"" }
      output << (self_closing?(tag) ? " />" :  ">#{content}</#{tag}>")
    end

    def self_closing?(tag)
      SELF_CLOSING_TAGS.include?(tag.to_sym)
    end

    def strip_inline_code_markup(inline_code)
      if inline_code.start_with?("`")
        markup = "`"
      elsif inline_code.start_with?("@@")
        markup = "@@"
      end
      inline_code.gsub(markup, "")
    end

    def format_link(link_markup)
      linktext, linklabel = get_link_text_and_label(link_markup)
      href = linktext.start_with?("http") ? linktext : make_wikititle(linktext)
      make_tag(:a, linklabel, href: href)
    end

    def get_link_text_and_label(link)
      text, label = link.gsub(RE_BRACKETS, "").split("|")
      [text, label || text]
    end

    def make_list(wikitext)
      list_tree = create_list_tree(wikitext)
      output_list(list_tree)
    end

    def create_list_tree(list_block)
      previous_node = root = ListNode.new("virtual root item", 0, nil)

      list_block.lines.each do |li|
        li_type, li_level, li_text = parse_list_item(li)
        next if li_type.nil?

        li_text = parse_inline_markup(li_text)
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

    # return type, level, and text for the list item
    def parse_list_item(li)
      if li.start_with?("*")
        type = :ul
      elsif li.start_with?("#")
        type = :ol
      else
        return [nil, nil, nil] # not a list element after all
      end

      level = li.match(RE_LI_PREFIX)[1].size   # count the *'s or #'s at the beginning
      stripped_text = li.gsub(RE_LI_PREFIX, "").strip
      [type, level, stripped_text]
    end
  end
end
