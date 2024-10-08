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

ActiveRecord::Schema[7.2].define(version: 2024_08_17_010940) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "examples", force: :cascade do |t|
    t.string "example", null: false
    t.bigint "word_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["word_id"], name: "index_examples_on_word_id"
  end

  create_table "histories", force: :cascade do |t|
    t.datetime "datetime", null: false
    t.boolean "result", null: false
    t.float "duration", null: false
    t.bigint "word_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["word_id"], name: "index_histories_on_word_id"
  end

  create_table "meanings", force: :cascade do |t|
    t.string "meaning", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "word_id", null: false
    t.index ["word_id"], name: "index_meanings_on_word_id"
  end

  create_table "words", force: :cascade do |t|
    t.string "word", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "examples", "words"
  add_foreign_key "histories", "words"
  add_foreign_key "meanings", "words"
end
