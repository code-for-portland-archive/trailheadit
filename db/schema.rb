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

ActiveRecord::Schema.define(version: 20140604032351) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "trailheads", force: true do |t|
    t.string   "name"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "photo"
    t.boolean  "parking"
    t.boolean  "drinking_water"
    t.boolean  "restrooms"
    t.boolean  "kiosk"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.float    "heading"
    t.datetime "taken_at"
    t.float    "altitude"
    t.datetime "viewed_at"
    t.string   "email_url"
    t.integer  "user_id"
    t.text     "email_properties"
    t.text     "exif_properties"
  end

  add_index "trailheads", ["user_id"], name: "index_trailheads_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

end
