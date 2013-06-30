class Canidate < ActiveRecord::Base
  belongs_to :map
  belongs_to :election
  # attr_accessible :title, :body
end
