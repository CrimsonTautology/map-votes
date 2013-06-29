class Map < ActiveRecord::Base
  has_many :map_comment
  belongs_to :map_type
  attr_accessible :image, :name
end
