class MapType < ActiveRecord::Base
  has_many :map

  validates :name, presence: true

  attr_accessible :name, :prefix
end
