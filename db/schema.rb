# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_12_21_165128) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "banners", force: :cascade do |t|
    t.boolean "current"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bookings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "training_session_id", null: false
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "CNY", null: false
    t.boolean "cancelled", null: false
    t.datetime "cancelled_at", null: false
    t.boolean "attended", null: false
    t.string "booked_with"
    t.bigint "membership_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["membership_id"], name: "index_bookings_on_membership_id"
    t.index ["training_session_id"], name: "index_bookings_on_training_session_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "class_types", force: :cascade do |t|
    t.integer "price_1_cents", default: 0, null: false
    t.string "price_1_currency", default: "CNY", null: false
    t.integer "price_2_cents", default: 0, null: false
    t.string "price_2_currency", default: "CNY", null: false
    t.integer "price_3_cents", default: 0, null: false
    t.string "price_3_currency", default: "CNY", null: false
    t.integer "price_4_cents", default: 0, null: false
    t.string "price_4_currency", default: "CNY", null: false
    t.integer "price_5_cents", default: 0, null: false
    t.string "price_5_currency", default: "CNY", null: false
    t.integer "price_6_cents", default: 0, null: false
    t.string "price_6_currency", default: "CNY", null: false
    t.integer "price_7_cents", default: 0, null: false
    t.string "price_7_currency", default: "CNY", null: false
    t.string "name", null: false
    t.integer "kind", null: false
    t.integer "cancel_before", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "membership_types", force: :cascade do |t|
    t.string "name", null: false
    t.integer "duration", null: false
    t.string "cn_name", null: false
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "CNY", null: false
    t.boolean "smoothie", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "membership_type_id", null: false
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.string "cn_name", null: false
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "CNY", null: false
    t.datetime "start_end"
    t.datetime "end_date"
    t.boolean "smoothie"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["membership_type_id"], name: "index_memberships_on_membership_type_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "training_sessions", force: :cascade do |t|
    t.string "queue"
    t.bigint "training_id", null: false
    t.datetime "begins_at", null: false
    t.bigint "user_id", null: false
    t.integer "duration", null: false
    t.integer "capacity", null: false
    t.integer "calories"
    t.string "name", null: false
    t.string "cn_name", null: false
    t.integer "price_1_cents", default: 0, null: false
    t.string "price_1_currency", default: "CNY", null: false
    t.integer "price_2_cents", default: 0, null: false
    t.string "price_2_currency", default: "CNY", null: false
    t.integer "price_3_cents", default: 0, null: false
    t.string "price_3_currency", default: "CNY", null: false
    t.integer "price_4_cents", default: 0, null: false
    t.string "price_4_currency", default: "CNY", null: false
    t.integer "price_5_cents", default: 0, null: false
    t.string "price_5_currency", default: "CNY", null: false
    t.integer "price_6_cents", default: 0, null: false
    t.string "price_6_currency", default: "CNY", null: false
    t.integer "price_7_cents", default: 0, null: false
    t.string "price_7_currency", default: "CNY", null: false
    t.string "description", null: false
    t.string "cn_description", null: false
    t.integer "class_kind", null: false
    t.integer "cancel_before", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["training_id"], name: "index_training_sessions_on_training_id"
    t.index ["user_id"], name: "index_training_sessions_on_user_id"
  end

  create_table "trainings", force: :cascade do |t|
    t.string "name", null: false
    t.integer "calories"
    t.integer "duration", null: false
    t.integer "capacity", null: false
    t.bigint "class_type_id", null: false
    t.text "description", null: false
    t.string "cn_name", null: false
    t.text "cn_description", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["class_type_id"], name: "index_trainings_on_class_type_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "city"
    t.string "wechat"
    t.string "phone"
    t.string "gender"
    t.boolean "admin", default: false
    t.string "wx_open_id"
    t.string "wx_session_key"
    t.string "first_name"
    t.string "last_name"
    t.string "workout_name"
    t.string "emergency_name"
    t.string "emergency_phone"
    t.date "birthday"
    t.string "nationality"
    t.string "profession"
    t.string "profession_activity_level"
    t.string "favorite_song"
    t.string "music_styles"
    t.string "sports"
    t.text "favorite_food"
    t.integer "voucher_count", default: 5, null: false
    t.boolean "instructor", default: false, null: false
    t.string "instructor_bio"
    t.string "cn_instructor_bio"
    t.integer "height"
    t.integer "current_weight"
    t.integer "current_body_fat"
    t.string "current_shapes"
    t.string "target"
    t.integer "target_weight"
    t.integer "target_body_fat"
    t.string "target_shapes"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bookings", "memberships"
  add_foreign_key "bookings", "training_sessions"
  add_foreign_key "bookings", "users"
  add_foreign_key "memberships", "membership_types"
  add_foreign_key "memberships", "users"
  add_foreign_key "training_sessions", "trainings"
  add_foreign_key "training_sessions", "users"
  add_foreign_key "trainings", "class_types"
end
