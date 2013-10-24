class ApiKey < ActiveRecord::Base
  attr_accessible :access_token, :name
  validates :name, presence: true

  before_create :generate_access_token

  def self.authenticate access_token
    ApiKey.find(access_token: access_token)
  end

  private

  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end while ApiKey.exists?(access_token: access_token)
  end
end
