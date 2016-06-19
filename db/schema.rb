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

ActiveRecord::Schema.define(version: 20160618172747) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "amenities", force: :cascade do |t|
    t.integer  "kennel_id"
    t.string   "description"
    t.float    "price"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "amenities", ["kennel_id"], name: "index_amenities_on_kennel_id", using: :btree

  create_table "drop_off_pick_ups", force: :cascade do |t|
    t.integer  "kennel_id"
    t.string   "monday_drop_off"
    t.string   "monday_pick_up"
    t.string   "tuesday_drop_off"
    t.string   "tuesday_pick_up"
    t.string   "wednesday_drop_off"
    t.string   "wednesday_pick_up"
    t.string   "thursday_drop_off"
    t.string   "thursday_pick_up"
    t.string   "friday_drop_off"
    t.string   "friday_pick_up"
    t.string   "saturday_drop_off"
    t.string   "saturday_pick_up"
    t.string   "sunday_drop_off"
    t.string   "sunday_pick_up"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "drop_off_pick_ups", ["kennel_id"], name: "index_drop_off_pick_ups_on_kennel_id", using: :btree

  create_table "kennels", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "kennel_name"
    t.string   "kennel_address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.string   "kennel_opening_hours"
    t.string   "kennel_closing_hours"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "kennels", ["user_id"], name: "index_kennels_on_user_id", using: :btree

  create_table "policies", force: :cascade do |t|
    t.integer  "kennel_id"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "policies", ["kennel_id"], name: "index_policies_on_kennel_id", using: :btree

  create_table "runs", force: :cascade do |t|
    t.integer  "kennel_id"
    t.float    "price"
    t.integer  "weight_limit"
    t.integer  "number_of_rooms"
    t.integer  "pets_per_run"
    t.string   "size"
    t.string   "title"
    t.string   "description"
    t.string   "indoor_or_outdoor"
    t.string   "private_or_shared"
    t.string   "breeds_restricted"
    t.string   "dates_unavailable"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "runs", ["kennel_id"], name: "index_runs_on_kennel_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "kennel_or_customer"
    t.boolean  "completed_registration"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
