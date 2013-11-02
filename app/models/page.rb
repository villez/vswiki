require "#{Rails.root}/lib/Vswiki/parser"

class Page < ActiveRecord::Base

  validates :title, presence: true
  validates :wikititle, uniqueness: true
  validates :wikitext, presence: true

  before_validation :build_wikititle, on: :create

  def build_wikititle
    if self.title
      self.wikititle = Vswiki::Parser.make_wikititle(self.title)
    end
  end

  def build_formatted_html
    # dummy version for now
    self.formatted_html = self.wikitext if self.wikitext
  end

  def to_param
    wikititle
  end
end
