class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :map
  attr_accessible :value

  validates_uniqueness_of :user_id, scope: :map_id
  validates :map_id, presence: true
  validates :user_id, presence: true
  validates_inclusion_of :value, in: [1, -1, 0]

  def self.cast_vote user, map, value
    v = Vote.find_by_user_id_and_map_id user, map
    if v
      v.value = value
      v.save!
    else
      v = create(value: value)
      v.user = user
      v.map = map
      v.save!
    end

  end
end
