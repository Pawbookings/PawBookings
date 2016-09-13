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

ActiveRecord::Schema.define(version: 20160829040543) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
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

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "ahoy_events", id: :uuid, default: nil, force: :cascade do |t|
    t.uuid     "visit_id"
    t.integer  "user_id"
    t.string   "name"
    t.json     "properties"
    t.datetime "time"
  end

  add_index "ahoy_events", ["time"], name: "index_ahoy_events_on_time", using: :btree
  add_index "ahoy_events", ["user_id"], name: "index_ahoy_events_on_user_id", using: :btree
  add_index "ahoy_events", ["visit_id"], name: "index_ahoy_events_on_visit_id", using: :btree

  create_table "amenities", force: :cascade do |t|
    t.integer  "kennel_id"
    t.string   "title"
    t.string   "description"
    t.float    "price"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "amenities", ["kennel_id"], name: "index_amenities_on_kennel_id", using: :btree

  create_table "blog_categories", force: :cascade do |t|
    t.string   "title"
    t.date     "publish_date"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "blogs", force: :cascade do |t|
    t.integer  "blogID"
    t.string   "title"
    t.string   "body"
    t.string   "keyword"
    t.date     "publish_date"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "blog_image_file_name"
    t.string   "blog_image_content_type"
    t.integer  "blog_image_file_size"
    t.datetime "blog_image_updated_at"
  end

  create_table "check_in_contract_important_informations", force: :cascade do |t|
    t.string   "title"
    t.string   "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "check_in_contract_refund_policies", force: :cascade do |t|
    t.string   "title"
    t.string   "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "check_in_contract_reservation_changes", force: :cascade do |t|
    t.string   "title"
    t.string   "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.string   "data_fingerprint"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "customer_emergency_contacts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "customer_emergency_contacts", ["user_id"], name: "index_customer_emergency_contacts_on_user_id", using: :btree

  create_table "customer_vet_infos", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "address"
    t.string   "phone"
    t.string   "emergency_phone"
    t.string   "email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "customer_vet_infos", ["user_id"], name: "index_customer_vet_infos_on_user_id", using: :btree

  create_table "holidays", force: :cascade do |t|
    t.integer  "kennel_id"
    t.date     "holiday_date"
    t.string   "description"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "holidays", ["kennel_id"], name: "index_holidays_on_kennel_id", using: :btree

  create_table "hours_of_operations", force: :cascade do |t|
    t.integer  "kennel_id"
    t.string   "monday_open"
    t.string   "monday_close"
    t.string   "tuesday_open"
    t.string   "tuesday_close"
    t.string   "wednesday_open"
    t.string   "wednesday_close"
    t.string   "thursday_open"
    t.string   "thursday_close"
    t.string   "friday_open"
    t.string   "friday_close"
    t.string   "saturday_open"
    t.string   "saturday_close"
    t.string   "sunday_open"
    t.string   "sunday_close"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "hours_of_operations", ["kennel_id"], name: "index_hours_of_operations_on_kennel_id", using: :btree

  create_table "kennel_check_in_check_outs", force: :cascade do |t|
    t.string   "check_in"
    t.string   "check_out"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "kennel_ratings", force: :cascade do |t|
    t.integer  "reservation_id"
    t.integer  "reservationID"
    t.integer  "kennelID"
    t.integer  "userID"
    t.integer  "rating"
    t.string   "comment"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "kennel_ratings", ["reservation_id"], name: "index_kennel_ratings_on_reservation_id", using: :btree

  create_table "kennels", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "kennelID"
    t.integer  "userID"
    t.float    "sales_tax"
    t.string   "name"
    t.string   "address"
    t.string   "mission_statement"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.string   "email"
    t.string   "cats_or_dogs"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.float    "latitude"
    t.float    "longitude"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "kennels", ["user_id"], name: "index_kennels_on_user_id", using: :btree

  create_table "payments", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "zip"
    t.string   "ip_address"
    t.string   "card_type"
    t.string   "expiration_month"
    t.string   "expiration_year"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "payments", ["user_id"], name: "index_payments_on_user_id", using: :btree

  create_table "pets", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "cat_or_dog"
    t.string   "breed"
    t.integer  "weight"
    t.string   "vaccinations"
    t.string   "spay_or_neutered"
    t.string   "special_instructions"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "pets", ["user_id"], name: "index_pets_on_user_id", using: :btree

  create_table "photos", force: :cascade do |t|
    t.integer  "kennel_id"
    t.integer  "customer_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "photos", ["customer_id"], name: "index_photos_on_customer_id", using: :btree
  add_index "photos", ["kennel_id"], name: "index_photos_on_kennel_id", using: :btree

  create_table "policies", force: :cascade do |t|
    t.integer  "kennel_id"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "policies", ["kennel_id"], name: "index_policies_on_kennel_id", using: :btree

  create_table "reservations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "kennel_id"
    t.integer  "reservationID"
    t.integer  "kennelID"
    t.integer  "userID"
    t.string   "customer_first_name"
    t.string   "customer_last_name"
    t.string   "customer_email"
    t.string   "customer_phone"
    t.string   "room_details"
    t.string   "amenity_details"
    t.string   "pet_ids"
    t.string   "run_ids"
    t.string   "amenity_ids"
    t.date     "check_in_date"
    t.date     "check_out_date"
    t.string   "payment_first_name"
    t.string   "payment_last_name"
    t.float    "total_price"
    t.string   "transID"
    t.string   "card_number"
    t.string   "expiration_date"
    t.string   "checked_in"
    t.string   "checked_out"
    t.string   "completed"
    t.string   "three_weeks_before_email_reminder"
    t.string   "one_week_before_email_reminder"
    t.string   "day_before_email_reminder"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "reservations", ["kennel_id"], name: "index_reservations_on_kennel_id", using: :btree
  add_index "reservations", ["user_id"], name: "index_reservations_on_user_id", using: :btree

  create_table "runs", force: :cascade do |t|
    t.integer  "kennel_id"
    t.float    "price"
    t.integer  "size_width"
    t.integer  "size_length"
    t.integer  "weight_limit"
    t.integer  "number_of_rooms"
    t.integer  "pets_per_run"
    t.string   "type_of_pets_allowed"
    t.string   "title"
    t.string   "description"
    t.string   "indoor_or_outdoor"
    t.string   "breeds_restricted"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "runs", ["kennel_id"], name: "index_runs_on_kennel_id", using: :btree

  create_table "searches", force: :cascade do |t|
    t.integer  "search_zip"
    t.integer  "radius"
    t.date     "check_in"
    t.date     "check_out"
    t.string   "cats_or_dogs"
    t.integer  "number_of_dogs"
    t.integer  "number_of_cats"
    t.integer  "number_of_rooms"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "stand_by_reservations", force: :cascade do |t|
    t.integer  "kennel_id"
    t.integer  "kennelID"
    t.integer  "runID"
    t.date     "check_in_date"
    t.date     "check_out_date"
    t.string   "customer_email"
    t.string   "expired"
    t.string   "email_sent"
    t.string   "original_search_url"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "stand_by_reservations", ["kennel_id"], name: "index_stand_by_reservations_on_kennel_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "kennel_or_customer"
    t.string   "time_zone"
    t.string   "completed_registration"
    t.integer  "userID"
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

  create_table "visits", id: :uuid, default: nil, force: :cascade do |t|
    t.uuid     "visitor_id"
    t.string   "ip"
    t.text     "user_agent"
    t.text     "referrer"
    t.text     "landing_page"
    t.integer  "user_id"
    t.string   "referring_domain"
    t.string   "search_keyword"
    t.string   "browser"
    t.string   "os"
    t.string   "device_type"
    t.integer  "screen_height"
    t.integer  "screen_width"
    t.string   "country"
    t.string   "region"
    t.string   "city"
    t.string   "postal_code"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.string   "utm_source"
    t.string   "utm_medium"
    t.string   "utm_term"
    t.string   "utm_content"
    t.string   "utm_campaign"
    t.datetime "started_at"
  end

  add_index "visits", ["user_id"], name: "index_visits_on_user_id", using: :btree

end
