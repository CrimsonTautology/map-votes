class MapFavorite < ActiveRecord::Base
  belongs_to :map
  belongs_to :user

  validates_uniqueness_of :user_id, scope: :map_id

  validates :map, presence: true
  validates :user, presence: true

  def self.favorite user, map
    MapFavorite.find_or_create_by_user_id_and_map_id user, map
  end

  def self.unfavorite user, map
    MapFavorite.destroy_by_user_id_and_map_id user, map
    fav = find_by(user: user, map: map)
    if fav
      fav.destroy
    end
  end
  
end
