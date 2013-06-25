class Vote < ActiveRecord::Base
  belongs_to :map
  belongs_to :user
  belongs_to :election
  # attr_accessible :title, :body
end
