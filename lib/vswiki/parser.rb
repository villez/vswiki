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
      self.format_links(wikitext)
    end

    def self.format_links(wikitext)
      links = wikitext.scan(/\[\[[^\]]*\]\]/)
      links.each do |link|
        linktext = link.gsub(/[\[\]]/, "")
        title = self.make_wikititle(linktext)
        wikitext.gsub!(link, "<a href=\"/#{title}\">#{linktext}</a>")
      end
      wikitext
    end
  end
end
