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

ActiveRecord::Schema[7.2].define(version: 2024_10_09_204651) do
  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

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

  create_table "automations_actions", force: :cascade do |t|
    t.integer "automation_id", null: false
    t.integer "position", null: false
    t.string "name", default: "", null: false
    t.string "handler_class_name", default: "", null: false
    t.text "configuration_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["automation_id"], name: "index_automations_actions_on_automation_id"
  end

  create_table "automations_automations", force: :cascade do |t|
    t.string "container_type"
    t.integer "container_id"
    t.string "type"
    t.string "name", default: "", null: false
    t.integer "status", default: 0, null: false
    t.text "configuration_data"
    t.string "configuration_class_name", default: "", null: false
    t.string "before_trigger_class_name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["container_id", "container_type", "status", "type"], name: "idx_on_container_id_container_type_status_type_88c50d46bb"
    t.index ["container_type", "container_id"], name: "index_automations_automations_on_container"
  end

  create_table "documents", force: :cascade do |t|
    t.integer "folder_id"
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["folder_id"], name: "index_documents_on_folder_id"
  end

  create_table "documents_reviews", id: false, force: :cascade do |t|
    t.integer "review_id", null: false
    t.integer "document_id", null: false
  end

  create_table "folders", force: :cascade do |t|
    t.integer "project_id"
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_folders_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "workflows_categories", force: :cascade do |t|
    t.string "container_type"
    t.integer "container_id"
    t.string "name", default: "", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["container_type", "container_id"], name: "index_workflows_categories_on_container"
  end

  create_table "workflows_default_assignments", force: :cascade do |t|
    t.integer "stage_id"
    t.string "user_type"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stage_id"], name: "index_workflows_default_assignments_on_stage_id"
    t.index ["user_type", "user_id"], name: "index_workflows_default_assignments_on_user"
  end

  create_table "workflows_options", force: :cascade do |t|
    t.integer "stage_id"
    t.string "name", default: "", null: false
    t.string "colour", default: "#888888", null: false
    t.integer "destination_stage_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["destination_stage_id"], name: "index_workflows_options_on_destination_stage_id"
    t.index ["stage_id"], name: "index_workflows_options_on_stage_id"
  end

  create_table "workflows_stages", force: :cascade do |t|
    t.integer "template_id"
    t.string "name", default: "", null: false
    t.integer "status", default: 0, null: false
    t.integer "position", default: 1, null: false
    t.integer "default_deadline", default: 1, null: false
    t.integer "deadline_type", default: 0, null: false
    t.integer "completion_type", default: 0, null: false
    t.integer "stage_type", default: 1, null: false
    t.string "colour", default: "#aaaaaa", null: false
    t.string "form_template_type"
    t.integer "form_template_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["form_template_type", "form_template_id"], name: "index_workflows_stages_on_form_template"
    t.index ["template_id"], name: "index_workflows_stages_on_template_id"
  end

  create_table "workflows_templates", force: :cascade do |t|
    t.integer "category_id"
    t.string "name", default: "", null: false
    t.string "default_owner_type"
    t.integer "default_owner_id"
    t.integer "default_deadline", default: 1, null: false
    t.integer "position", default: 1, null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_workflows_templates_on_category_id"
    t.index ["default_owner_type", "default_owner_id"], name: "index_workflows_templates_on_default_owner"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "automations_actions", "automations_automations", column: "automation_id"
  add_foreign_key "documents", "folders"
  add_foreign_key "folders", "projects"
  add_foreign_key "workflows_default_assignments", "workflows_stages", column: "stage_id"
  add_foreign_key "workflows_options", "workflows_stages", column: "destination_stage_id"
  add_foreign_key "workflows_options", "workflows_stages", column: "stage_id"
  add_foreign_key "workflows_stages", "workflows_templates", column: "template_id"
  add_foreign_key "workflows_templates", "workflows_categories", column: "category_id"
end
