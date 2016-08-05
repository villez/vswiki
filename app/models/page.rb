require "#{Rails.root}/lib/vswiki/parser"

class Page < ApplicationRecord

  validates :title, presence: { message: "Cannot save a page with an empty title" }
  validates :wikititle, uniqueness: { message:
    "A page with that title already exists" }

  before_validation :build_wikititle

  def self.page_exists?(wikititle)
    Page.exists?(wikititle: wikititle)
  end

  def self.make_wikititle(str)
    Vswiki::Parser.new.make_wikititle(str)
  end

  def self.fetch_sidebar
    Page.find_by(wikititle: "Sidebar") ||
      Page.create(title: "Sidebar", wikitext: "!!!Sidebar\nDefault sidebar")
  end

  def build_wikititle
    if self.title
      self.wikititle = Page.make_wikititle(self.title)
    end
  end

  def formatted_html
     Vswiki::Parser.new.to_html(self.wikitext) if self.wikitext
  end

  def to_param
    wikititle
  end

end
