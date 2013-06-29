class MapType < ActiveRecord::Base
  has_many :map
  attr_accessible :name, :prefix
end
