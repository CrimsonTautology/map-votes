class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :map
  attr_accessible :value

  validates_uniqueness_of :user_id, scope: :map_id
  validates :map_id, presence: true
  validates :user_id, presence: true
end
