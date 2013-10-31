class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.string :wikititle
      t.text :wikitext
      t.text :formatted_html

      t.timestamps
    end
  end
end
