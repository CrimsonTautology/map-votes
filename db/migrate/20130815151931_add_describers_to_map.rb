class AddDescribersToMap < ActiveRecord::Migration
  def change
    add_column :maps, :description, :text, default: ""
    add_column :maps, :origin, :string, default: ""
  end
end
