require 'active_support/core_ext'
require 'english'  # $POST_MATCH instead of $' etc.

module Vswiki
  class Parser

    SELF_CLOSING_TAGS = %i(br hr img)  # Ruby 2.0 array of symbols literal syntax

    # regular expressions for parsing markup elements
    RE_END_OF_LINE = /$(\r?\n)*/
    RE_BLANK_LINE = /((\r\n){2,}|(\r\n)*\Z)/
    RE_HEADING = /\A\s*([=!]{1,6})\s*(.*?)\s*=*#{RE_END_OF_LINE}/
    RE_HR = /\A\s*\-{4,}\s*#{RE_END_OF_LINE}/
    RE_PARAGRAPH = /\A(.+?)#{RE_BLANK_LINE}/m
    RE_VALID_URL_CHARS = /[A-Za-z0-9\-\._~:\/\?#\[\]@!$&'\(\)\*\+,;=]/
    RE_BRACKETED_LINK = /\[\[[^\]]*\]\]/
    RE_BARE_LINK = /(?:[^\[]|\A)(https?:\/\/#{RE_VALID_URL_CHARS}+)/
    RE_BRACKETS = /[\[\]]/
    RE_LI_PREFIX = /\A\s*\*+\s*/
    RE_LEADING_BULLETS = /\A\s*(\*+)/
    RE_UL_BLOCK = /(#{RE_LI_PREFIX}(.*?))#{RE_BLANK_LINE}/m


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
      when RE_UL_BLOCK
        output = make_unordered_list(Regexp.last_match(1))
      when RE_HR
        output = make_tag(:hr)
      when RE_PARAGRAPH
        output = make_paragraph(Regexp.last_match(1))
      end

      output += parse_text_block($POSTMATCH) if $POSTMATCH && !$POSTMATCH.empty?
      output
    end


    def make_unordered_list(wikitext)
      list_tree = parse_list_items(wikitext)
      output_list(list_tree)
    end

    # simple helper class for building a tree structure for
    # representing nested lists
    class Node
      attr_accessor :parent, :text, :children, :depth

      def initialize(text, depth)
        @text = text
        @depth = depth
        @parent = nil
        @children = []
      end

      def add(child)
        @children << child
        child.parent = self
      end
    end

    def parse_list_items(list_block)
      previous_node = root = Node.new("root", 0)

      list_block.lines.each do |li|
        list_level = count_bullets(li)
        li = strip_bullets_from_li(li)
        li = parse_inline(li)
        new_node = Node.new(strip_bullets_from_li(li), list_level)
        add_list_node(previous_node, new_node, list_level)
        previous_node = new_node
      end

      root
    end

    def add_list_node(previous_node, new_node, list_level)
      depth = previous_node.depth
      if list_level > depth     # deeper nested item, create a new subtree
        previous_node.add(new_node)
      elsif list_level < depth  # higher-up item - need to back up (depth - list_level) levels
        higher_up_parent = previous_node.parent
        (depth - list_level).times { higher_up_parent = higher_up_parent.parent }
        higher_up_parent.add(new_node)
      else  # same level item, add to the same parent
        previous_node.parent.add(new_node)
      end
    end

    def output_list(root)
      output = ""

      # output node text as <li>, except for the virtual root element
      output << make_tag(:li, root.text) unless root.depth == 0

      if root.children.any?
        child_list = root.children.                 # for all the subtrees of current node,
          map { |subtree| output_list(subtree) }.   # get the subtree outputs recursively
          reduce(:+)                                # and concatenate them together
        output << make_tag(:ul, child_list)         # finally wrap subtree output in an <ul>
      end
      output
    end

    def count_bullets(li)
      li =~ RE_LEADING_BULLETS
      Regexp.last_match(1).size
    end

    def strip_bullets_from_li(li)
      li.gsub(RE_LEADING_BULLETS, "").gsub(/\r|\n/, "").strip
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
      if selfclosing?(tag)
        output << " />"
      else
        output << ">#{content}</#{tag}>"
      end
      output
    end

    def selfclosing?(tag)
      SELF_CLOSING_TAGS.include?(tag.to_sym)
    end
  end
end
