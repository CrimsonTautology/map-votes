class Election < ActiveRecord::Base
  attr_accessible :allowed_votes, :blind, :close_date, :closed, :description, :name
  has_many: :canidate
end
