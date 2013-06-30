# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'open-uri'

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
  MapType.find_or_create_by_name_and_prefix(name: t[0], prefix: t[1])
end
  
Map.seed_from_fast_dl_site
