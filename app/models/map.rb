class Map < ActiveRecord::Base
  has_many :map_comment
  belongs_to :map_type
  attr_accessible :image, :name

  after_create :type_from_prefix

  private
    def type_from_prefix
      prefix = name.split("_", 2).first
      map_type_id = MapType.find_by_prefix(prefix)
      if prefix == "cp" || map_type_id.nil?
        map_type = MapType.find_by_name("Unkown")
      else 
        map_type = map_type_id
      end

      self.save!
    end
end
