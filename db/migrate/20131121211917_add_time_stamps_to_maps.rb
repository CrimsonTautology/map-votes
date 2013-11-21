class AddTimeStampsToMaps < ActiveRecord::Migration
  def change
    add_column :maps, :last_played_at, :datetime
    add_column :maps, :total_time_played, :integer, default: 0
  end
end
