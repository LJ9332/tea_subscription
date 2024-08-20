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

ActiveRecord::Schema[7.1].define(version: 2024_08_20_044257) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "customer_subscriptions", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "subscription_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_customer_subscriptions_on_customer_id"
    t.index ["subscription_id"], name: "index_customer_subscriptions_on_subscription_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.string "address", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "title", null: false
    t.float "price", null: false
    t.integer "frequency", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tea_subscriptions", force: :cascade do |t|
    t.bigint "subscription_id", null: false
    t.bigint "tea_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscription_id"], name: "index_tea_subscriptions_on_subscription_id"
    t.index ["tea_id"], name: "index_tea_subscriptions_on_tea_id"
  end

  create_table "teas", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.float "tempature"
    t.integer "brew_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "customer_subscriptions", "customers"
  add_foreign_key "customer_subscriptions", "subscriptions"
  add_foreign_key "tea_subscriptions", "subscriptions"
  add_foreign_key "tea_subscriptions", "teas"
end
