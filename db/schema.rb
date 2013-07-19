# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130719123050) do

  create_table "admins", :force => true do |t|
    t.integer  "user_id"
    t.string   "flags"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "admins", ["user_id"], :name => "index_admins_on_user_id"

  create_table "canidates", :force => true do |t|
    t.integer  "map_id"
    t.integer  "election_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "canidates", ["election_id"], :name => "index_canidates_on_election_id"
  add_index "canidates", ["map_id"], :name => "index_canidates_on_map_id"

  create_table "elections", :force => true do |t|
    t.boolean  "closed"
    t.boolean  "blind"
    t.date     "close_date"
    t.string   "name"
    t.text     "description"
    t.integer  "allowed_votes"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "map_comments", :force => true do |t|
    t.integer  "map_id"
    t.integer  "user_id"
    t.text     "comment"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "map_comments", ["map_id"], :name => "index_map_comments_on_map_id"
  add_index "map_comments", ["user_id"], :name => "index_map_comments_on_user_id"

  create_table "map_types", :force => true do |t|
    t.string   "name"
    t.string   "prefix"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "maps", :force => true do |t|
    t.string   "name"
    t.string   "image"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "map_type_id"
  end

  create_table "rs_evaluations", :force => true do |t|
    t.string   "reputation_name"
    t.integer  "source_id"
    t.string   "source_type"
    t.integer  "target_id"
    t.string   "target_type"
    t.float    "value",           :default => 0.0
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "rs_evaluations", ["reputation_name", "source_id", "source_type", "target_id", "target_type"], :name => "index_rs_evaluations_on_reputation_name_and_source_and_target", :unique => true
  add_index "rs_evaluations", ["reputation_name"], :name => "index_rs_evaluations_on_reputation_name"
  add_index "rs_evaluations", ["source_id", "source_type"], :name => "index_rs_evaluations_on_source_id_and_source_type"
  add_index "rs_evaluations", ["target_id", "target_type"], :name => "index_rs_evaluations_on_target_id_and_target_type"

  create_table "rs_reputation_messages", :force => true do |t|
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "receiver_id"
    t.float    "weight",      :default => 1.0
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "rs_reputation_messages", ["receiver_id", "sender_id", "sender_type"], :name => "index_rs_reputation_messages_on_receiver_id_and_sender", :unique => true
  add_index "rs_reputation_messages", ["receiver_id"], :name => "index_rs_reputation_messages_on_receiver_id"
  add_index "rs_reputation_messages", ["sender_id", "sender_type"], :name => "index_rs_reputation_messages_on_sender_id_and_sender_type"

  create_table "rs_reputations", :force => true do |t|
    t.string   "reputation_name"
    t.float    "value",           :default => 0.0
    t.string   "aggregated_by"
    t.integer  "target_id"
    t.string   "target_type"
    t.boolean  "active",          :default => true
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "rs_reputations", ["reputation_name", "target_id", "target_type"], :name => "index_rs_reputations_on_reputation_name_and_target", :unique => true
  add_index "rs_reputations", ["reputation_name"], :name => "index_rs_reputations_on_reputation_name"
  add_index "rs_reputations", ["target_id", "target_type"], :name => "index_rs_reputations_on_target_id_and_target_type"

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "nickname"
    t.string   "profile"
    t.string   "avatar_url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "votes", :force => true do |t|
    t.integer  "map_id"
    t.integer  "user_id"
    t.integer  "election_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "votes", ["election_id"], :name => "index_votes_on_election_id"
  add_index "votes", ["map_id"], :name => "index_votes_on_map_id"
  add_index "votes", ["user_id"], :name => "index_votes_on_user_id"

end
