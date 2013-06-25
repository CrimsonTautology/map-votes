class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :map
      t.references :user
      t.references :election

      t.timestamps
    end
    add_index :votes, :map_id
    add_index :votes, :user_id
    add_index :votes, :election_id
  end
end
