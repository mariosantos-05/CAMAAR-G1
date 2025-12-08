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

ActiveRecord::Schema[8.0].define(version: 2025_12_07_233036) do
  create_table "forms", force: :cascade do |t|
    t.integer "template_id", null: false
    t.integer "turma_id", null: false
    t.boolean "is_active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["template_id"], name: "index_forms_on_template_id"
    t.index ["turma_id"], name: "index_forms_on_turma_id"
  end

  create_table "issues", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "status"
    t.integer "project_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_issues_on_project_id"
    t.index ["user_id"], name: "index_issues_on_user_id"
  end

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

  create_table "projects", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "resposta", force: :cascade do |t|
    t.integer "form_id", null: false
    t.integer "usuario_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["form_id"], name: "index_resposta_on_form_id"
    t.index ["usuario_id"], name: "index_resposta_on_usuario_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "templates", force: :cascade do |t|
    t.string "titulo"
    t.string "target_audience"
    t.integer "criado_por_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["criado_por_id"], name: "index_templates_on_criado_por_id"
  end

  create_table "turmas", force: :cascade do |t|
    t.string "nome"
    t.string "semestre"
    t.boolean "is_active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "usuarios", force: :cascade do |t|
    t.string "nome"
    t.string "matricula"
    t.string "email"
    t.boolean "status"
    t.string "profile"
    t.integer "departamento_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vinculos", force: :cascade do |t|
    t.integer "usuario_id", null: false
    t.integer "turma_id", null: false
    t.integer "papel_turma"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["turma_id"], name: "index_vinculos_on_turma_id"
    t.index ["usuario_id"], name: "index_vinculos_on_usuario_id"
  end

  add_foreign_key "forms", "templates"
  add_foreign_key "forms", "turmas"
  add_foreign_key "issues", "projects"
  add_foreign_key "issues", "users"
  add_foreign_key "resposta", "forms"
  add_foreign_key "resposta", "usuarios"
  add_foreign_key "templates", "usuarios", column: "criado_por_id"
  add_foreign_key "vinculos", "turmas"
  add_foreign_key "vinculos", "usuarios"
end
