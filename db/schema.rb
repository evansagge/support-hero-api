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

ActiveRecord::Schema.define(version: 20141023221831) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "oauth_access_grants", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "resource_owner_id", null: false
    t.uuid     "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "resource_owner_id"
    t.uuid     "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "name",         null: false
    t.string   "uid",          null: false
    t.string   "secret",       null: false
    t.text     "redirect_uri", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "support_order_users", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid    "support_order_id", null: false
    t.uuid    "user_id",          null: false
    t.integer "position",         null: false
  end

  add_index "support_order_users", ["support_order_id", "position"], name: "index_support_order_users_on_support_order_id_and_position", using: :btree

  create_table "support_orders", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.date     "start_at",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "support_orders", ["start_at"], name: "index_support_orders_on_start_at", using: :btree

  create_table "swapped_schedules", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.date     "original_date"
    t.date     "target_date"
    t.uuid     "original_user_id"
    t.uuid     "target_user_id"
    t.boolean  "approved"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "undoable_schedules", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.date     "date",                       null: false
    t.string   "reason"
    t.uuid     "user_id",                    null: false
    t.boolean  "approved",   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "undoable_schedules", ["date"], name: "index_undoable_schedules_on_date", unique: true, using: :btree
  add_index "undoable_schedules", ["user_id"], name: "index_undoable_schedules_on_user_id", using: :btree

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "name",            null: false
    t.string   "roles",                        array: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
  end

  add_index "users", ["name"], name: "index_users_on_name", using: :btree

end
