class Map < ActiveRecord::Base
  has_many :map_comment
  belongs_to :map_type
  attr_accessible :image, :name

  before_create :type_from_prefix

  def prefix
    name.split("_", 2).first.downcase
  end

  def to_param
    name
  end

  def fast_dl_link
    File.join(ENV["FAST_DL_SITE"], ziped_file_extension)
  end

  def ziped_file_extension
    name + ".bsp.bz2"
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
