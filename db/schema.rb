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

ActiveRecord::Schema.define(version: 20140103184106) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "affiliations", force: true do |t|
    t.string   "type"
    t.integer  "status",       default: 0
    t.integer  "affiliate_id"
    t.integer  "principal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "affiliations", ["affiliate_id"], name: "index_affiliations_on_affiliate_id", using: :btree
  add_index "affiliations", ["principal_id"], name: "index_affiliations_on_principal_id", using: :btree
  add_index "affiliations", ["type"], name: "index_affiliations_on_type", using: :btree

  create_table "companies", force: true do |t|
    t.string  "name"
    t.string  "address"
    t.string  "address2"
    t.string  "city"
    t.string  "state"
    t.integer "zip"
    t.string  "website"
    t.string  "phone"
    t.string  "company_type"
  end

  create_table "contacts", force: true do |t|
    t.string  "first_name"
    t.string  "last_name"
    t.string  "address"
    t.string  "address2"
    t.string  "city"
    t.string  "state"
    t.integer "zip"
    t.string  "email"
    t.string  "phone"
    t.date    "birthday"
    t.string  "prefix"
    t.string  "job_title"
    t.integer "company_id"
  end

  add_index "contacts", ["company_id"], name: "index_contacts_on_company_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
