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

ActiveRecord::Schema.define(version: 2020_11_12_161415) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.integer "director_id"
    t.index ["director_id"], name: "index_active_storage_blobs_on_director_id"
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "directories", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "ancestry"
    t.integer "ancestry_depth", default: 0
    t.integer "total_files", default: 0
    t.index ["ancestry"], name: "index_directories_on_ancestry"
    t.index ["slug", "ancestry"], name: "index_directories_on_slug_and_ancestry", unique: true
    t.index ["slug"], name: "index_directories_on_slug"
  end

  create_table "directory_files", force: :cascade do |t|
    t.integer "directory_id"
    t.integer "blob_id"
    t.integer "status", default: 0
    t.index ["blob_id"], name: "index_directory_files_on_blob_id"
    t.index ["directory_id"], name: "index_directory_files_on_directory_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
