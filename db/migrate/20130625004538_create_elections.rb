class CreateElections < ActiveRecord::Migration
  def change
    create_table :elections do |t|
      t.boolean :closed
      t.boolean :blind
      t.date :close_date
      t.string :name
      t.text :description
      t.integer :allowed_votes

      t.timestamps
    end
  end
end
