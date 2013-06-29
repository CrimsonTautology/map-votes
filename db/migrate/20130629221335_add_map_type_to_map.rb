class AddMapTypeToMap < ActiveRecord::Migration
  def change
    add_column :maps, :map_type_id, :integer
  end
end
