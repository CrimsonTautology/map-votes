class Vote < ActiveRecord::Base
  belongs_to :map
  belongs_to :user
  belongs_to :election

  validates :user, presence: true
  validates :election, presence: true
  # attr_accessible :title, :body
end
