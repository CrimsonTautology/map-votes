class MapFavorite < ActiveRecord::Base
  belongs_to :map
  belongs_to :user

  validates_uniqueness_of :user_id, scope: :map_id

  validates :map, presence: true
  validates :user, presence: true

  def self.favorite user, map
    fav = MapFavorite.find_by(user: user, map: map)
    if fav.nil?
      fav = create
      fav.user = user
      fav.map  = map
      fav.save!
    end
    fav
  end

  def self.unfavorite user, map
    fav = find_by(user: user, map: map)
    if fav
      fav.destroy
    end
    nil
  end
  
end
