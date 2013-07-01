class Election < ActiveRecord::Base
  attr_accessible :allowed_votes, :blind, :close_date, :closed, :description, :name

  has_many :canidates
  has_many :maps, through: :canidates

  scope :active, -> { where(closed: false) }
  scope :inactive, -> { where(closed: true) }
end
