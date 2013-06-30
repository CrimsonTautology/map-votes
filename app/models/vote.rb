class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :canidate

  validates :user, presence: true
  validates :canidate, presence: true
end
