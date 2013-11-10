require 'active_support/core_ext'
require 'english'  # $POST_MATCH instead of $' etc.

module Vswiki
  class Parser

    SELF_CLOSING_TAGS = %i(:br :hr :img)  # Ruby 2.0 syntax!

    # regular expressions for parsing
    RE_HEADING = /\A\s*([=!]{1,6})\s*(.*?)\s*=*$(\r?\n)*/
    RE_PARAGRAPH = /\A(.+?)((\r\n){2,}|(\r\n)*\Z)/m
    RE_VALID_URL_CHARS = /[A-Za-z0-9\-\._~:\/\?#\[\]@!$&'\(\)\*\+,;=]/
    RE_BRACKETED_LINK = /\[\[[^\]]*\]\]/
    RE_BARE_LINK = /(?:[^\[]|\A)(https?:\/\/#{RE_VALID_URL_CHARS}+)/
    RE_BRACKETS = /[\[\]]/


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

    def parse_text_block(wikitext)
      case wikitext
      when RE_HEADING
        heading_level = Regexp.last_match(1).size
        heading_text = Regexp.last_match(2)
        output = make_tag("h#{heading_level}", heading_text)
      when RE_PARAGRAPH
        output = make_paragraph(Regexp.last_match(1))
      end

      output += parse_text_block($POSTMATCH) if $POSTMATCH && !$POSTMATCH.empty?
      output
    end

    def make_paragraph(wikitext)
      make_tag(:p, parse_paragraph(wikitext))
    end

    def parse_paragraph(wikitext)
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

    def make_tag(tag, content, attributes = {})
      output = "<#{tag}"
      attributes.each { |k, v| output << " #{k}=\"#{v}\"" }
      if selfclosing? tag
        output << "/>"
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
