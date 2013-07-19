class DropUnusedTables < ActiveRecord::Migration
  def up
    drop_table :canidates
    drop_table :elections
    drop_table :rs_evaluations
    drop_table :rs_reputation_messages
    drop_table :rs_reputations
    drop_table :votes

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
