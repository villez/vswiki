require 'active_support/core_ext'

module Vswiki
  class Parser

    RE_VALID_URL_CHARS = /[A-Za-z0-9\-\._~:\/\?#\[\]@!$&'\(\)\*\+,;=]/
    SELF_CLOSING_TAGS = %w(br hr img)

    # more complex handling for special characters is needed
    # in the future, but ActiveSupport's titleize + whitespace
    # removal is a decent starting point
    def make_wikititle(str)
      str.titleize.gsub(/\s+/, "") if str
    end

    def to_html(wikitext)
      wikitext = self.format_paragraphs(wikitext)
      wikitext = self.format_wikilinks(wikitext)
    end

    def format_paragraphs(wikitext)
      paragraphs = self.get_paragraphs(wikitext)
      paragraphs.each do |para|
        wikitext.gsub!(para, make_tag("p", para))
      end
      wikitext
    end

    def format_wikilinks(wikitext)
      links = self.get_bracketed_links(wikitext)
      links += self.get_bare_external_links(wikitext)
      links.each do |link|
        linktext, linklabel = get_link_text_and_label(link)
        href = linktext.start_with?("http") ? linktext : self.make_wikititle(linktext)
        wikitext.gsub!(link, make_tag("a", linklabel, href: href))
      end
      wikitext
    end

    def get_paragraphs(wikitext)
      wikitext.scan(/(.+)(?:(?:\r\n){2,}|\n*\Z)/).flatten
    end

    def get_bracketed_links(wikitext)
      wikitext.scan(/\[\[[^\]]*\]\]/)
    end

    def get_bare_external_links(wikitext)
      wikitext.scan(/(?:[^\[])(https?:\/\/#{RE_VALID_URL_CHARS}+)/).flatten
    end

    def get_link_text_and_label(link)
      text, label = link.gsub(/[\[\]]/, "").split("|")
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
      SELF_CLOSING_TAGS.include?(tag.to_s)
    end
  end
end
