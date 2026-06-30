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

ActiveRecord::Schema[8.1].define(version: 2026_06_30_000400) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "engine_entities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "entity_type", null: false
    t.string "external_id"
    t.jsonb "metadata", default: {}, null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_type", "external_id"], name: "index_engine_entities_on_entity_type_and_external_id", unique: true
    t.index ["entity_type"], name: "index_engine_entities_on_entity_type"
    t.index ["external_id"], name: "index_engine_entities_on_external_id"
  end

  create_table "engine_events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.bigint "entity_id"
    t.string "event_type", null: false
    t.jsonb "metadata", default: {}, null: false
    t.datetime "occurred_at", null: false
    t.string "source", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id", "event_type", "occurred_at"], name: "idx_on_entity_id_event_type_occurred_at_a054d0d243"
    t.index ["entity_id"], name: "index_engine_events_on_entity_id"
    t.index ["event_type"], name: "index_engine_events_on_event_type"
    t.index ["occurred_at"], name: "index_engine_events_on_occurred_at"
  end

  create_table "engine_goals", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "goal_type", null: false
    t.jsonb "metadata", default: {}, null: false
    t.string "name", null: false
    t.string "status", default: "active", null: false
    t.jsonb "success_criteria", default: {}, null: false
    t.datetime "updated_at", null: false
    t.index ["goal_type"], name: "index_engine_goals_on_goal_type"
    t.index ["name"], name: "index_engine_goals_on_name", unique: true
    t.index ["status"], name: "index_engine_goals_on_status"
  end

  create_table "engine_observations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "entity_id"
    t.bigint "event_id", null: false
    t.jsonb "metadata", default: {}, null: false
    t.string "observation_type", null: false
    t.datetime "observed_at", null: false
    t.string "source", null: false
    t.string "unit"
    t.datetime "updated_at", null: false
    t.jsonb "value", default: {}, null: false
    t.index ["entity_id"], name: "index_engine_observations_on_entity_id"
    t.index ["event_id", "observation_type"], name: "index_engine_observations_on_event_id_and_observation_type"
    t.index ["event_id"], name: "index_engine_observations_on_event_id"
    t.index ["observation_type"], name: "index_engine_observations_on_observation_type"
    t.index ["observed_at"], name: "index_engine_observations_on_observed_at"
  end

  add_foreign_key "engine_events", "engine_entities", column: "entity_id"
  add_foreign_key "engine_observations", "engine_entities", column: "entity_id"
  add_foreign_key "engine_observations", "engine_events", column: "event_id"
end
