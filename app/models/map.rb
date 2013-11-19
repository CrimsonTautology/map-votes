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
    name.parameterize
  end

  def total_votes
    liked_by.count + hated_by.count
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
      else #ignore unkown keys
        scope
      end
    end
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
