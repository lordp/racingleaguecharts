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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150326025822) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "driver_aliases", force: :cascade do |t|
    t.integer  "driver_id"
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "driver_users", force: :cascade do |t|
    t.integer  "driver_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "driver_users", ["driver_id", "user_id"], name: "driver_users_driver_id_user_id", using: :btree

  create_table "drivers", force: :cascade do |t|
    t.string  "name",           limit: 50
    t.string  "ip",             limit: 50
    t.string  "flair",          limit: 255
    t.string  "colour",         limit: 255
    t.string  "marker",         limit: 255
    t.integer "sessions_count"
  end

  create_table "laps", force: :cascade do |t|
    t.integer "race_id"
    t.integer "driver_id"
    t.integer "lap_number"
    t.float   "sector_1"
    t.float   "sector_2"
    t.float   "sector_3"
    t.float   "total"
    t.integer "session_id"
    t.string  "thing",      limit: 255
    t.decimal "speed"
    t.integer "position"
    t.decimal "fuel"
  end

  create_table "league_seasons", force: :cascade do |t|
    t.integer  "league_id"
    t.integer  "season_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leagues", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "super_league_id"
  end

  create_table "races", force: :cascade do |t|
    t.string   "name",       limit: 50
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "season_id"
    t.integer  "track_id"
    t.boolean  "time_trial"
    t.boolean  "is_dry"
    t.string   "thing",      limit: 255
    t.boolean  "fia"
  end

  create_table "screenshots", force: :cascade do |t|
    t.integer  "session_id"
    t.text     "parsed"
    t.string   "image",              limit: 255
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "confirmed"
    t.boolean  "career"
  end

  create_table "seasons", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "league_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.boolean  "time_trial"
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "token",             limit: 50
    t.float    "session_type"
    t.integer  "position"
    t.integer  "driver_id"
    t.integer  "track_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "race_id"
    t.boolean  "winner",                       default: false
    t.boolean  "is_dry"
    t.text     "lap_text"
    t.integer  "grid_position"
    t.integer  "laps_count"
    t.integer  "screenshots_count"
    t.integer  "fastest_lap_id"
  end

  add_index "sessions", ["driver_id"], name: "sessions_driver_id", using: :btree

  create_table "super_leagues", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.boolean  "disabled"
  end

  add_index "super_leagues", ["disabled"], name: "idx_disabled", using: :btree

  create_table "tracks", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.float    "length"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",           limit: 255
    t.string   "password_digest", limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "admin"
    t.string   "token",           limit: 255
    t.string   "name",            limit: 255
  end

end
