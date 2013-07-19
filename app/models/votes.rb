class Votes < ActiveRecord::Base
  belongs_to :user
  belongs_to :map
  attr_accessible :value
end
