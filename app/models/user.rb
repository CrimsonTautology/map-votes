class User < ActiveRecord::Base
  attr_accessible :avatar_url, :nickname, :profile, :provider, :uid

  has_many :votes
  has_many :map_comments
  has_many :voted_maps, through: :votes,
            class_name: 'Map',
            source: :map

  def liked_maps
    votes.likes.map(&:map)
  end
  def hated_maps
    votes.hates.map(&:map)
  end

  scope :admins, -> {where admin: true}

  after_find :check_for_account_update

  validates :nickname, presence: true
  validates :uid, presence: true
  validates :uid, uniqueness: true
  validates :provider, presence: true

  def self.random
    offset(rand count).first
  end

  def self.create_with_steam_id(steam_id)
    steam = SteamId.new(steam_id.to_i)
    create! do |user|
      user.provider = "steam"
      user.uid = steam.steam_id64.to_s
      user.nickname = steam.nickname
      user.profile = steam.base_url
      user.avatar_url = steam.medium_avatar_url
    end
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.nickname = auth["info"]["nickname"]
      user.avatar_url = auth["info"]["image"]
      user.avatar_icon_url = auth["extra"]["raw_info"]["avatar"]
    end
  end

  def steam_update
    steam = SteamId.new(uid.to_i)
    update_attributes(nickname: steam.nickname, profile: steam.base_url, avatar_url: steam.medium_avatar_url)
  end

  def check_for_account_update
    if updated_at < 1.day.ago
      #steam_update
    end
  end
end
