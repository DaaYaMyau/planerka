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

ActiveRecord::Schema[8.1].define(version: 2026_10_26_123027) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.text "summary"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bookmarks", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "story_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["story_id"], name: "index_bookmarks_on_story_id"
    t.index ["user_id", "story_id"], name: "index_bookmarks_on_user_id_and_story_id", unique: true
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "story_id", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["story_id"], name: "index_comments_on_story_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "industry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "website"
    t.text "description"
    t.string "inn"
    t.integer "status", default: 0, null: false
    t.integer "created_by_id"
    t.index ["created_by_id"], name: "index_companies_on_created_by_id"
    t.index ["inn"], name: "index_companies_on_inn", unique: true
    t.index ["slug"], name: "index_companies_on_slug", unique: true
  end

  create_table "company_representatives", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "company_id", null: false
    t.string "position", null: false
    t.string "work_email", null: false
    t.string "inn"
    t.text "proof"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_company_representatives_on_company_id"
    t.index ["user_id"], name: "index_company_representatives_on_user_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "nickname", null: false
    t.text "bio"
    t.integer "grade"
    t.integer "profession_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar"
    t.index ["nickname"], name: "index_profiles_on_nickname", unique: true
    t.index ["profession_id"], name: "index_profiles_on_profession_id"
    t.index ["user_id"], name: "index_profiles_on_user_id", unique: true
  end

  create_table "review_replies", force: :cascade do |t|
    t.integer "review_id", null: false
    t.integer "user_id", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["review_id"], name: "index_review_replies_on_review_id", unique: true
    t.index ["user_id"], name: "index_review_replies_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "company_id", null: false
    t.text "wish_i_knew", null: false
    t.text "suits"
    t.text "not_suits"
    t.integer "grade"
    t.boolean "anonymous", default: false, null: false
    t.integer "status", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "edited_after_reply", default: false, null: false
    t.index ["company_id"], name: "index_reviews_on_company_id"
    t.index ["user_id", "company_id"], name: "index_reviews_on_user_id_and_company_id", unique: true
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "stories", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "article_id"
    t.string "title"
    t.text "body"
    t.integer "grade"
    t.integer "status"
    t.boolean "anonymous"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "company_id"
    t.integer "votes_count", default: 0, null: false
    t.json "images"
    t.index ["article_id"], name: "index_stories_on_article_id"
    t.index ["company_id"], name: "index_stories_on_company_id"
    t.index ["user_id"], name: "index_stories_on_user_id"
  end

  create_table "story_tags", force: :cascade do |t|
    t.integer "story_id", null: false
    t.integer "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["story_id"], name: "index_story_tags_on_story_id"
    t.index ["tag_id"], name: "index_story_tags_on_tag_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "email", null: false
    t.datetime "consented_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_subscriptions_on_email", unique: true
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.integer "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "story_id", null: false
    t.integer "verdict"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["story_id"], name: "index_votes_on_story_id"
    t.index ["user_id", "story_id"], name: "index_votes_on_user_id_and_story_id", unique: true
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bookmarks", "stories"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "comments", "stories"
  add_foreign_key "comments", "users"
  add_foreign_key "companies", "users", column: "created_by_id"
  add_foreign_key "company_representatives", "companies"
  add_foreign_key "company_representatives", "users"
  add_foreign_key "profiles", "tags", column: "profession_id"
  add_foreign_key "profiles", "users"
  add_foreign_key "review_replies", "reviews"
  add_foreign_key "review_replies", "users"
  add_foreign_key "reviews", "companies"
  add_foreign_key "reviews", "users"
  add_foreign_key "stories", "articles"
  add_foreign_key "stories", "companies"
  add_foreign_key "stories", "users"
  add_foreign_key "story_tags", "stories"
  add_foreign_key "story_tags", "tags"
  add_foreign_key "votes", "stories"
  add_foreign_key "votes", "users"
end
