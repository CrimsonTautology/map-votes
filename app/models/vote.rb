class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :map
  attr_accessible :value

  validates_uniqueness_of :user_id, scope: :map_id
  validates :map_id, presence: true
  validates :user_id, presence: true
  validates_inclusion_of :value, in: [1, -1, 0]

  scope :likes,   -> { where value: 1 }
  scope :hates,   -> { where value: -1 }
  scope :neutral, -> { where value: 0 }

  after_save :update_counter_cache
  after_destroy :update_counter_cache

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

  private
  def update_counter_cache
    map.likes_count = map.votes.likes.length
    map.hates_count = map.votes.hates.length
    map.save
  end
end
