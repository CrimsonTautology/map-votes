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
end
