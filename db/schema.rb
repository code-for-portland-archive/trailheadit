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

ActiveRecord::Schema.define(version: 20140601064233) do

  create_table "phones", force: true do |t|
    t.string   "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "phones", ["number"], name: "index_phones_on_number"

  create_table "trailheads", force: true do |t|
    t.integer  "phone_id"
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
  end

  add_index "trailheads", ["phone_id"], name: "index_trailheads_on_phone_id"

end
