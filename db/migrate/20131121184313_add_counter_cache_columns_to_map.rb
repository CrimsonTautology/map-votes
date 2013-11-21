class AddCounterCacheColumnsToMap < ActiveRecord::Migration
  def change
    add_column :maps, :likes_count, :integer, default: 0
    add_column :maps, :hates_count, :integer, default: 0
    add_column :maps, :map_comments_count, :integer, default: 0

    Map.reset_column_information
    Map.all.each do |m|
      m.likes_count = m.votes.likes.length
      m.hates_count =  m.votes.hates.length
      m.map_comments_count = m.map_comments.length
      m.save
    end
  end
end
