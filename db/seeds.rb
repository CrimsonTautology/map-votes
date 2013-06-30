# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'open-uri'

MapType.delete_all
[
  ["Arena", "arena"],
  ["Capture the Flag", "ctf"],
  ["Attack/Defend Capture the Flag", "ctf"],
  ["Attack/Defend Control Point", "cp"],
  ["Push Control Point", "cp"],
  ["Circular Control Point", "ccp"],
  ["King of the Hill", "koth"],
  ["Payload", "pl"],
  ["Payload Race", "plr"],
  ["Surf", "surf"],
  ["Jump", "jump"],
  ["Prop Hunt", "ph"],
  ["Zombie Fortress", "zf"],
  ["Domination Control Point", "dom"],
  ["Death Match", "dm"],
  ["Multi-Typed", "pc"],
  ["Achievement", "achievement"],
  ["Kick Ball", "mb"],
  ["Man Vs. Machine", "mvm"],
  ["Gimmick", ""],
  ["Unkown", ""],
  ["Territorial Control", "tc"]
].each do |t|
  MapType.create!(name: t[0], prefix: t[1])
end
  

Map.delete_all
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
