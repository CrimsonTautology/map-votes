class MapComment < ActiveRecord::Base
  belongs_to :map
  belongs_to :user

  validates :map, presence: true
  validates :user, presence: true
  validates :comment, presence: true

  attr_accessible :comment
end
