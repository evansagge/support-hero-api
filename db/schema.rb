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

ActiveRecord::Schema.define(version: 20141022231336) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

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

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "name",            null: false
    t.string   "roles",                        array: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
  end

  add_index "users", ["name"], name: "index_users_on_name", using: :btree

end
