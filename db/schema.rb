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

ActiveRecord::Schema.define(version: 20131117082021) do

  create_table "photos", force: true do |t|
    t.integer  "instagram_id"
    t.string   "image_low_resolution"
    t.string   "image_thumbnail"
    t.string   "image_standard_resolution"
    t.string   "instagram_url"
    t.text     "instagram_body_req"
    t.string   "tags"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "checked",                   default: false
    t.integer  "place_id"
  end

  add_index "photos", ["instagram_id"], name: "index_photos_on_instagram_id"
  add_index "photos", ["place_id"], name: "index_photos_on_place_id"

  create_table "places", force: true do |t|
    t.integer  "google_id"
    t.string   "name"
    t.string   "types"
    t.string   "vicinity"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "places", ["google_id"], name: "index_places_on_google_id"
  add_index "places", ["name"], name: "index_places_on_name"

end