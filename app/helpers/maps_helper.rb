module MapsHelper
  def fast_dl_link map
    if ENV["FAST_DL_SITE"]
      File.join(ENV["FAST_DL_SITE"], ziped_file_extension(map))
    else
      ""
    end
  end

  def ziped_file_extension map
    map.name + ".bsp.bz2"
  end

  #First try provided image; than a third party source
  def smart_map_image_url map
    if url_responsive? map.image
      map.image
    else
      url = "http://image.www.gametracker.com/images/maps/160x120/tf2/#{map.name}.jpg"
      if url_responsive? url
        url
      else
        "unkown_image.jpg"
      end
    end
  end

end
