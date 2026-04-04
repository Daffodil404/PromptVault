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

ActiveRecord::Schema[8.1].define(version: 2026_04_04_163000) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "profiles", force: :cascade do |t|
    t.integer "avatar_offset_x", default: 50, null: false
    t.integer "avatar_offset_y", default: 50, null: false
    t.decimal "avatar_zoom", precision: 3, scale: 2, default: "1.0", null: false
    t.text "bio"
    t.datetime "created_at", null: false
    t.string "favorite_prompt_style"
    t.string "location"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.string "website"
    t.index ["user_id"], name: "index_profiles_on_user_id", unique: true
  end

  create_table "prompt_taggings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "prompt_id", null: false
    t.integer "tag_id", null: false
    t.datetime "updated_at", null: false
    t.index ["prompt_id", "tag_id"], name: "index_prompt_taggings_on_prompt_id_and_tag_id", unique: true
    t.index ["prompt_id"], name: "index_prompt_taggings_on_prompt_id"
    t.index ["tag_id"], name: "index_prompt_taggings_on_tag_id"
  end

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

  create_table "tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "authentication_token"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "role"
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "profiles", "users"
  add_foreign_key "prompt_taggings", "prompts"
  add_foreign_key "prompt_taggings", "tags"
  add_foreign_key "prompt_versions", "prompts"
  add_foreign_key "prompt_versions", "users"
  add_foreign_key "prompts", "users"
  add_foreign_key "reviews", "prompts"
  add_foreign_key "reviews", "users"
end
