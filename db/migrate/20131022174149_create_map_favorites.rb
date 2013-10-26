class CreateMapFavorites < ActiveRecord::Migration
  def change
    create_table :map_favorites do |t|
      t.string :user
      t.string :map

      t.timestamps
    end
  end
end
