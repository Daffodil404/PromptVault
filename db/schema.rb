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

ActiveRecord::Schema[8.1].define(version: 2026_04_03_000527) do
  create_table "prompt_versions", force: :cascade do |t|
    t.text "change_note"
    t.text "content"
    t.datetime "created_at", null: false
    t.integer "prompt_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "version_number"
    t.index ["prompt_id"], name: "index_prompt_versions_on_prompt_id"
    t.index ["user_id"], name: "index_prompt_versions_on_user_id"
  end

  create_table "prompts", force: :cascade do |t|
    t.text "abstract"
    t.text "content"
    t.datetime "created_at", null: false
    t.string "status"
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_prompts_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.text "comment"
    t.datetime "created_at", null: false
    t.integer "prompt_id", null: false
    t.integer "rating"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["prompt_id"], name: "index_reviews_on_prompt_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "role"
    t.datetime "updated_at", null: false
    t.string "username"
  end

  add_foreign_key "prompt_versions", "prompts"
  add_foreign_key "prompt_versions", "users"
  add_foreign_key "prompts", "users"
  add_foreign_key "reviews", "prompts"
  add_foreign_key "reviews", "users"
end
