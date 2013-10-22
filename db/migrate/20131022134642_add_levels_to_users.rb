class AddLevelsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :banned_at, :datetime
    add_column :users, :moderator, :boolean, default: false, null: false
    change_column :users, :admin, :boolean, default: false, null: false
    add_column :users, :avatar_icon_url, :string
    remove_column :users, :profile
  end
end
