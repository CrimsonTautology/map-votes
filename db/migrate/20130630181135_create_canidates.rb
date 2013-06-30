class CreateCanidates < ActiveRecord::Migration
  def change
    create_table :canidates do |t|
      t.references :map
      t.references :election

      t.timestamps
    end
    add_index :canidates, :map_id
    add_index :canidates, :election_id
  end
end
