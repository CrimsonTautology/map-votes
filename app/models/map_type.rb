class MapType < ActiveRecord::Base
  has_man :map
  attr_accessible :name, :prefix
end
