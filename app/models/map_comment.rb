class MapComment < ActiveRecord::Base
  belongs_to :map, counter_cache: true
  belongs_to :user

  validates :map, presence: true
  validates :user, presence: true
  validates :comment, presence: true

  attr_accessible :comment

  def self.write_message user, map, comment
    map_comment = MapComment.new(comment: comment)
    map_comment.map= map
    map_comment.user = user
    map_comment.save
  end
end
