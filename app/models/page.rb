class Page < ActiveRecord::Base

  validates :title, presence: true
  validates :wikititle, uniqueness: true
  validates :wikitext, presence: true

  before_validation :build_wikititle, on: :create

  def build_wikititle
    # need to enhance this later
    self.wikititle = self.title.titleize.gsub(/\s+/, "") if self.title
  end

  def build_formatted_html
    # dummy version for now
    self.formatted_html = self.wikitext if self.wikitext
  end
end
