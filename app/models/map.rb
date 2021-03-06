class Map < ActiveRecord::Base
  attr_accessible :image, :name

  has_many :map_comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :map_favorites, dependent: :destroy
  has_many :voted_by, through: :votes,
            class_name: 'User',
            source: :user

  def liked_by
    votes.likes.map(&:user)
  end
  def hated_by
    votes.hates.map(&:user)
  end

  def self.order_by_votes
    joins(:votes).select('maps.id, maps.name, sum(votes.value) as total_value').group('maps.id').order('total_value desc')
  end


  belongs_to :map_type

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  no_whitespace = /\A[\S]+\z/
  validates :name, format: {with: no_whitespace}

  before_create :type_from_prefix

  def prefix
    name.split("_", 2).first.downcase
  end

  def version
    v =name.scan(/(?:\d\d*|_(?:a|b|v|beta|erc|frc|rc|final|\d|x|z|fix|test)\d*[a-z]?)\z/).last
    unless v.nil?
      v.gsub(/\A_/, '')
    else
      nil
    end
  end

  def base_map_name
    name.sub(/\A[^_]{0,5}_/, '').sub(/_(a|b|v|beta|erc|frc|rc|final|\d|x|z|fix|test)\d*[a-z]?\z/, '')
  end

  def base_map_name_and_type
    name.sub(/_(a|b|v|beta|erc|frc|rc|final|\d|x|z|fix|test)\d*[a-z]?\z/, '')
  end

  def other_versions
    Map.search(base_map_name_and_type).flatten.uniq.reject{|m| m.name.eql?(name)}
  end

  def find_related_maps_deep
    base_map_name.split("_").select{|s| s.length>3}.map do |s|
      Map.search(s)
    end.flatten.uniq.reject{|m| m.name.eql?(name)}
  end

  def to_param
    name
  end

  def total_votes
    likes_count + hates_count
  end

  #Calculate by Wilson Confidence Curve
  def score confidence=0.95
    n = likes_count + hates_count
    if n == 0
      return 0
    end
    z = Statistics2.pnormaldist(1-(1-confidence)/2)
    phat = 1.0*likes_count/n
    (phat + z*z/(2*n) - z * Math.sqrt((phat*(1-phat)+z*z/(4*n))/n))/(1+z*z/n)
  end

  #Rate the map by how much we should play it next based on time last played and it's rating by players
  def should_play_next_score 
    (score + last_played_score) / 2
  end

  def last_played_score
    1.0 - (last_played_at.to_f / Time.now.to_f)
  end

  def self.order_by_score
    where("(likes_count > 0 OR hates_count > 0)").order("((likes_count + 1.9208) / (likes_count + hates_count) - 1.96 * SQRT((likes_count * hates_count) / (likes_count + hates_count) + 0.9604) / (likes_count + hates_count)) / (1 + 3.8416 / (likes_count + hates_count)) DESC")
  end

  def self.total_server_play_time
    sum(:total_time_played)
  end


  #Return a random map
  def self.random
    offset(rand count).first
  end

  def self.seed_from_fast_dl_site
    maplist = open ENV['FAST_DL_SITE'] do |f|
      f.read
    end.lines.to_a

    maplist.select!{|s| s.include? ".bsp.bz2"}.map! do |s|
      s.gsub(/<li>.*\"> /, "").
        gsub(/\.bsp.*$/, "").
        chomp
    end

    maplist.each do |s|
      Map.find_or_create_by_name(s)
    end
  end

  def self.search(query)
    #Use postgre text search
    if query.present?
      if Rails.configuration.database_configuration[Rails.env]["database"].eql? "postgresql"
        where("name @@ :q", q: query)
      else
        where("name like :q", q: "%#{query}%")
      end
    else
      scoped
    end
  end

  def self.filter(attributes)
    attributes.inject(self) do |scope, (key, value)|
      return scope if value.blank?
    case key.to_sym
    when :map_type_id
      scope.where(key => value)
    when :search
      scope.search(value)
    when :sort
      case value.to_sym
      when :best
        scope.order_by_score
      when :comments
        scope.where("map_comments_count > 0").order(map_comments_count: :desc)
      when :newest
        scope.order(created_at: :desc)
      when :oldest
        scope.order(created_at: :asc)
      when :last_played_at
        scope.where("total_time_played > 0").order(last_played_at: :desc)
      when :total_time_played
        scope.where("total_time_played > 0").order(total_time_played: :desc)
      else
        scope.order(:name)
      end
    else #ignore unkown keys
      scope
    end
    end

  end

  def update_play_time time_played
      self.total_time_played += time_played
      self.last_played_at = Time.now
      self.save!
  end


  private
  def type_from_prefix
    type = MapType.find_by_prefix(prefix)
    if type.nil?
      self.map_type=MapType.find_by_name("Unkown")
    else 
      self.map_type= type
    end
  end
end
