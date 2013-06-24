class User < ActiveRecord::Base
  attr_accessible :avatar_url, :nickname, :profile, :provider, :uid
end
