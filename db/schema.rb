# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2026_06_02_000001) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.date "billing_month", null: false
    t.integer "total_events", default: 0, null: false
    t.integer "included_events", default: 0, null: false
    t.integer "billable_events", default: 0, null: false
    t.decimal "amount", precision: 15, scale: 5, default: "0.0", null: false
    t.datetime "generated_at", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id", "billing_month"], name: "index_invoices_on_company_id_and_billing_month", unique: true
    t.index ["company_id"], name: "index_invoices_on_company_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name", null: false
    t.integer "included_events", null: false
    t.decimal "price_per_extra_event", precision: 10, scale: 5, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_plans_on_name", unique: true
  end

  create_table "projects", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["company_id"], name: "index_projects_on_company_id"
    t.index ["deleted_at"], name: "index_projects_on_deleted_at"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "plan_id", null: false
    t.string "status", default: "active", null: false
    t.datetime "started_at", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id", "status"], name: "index_subscriptions_on_company_id_and_status"
    t.index ["company_id"], name: "idx_one_active_subscription_per_company", unique: true, where: "((status)::text = 'active'::text)"
    t.index ["company_id"], name: "index_subscriptions_on_company_id"
    t.index ["plan_id"], name: "index_subscriptions_on_plan_id"
  end

  create_table "usage_events", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "event_type", null: false
    t.integer "quantity", null: false
    t.jsonb "metadata", default: {}
    t.datetime "occurred_at", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["occurred_at"], name: "index_usage_events_on_occurred_at"
    t.index ["project_id", "occurred_at"], name: "index_usage_events_on_project_id_and_occurred_at"
    t.index ["project_id"], name: "index_usage_events_on_project_id"
  end

  create_table "users", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "role", default: "member", null: false
    t.string "api_token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["api_token"], name: "index_users_on_api_token", unique: true
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "invoices", "companies"
  add_foreign_key "projects", "companies"
  add_foreign_key "subscriptions", "companies"
  add_foreign_key "subscriptions", "plans"
  add_foreign_key "usage_events", "projects"
  add_foreign_key "users", "companies"
end
