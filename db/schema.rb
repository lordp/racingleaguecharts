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

ActiveRecord::Schema.define(:version => 20140321052405) do

  create_table "drivers", :force => true do |t|
    t.string "name", :limit => 50
    t.string "ip",   :limit => 50
  end

  create_table "laps", :force => true do |t|
    t.integer "race_id"
    t.integer "driver_id"
    t.integer "lap_number"
    t.float   "sector_1"
    t.float   "sector_2"
    t.float   "sector_3"
    t.float   "total"
    t.integer "session_id"
  end

  create_table "league_seasons", :force => true do |t|
    t.integer  "league_id"
    t.integer  "season_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "leagues", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "super_league_id"
  end

  create_table "races", :force => true do |t|
    t.string   "name",       :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "season_id"
    t.integer  "track_id"
    t.boolean  "time_trial"
    t.boolean  "is_dry"
    t.string   "thing"
  end

  create_table "screenshots", :force => true do |t|
    t.integer  "session_id"
    t.text     "parsed"
    t.string   "image"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "confirmed"
  end

  create_table "seasons", :force => true do |t|
    t.string   "name"
    t.integer  "league_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "time_trial"
  end

  create_table "sessions", :force => true do |t|
    t.string   "token",        :limit => 50
    t.float    "session_type"
    t.integer  "position"
    t.integer  "driver_id"
    t.integer  "track_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "race_id"
    t.boolean  "winner"
    t.boolean  "is_dry"
  end

  create_table "super_leagues", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tracks", :force => true do |t|
    t.string   "name"
    t.float    "length"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.boolean  "admin"
  end

end
