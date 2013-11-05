require 'active_support/core_ext'

module Vswiki
  class Parser

    # more complex handling for special characters is needed
    # in the future, but ActiveSupport's titleize + whitespace
    # removal is a decent starting point
    def self.make_wikititle(str)
      str.titleize.gsub(/\s+/, "") if str
    end

    def self.format_html(wikitext)
      wikitext = self.format_paragraphs(wikitext)
      wikitext = self.format_wikilinks(wikitext)
    end

    def self.format_paragraphs(wikitext)
      paragraphs = self.get_paragraphs(wikitext)
      paragraphs.each do |para|
        wikitext.gsub!(para, "<p>#{para}</p>")
      end
      wikitext
    end

    def self.format_wikilinks(wikitext)
      links = self.get_bracketed_links(wikitext)
      links += self.get_bare_external_links(wikitext)
      links.each do |link|
        linktext, linklabel = get_link_text_and_label(link)
        href = linktext.start_with?("http") ? linktext : self.make_wikititle(linktext)
        wikitext.gsub!(link, "<a href=\"#{href}\">#{linklabel}</a>")
      end
      wikitext
    end

    def self.get_paragraphs(wikitext)
      wikitext.scan(/(.+)(?:(?:\r\n){2,}|\n*\Z)/).flatten
    end

    def self.get_bracketed_links(wikitext)
      wikitext.scan(/\[\[[^\]]*\]\]/)
    end

    def self.get_bare_external_links(wikitext)
      wikitext.scan(/https?:\/\/\S+/)
    end

    def self.get_link_text_and_label(link)
      text, label = link.gsub(/[\[\]]/, "").split("|")
      [text, label || text]
    end
  end
end
