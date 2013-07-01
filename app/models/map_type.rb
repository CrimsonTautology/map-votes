class MapType < ActiveRecord::Base
  has_many :maps

  validates :name, presence: true

  attr_accessible :name, :prefix
end
