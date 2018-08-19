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

ActiveRecord::Schema.define(version: 2018_08_19_005903) do

  create_table "bills", force: :cascade do |t|
    t.integer "congress"
    t.string "bill_identifier"
  end

  create_table "committees", force: :cascade do |t|
    t.string "committee_identifier"
    t.integer "congress"
    t.string "chamber"
  end

  create_table "members", force: :cascade do |t|
    t.string "member_identifier"
  end

  create_table "posts", force: :cascade do |t|
    t.integer "user_id"
    t.string "content"
    t.string "postable_type"
    t.integer "postable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["postable_type", "postable_id"], name: "index_posts_on_postable_type_and_postable_id"
  end

  create_table "reactions", force: :cascade do |t|
    t.integer "user_id"
    t.string "reactable_type"
    t.integer "reactable_id"
    t.integer "react_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reactable_type", "reactable_id"], name: "index_reactions_on_reactable_type_and_reactable_id"
  end

  create_table "states", force: :cascade do |t|
    t.string "name"
    t.string "abbreviation"
  end

  create_table "user_bills", force: :cascade do |t|
    t.integer "bill_id"
    t.integer "user_id"
  end

  create_table "user_committees", force: :cascade do |t|
    t.integer "user_id"
    t.integer "committee_id"
  end

  create_table "user_members", force: :cascade do |t|
    t.integer "member_id"
    t.integer "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.integer "state_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
