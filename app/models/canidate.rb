class Canidate < ActiveRecord::Base
  belongs_to :map
  belongs_to :election
  has_many :votes

  validates :map, presence: true
  validates :election, presence: true
end
