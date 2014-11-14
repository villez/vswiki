class ChangeWikititleIndexOnPages < ActiveRecord::Migration
  def change
    remove_index :pages, :wikititle
    add_index :pages, :wikititle, unique: true
  end
end
