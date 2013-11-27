class AddWikititleIndexToPages < ActiveRecord::Migration
  def change
    add_index :pages, :wikititle
  end
end
