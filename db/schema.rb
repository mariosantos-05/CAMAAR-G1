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

ActiveRecord::Schema[8.0].define(version: 2025_12_08_230657) do
  create_table "members", force: :cascade do |t|
    t.string "nome"
    t.string "matricula"
    t.string "curso"
    t.string "usuario"
    t.string "formacao"
    t.string "ocupacao"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "members_turmas", id: false, force: :cascade do |t|
    t.integer "turma_id", null: false
    t.integer "member_id", null: false
  end

  create_table "subjects", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "turmas", force: :cascade do |t|
    t.string "class_code"
    t.string "semester"
    t.string "time"
    t.integer "subject_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject_id"], name: "index_turmas_on_subject_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "matricula"
    t.string "email"
    t.string "password_digest"
    t.boolean "status", default: false
    t.string "profile"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["matricula"], name: "index_users_on_matricula", unique: true
  end

  add_foreign_key "turmas", "subjects"
end
