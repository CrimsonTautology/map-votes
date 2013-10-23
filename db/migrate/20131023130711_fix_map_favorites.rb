class FixMapFavorites < ActiveRecord::Migration
  def change
    remove_column :map_favorites, :user
    add_column :map_favorites, :user_id, :integer
    add_index :map_favorites, :user_id

    remove_column :map_favorites, :map
    add_column :map_favorites, :map_id, :integer
    add_index :map_favorites, :map_id
  end
end
