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

ActiveRecord::Schema.define(version: 20180531114544) do

  create_table "attendance_codes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "class_sessions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "start_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "period"
    t.bigint "room_id"
    t.index ["room_id"], name: "index_class_sessions_on_room_id"
  end

  create_table "hash_values", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "value"
    t.bigint "class_session_id"
    t.bigint "attendance_code_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "major"
    t.string "minor"
    t.index ["attendance_code_id"], name: "index_hash_values_on_attendance_code_id"
    t.index ["class_session_id"], name: "index_hash_values_on_class_session_id"
  end

  create_table "presences", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.bigint "class_session_id"
    t.bigint "student_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "attendance_code_id"
    t.index ["attendance_code_id"], name: "index_presences_on_attendance_code_id"
    t.index ["class_session_id"], name: "index_presences_on_class_session_id"
    t.index ["student_id"], name: "index_presences_on_student_id"
  end

  create_table "rooms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "number"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "students", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "username"
    t.string "auth_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "class_sessions", "rooms"
  add_foreign_key "hash_values", "attendance_codes"
  add_foreign_key "hash_values", "class_sessions"
  add_foreign_key "presences", "attendance_codes"
  add_foreign_key "presences", "class_sessions"
  add_foreign_key "presences", "students"
end
