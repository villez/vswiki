require "#{Rails.root}/lib/vswiki/parser"

class Page < ActiveRecord::Base

  validates :title, presence: true
  validates :wikititle, uniqueness: true

  before_validation :build_wikititle

  def build_wikititle
    if self.title
      self.wikititle = Vswiki::Parser.new.make_wikititle(self.title)
    end
  end

  def build_formatted_html
    self.formatted_html = Vswiki::Parser.new.to_html(self.wikitext) if self.wikitext
  end

  def to_param
    wikititle
  end
end
