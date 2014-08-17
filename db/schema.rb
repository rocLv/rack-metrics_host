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

ActiveRecord::Schema.define(version: 20140419074913) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alerts", force: true do |t|
    t.integer  "project_id"
    t.boolean  "active"
    t.integer  "response_time_treshold"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "alerts", ["project_id"], name: "index_alerts_on_project_id", using: :btree

  create_table "api_requests", force: true do |t|
    t.integer "project_id"
    t.string  "api_version"
    t.text    "data"
  end

  create_table "invitations", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.string   "email"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["project_id"], name: "index_invitations_on_project_id", using: :btree
  add_index "invitations", ["user_id"], name: "index_invitations_on_user_id", using: :btree

  create_table "plans", force: true do |t|
    t.string   "name"
    t.string   "stripe_id"
    t.text     "description"
    t.float    "price"
    t.integer  "max_projects"
    t.integer  "max_members"
    t.boolean  "is_default"
    t.integer  "position"
    t.boolean  "highlight",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",         default: true
    t.boolean  "display",        default: true
    t.integer  "data_retention"
    t.integer  "max_requests"
  end

  add_index "plans", ["display"], name: "index_plans_on_display", using: :btree

  create_table "projects", force: true do |t|
    t.integer  "owner_id"
    t.string   "name"
    t.string   "api_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["owner_id"], name: "index_projects_on_owner_id", using: :btree

  create_table "projects_users", force: true do |t|
    t.integer "project_id"
    t.integer "user_id"
  end

  add_index "projects_users", ["project_id"], name: "index_projects_users_on_project_id", using: :btree
  add_index "projects_users", ["user_id"], name: "index_projects_users_on_user_id", using: :btree

  create_table "queries", force: true do |t|
    t.integer  "render_id"
    t.string   "name"
    t.text     "query"
    t.text     "stack_trace"
    t.float    "duration",    default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
  end

  add_index "queries", ["project_id"], name: "index_queries_on_project_id", using: :btree
  add_index "queries", ["render_id"], name: "index_queries_on_render_id", using: :btree

  create_table "renders", force: true do |t|
    t.integer  "request_id"
    t.string   "layout"
    t.string   "view"
    t.float    "duration",   default: 0.0
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
  end

  add_index "renders", ["depth"], name: "index_renders_on_depth", using: :btree
  add_index "renders", ["lft"], name: "index_renders_on_lft", using: :btree
  add_index "renders", ["parent_id"], name: "index_renders_on_parent_id", using: :btree
  add_index "renders", ["project_id"], name: "index_renders_on_project_id", using: :btree
  add_index "renders", ["request_id"], name: "index_renders_on_request_id", using: :btree
  add_index "renders", ["rgt"], name: "index_renders_on_rgt", using: :btree

  create_table "requests", force: true do |t|
    t.integer  "project_id"
    t.string   "env"
    t.string   "name"
    t.string   "controller"
    t.string   "action"
    t.string   "method"
    t.string   "format"
    t.text     "path"
    t.datetime "started"
    t.integer  "status"
    t.float    "duration",     default: 0.0
    t.float    "view_runtime", default: 0.0
    t.float    "db_runtime",   default: 0.0
    t.float    "memory",       default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "requests", ["duration"], name: "index_requests_on_duration", using: :btree
  add_index "requests", ["env"], name: "index_requests_on_env", using: :btree
  add_index "requests", ["name"], name: "index_requests_on_name", using: :btree
  add_index "requests", ["project_id"], name: "index_requests_on_project_id", using: :btree
  add_index "requests", ["started"], name: "index_requests_on_started", using: :btree
  add_index "requests", ["status"], name: "index_requests_on_status", using: :btree

  create_table "subscriptions", force: true do |t|
    t.integer  "user_id"
    t.string   "stripe_id"
    t.integer  "plan_id"
    t.string   "last_four"
    t.integer  "coupon_id"
    t.string   "card_type"
    t.float    "current_price"
    t.string   "stripe_customer_token"
    t.string   "stripe_card_token"
    t.boolean  "canceled",              default: false
    t.date     "period_ends"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",                 default: false
    t.boolean  "admin",                  default: false
    t.string   "time_zone",              default: "UTC"
  end

  add_index "users", ["active"], name: "index_users_on_active", using: :btree
  add_index "users", ["admin"], name: "index_users_on_admin", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
