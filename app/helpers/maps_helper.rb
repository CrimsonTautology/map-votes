module MapsHelper
  def fast_dl_link map
    File.join(ENV["FAST_DL_SITE"], ziped_file_extension(map))
  end

  def ziped_file_extension map
    map.name + ".bsp.bz2"
  end
end
