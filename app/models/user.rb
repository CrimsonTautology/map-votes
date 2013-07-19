class User < ActiveRecord::Base
  attr_accessible :avatar_url, :nickname, :profile, :provider, :uid

  has_many :evaluations, class_name: "RSEvaluation", as: :source

  after_find :check_for_account_update

  validates :nickname, presence: true
  validates :uid, presence: true
  validates :provider, presence: true

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.nickname = auth["info"]["nickname"]
      user.profile = auth["info"]["urls"]["Profile"]
      user.avatar_url = auth["info"]["image"]
    end
  end

  def steam_update
    steam = SteamId.new(uid.to_i)
    update_attributes(nickname: steam.nickname, profile: steam.base_url, avatar_url: steam.medium_avatar_url)
  end

  def check_for_account_update
    if updated_at < 1.day.ago
      steam_update
    end
  end
end
