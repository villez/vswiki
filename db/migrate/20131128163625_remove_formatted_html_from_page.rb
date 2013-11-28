class RemoveFormattedHtmlFromPage < ActiveRecord::Migration
  def change
    remove_column :pages, :formatted_html, :text
  end
end
