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

ActiveRecord::Schema.define(version: 20170702183608) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "affirmations", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "daily_todos", force: :cascade do |t|
    t.integer  "user_id"
    t.date     "due_date"
    t.text     "content"
    t.boolean  "completed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_daily_todos_on_user_id", using: :btree
  end

  create_table "habit_todos", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "habit_id"
    t.date     "due_date"
    t.boolean  "completed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["habit_id"], name: "index_habit_todos_on_habit_id", using: :btree
    t.index ["user_id"], name: "index_habit_todos_on_user_id", using: :btree
  end

  create_table "habits", force: :cascade do |t|
    t.integer  "user_id"
    t.boolean  "active"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_habits_on_user_id", using: :btree
  end

  create_table "long_term_goals", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "category"
    t.string   "timeframe"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_long_term_goals_on_user_id", using: :btree
  end

  create_table "quarterly_todos", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "category"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_quarterly_todos_on_user_id", using: :btree
  end

  create_table "relationship_categories", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_relationship_categories_on_user_id", using: :btree
  end

  create_table "relationships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "relationship_category_id"
    t.text     "content"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["user_id"], name: "index_relationships_on_user_id", using: :btree
  end

  create_table "short_term_goals", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "long_term_goal_id"
    t.text     "category"
    t.text     "content"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["user_id"], name: "index_short_term_goals_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "purpose"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "values", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "visualizations", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "caption"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "daily_todos", "users"
  add_foreign_key "habit_todos", "habits"
  add_foreign_key "habit_todos", "users"
  add_foreign_key "habits", "users"
  add_foreign_key "long_term_goals", "users"
  add_foreign_key "quarterly_todos", "users"
  add_foreign_key "relationship_categories", "users"
  add_foreign_key "relationships", "users"
  add_foreign_key "short_term_goals", "users"
end
