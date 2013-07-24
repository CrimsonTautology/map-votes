class Map < ActiveRecord::Base
  attr_accessible :image, :name

  has_many :map_comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :users, through: :votes
  

  belongs_to :map_type

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }

  before_create :type_from_prefix

  def prefix
    name.split("_", 2).first.downcase
  end

  def base_map_name
    name.gsub(/^[^_]{0,5}_/, '').gsub(/_[^_]*$/, '')
  end

  def find_related_maps
    Map.where('name LIKE ?', "%#{base_map_name}%")
  end

  def find_related_maps_deep
    base_map_name.split("_").select{|s| s.length>3}.map do |s|
      Map.where('name LIKE ?', "%#{s}%")
    end.flatten.uniq
  end

  def to_param
    name.parameterize
  end

  def liked_by
    self.votes.likes.joins(:user)
  end

  def hated_by
    self.votes.hates.joins(:user)
  end

  def neutral_by
    self.votes.neutral.joins(:user)
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
