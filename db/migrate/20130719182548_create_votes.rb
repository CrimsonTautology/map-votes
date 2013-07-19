class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :user
      t.references :map
      t.integer :value

      t.timestamps
    end
    add_index :votes, :user_id
    add_index :votes, :map_id
  end
end
