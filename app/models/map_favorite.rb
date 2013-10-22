class MapFavorite < ActiveRecord::Base
  belongs_to :map
  belongs_to :user

  validates_uniqueness_of :user_id, scope: :map_id

  validates :map, presence: true
  validates :user, presence: true

  def self.favorite user, map
    find_or_create_by_user_id_and_map_id user, map
  end

  def self.unfavorite user, map
    destroy_by_user_id_and_map_id user, map
  end
  
end
