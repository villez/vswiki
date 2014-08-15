require "#{Rails.root}/lib/vswiki/parser"

class Page < ActiveRecord::Base

  validates :title, presence: { message: "Cannot save with empty title" }
  validates :wikititle, uniqueness: { message:
    "page with that title already exists" }

  before_validation :build_wikititle

  def self.page_exists?(wikititle)
    Page.exists?(wikititle: wikititle)
  end

  def self.make_wikititle(str)
    Vswiki::Parser.new.make_wikititle(str)
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
