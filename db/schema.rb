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

ActiveRecord::Schema.define(version: 2020_03_08_134621) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "bigcategories", force: :cascade do |t|
    t.string "name_en"
    t.string "name_jp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chats", force: :cascade do |t|
    t.integer "notice_id"
    t.string "main_en"
    t.string "main_jp"
    t.string "image"
    t.integer "user_id"
    t.string "photo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subtitle_en"
    t.string "subtitle_jp"
  end

  create_table "groups", force: :cascade do |t|
    t.string "title_en"
    t.string "title_jp"
    t.integer "user_id"
    t.integer "threadtype_id"
    t.integer "seen_num", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "hash_jp"
    t.string "hash_en"
    t.boolean "deleted", default: false, null: false
    t.string "first_content_en"
    t.string "first_content_jp"
  end

  create_table "hashtags", force: :cascade do |t|
    t.string "hash_en"
    t.string "hash_jp"
    t.string "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "news", force: :cascade do |t|
    t.string "title_en"
    t.string "title_jp"
    t.string "content_en"
    t.string "content_jp"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subtitle_en"
    t.string "subtitle_jp"
  end

  create_table "notices", force: :cascade do |t|
    t.integer "notice_from"
    t.string "title_en"
    t.string "title_jp"
    t.string "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notices_users", force: :cascade do |t|
    t.integer "notice_id", null: false
    t.integer "user_id", null: false
    t.index ["notice_id"], name: "index_notices_users_on_notice_id"
    t.index ["user_id"], name: "index_notices_users_on_user_id"
  end

  create_table "policies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.text "lang"
    t.text "content_eng"
    t.text "content_jap"
    t.string "image"
    t.integer "id_ingroup"
    t.integer "user_id"
    t.integer "group_id"
    t.binary "photo", limit: 1048576
    t.string "file_name"
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subtitle_en", default: ""
    t.string "subtitle_jp", default: ""
  end

  create_table "prohibits", force: :cascade do |t|
    t.string "prohibit_words"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "following_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["follower_id", "following_id"], name: "index_relationships_on_follower_id_and_following_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
    t.index ["following_id"], name: "index_relationships_on_following_id"
  end

  create_table "reportposts", force: :cascade do |t|
    t.integer "from_user"
    t.integer "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "content"
    t.boolean "deleted", default: false, null: false
    t.string "reporttype"
  end

  create_table "reportusers", force: :cascade do |t|
    t.integer "from_user"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "content"
    t.boolean "deleted", default: false, null: false
    t.string "reporttype"
  end

  create_table "secretcategories", force: :cascade do |t|
    t.string "name_en"
    t.string "name_jp"
    t.integer "smallcategory_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "smallcategories", force: :cascade do |t|
    t.string "name_en"
    t.string "name_jp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "threadtype_groups", force: :cascade do |t|
    t.integer "group_id"
    t.integer "threadtype_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "threadtypes", force: :cascade do |t|
    t.string "type_en"
    t.string "type_jp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_notices", force: :cascade do |t|
    t.integer "notice_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "userinfos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "type"
    t.string "title_en"
    t.string "title_jp"
    t.string "message_en"
    t.string "message_jp"
    t.boolean "seen", default: false
  end

  create_table "users", force: :cascade do |t|
    t.integer "birth_year"
    t.integer "birth_month"
    t.integer "birth_day"
    t.string "name"
    t.string "email"
    t.string "country"
    t.string "gender"
    t.integer "image", default: 1
    t.binary "photo", limit: 1048576
    t.string "file_name"
    t.string "profile_en"
    t.string "profile_jp"
    t.string "password_digest"
    t.string "activation_digest"
    t.boolean "able_see", default: true
    t.string "agreement", default: "f"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.integer "notice"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "agreement_term"
    t.string "agreement_policy"
    t.string "provider"
    t.string "oauth_token"
    t.string "uid"
    t.boolean "oauth", default: false, null: false
    t.datetime "oauth_expires_at"
    t.boolean "admit", default: true
    t.string "usertype", default: "normal"
  end

end
