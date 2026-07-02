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

ActiveRecord::Schema[8.1].define(version: 2026_06_30_001100) do
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

  create_table "engine_epistemic_states", force: :cascade do |t|
    t.decimal "confidence", precision: 6, scale: 5, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.jsonb "known_unknowns", default: [], null: false
    t.datetime "last_revised_at"
    t.jsonb "metadata", default: {}, null: false
    t.bigint "model_id", null: false
    t.decimal "observable_coverage", precision: 6, scale: 5
    t.string "prediction_readiness", default: "not_ready", null: false
    t.decimal "revision_velocity", precision: 10, scale: 5
    t.jsonb "surprise_history", default: [], null: false
    t.datetime "updated_at", null: false
    t.index ["last_revised_at"], name: "index_engine_epistemic_states_on_last_revised_at"
    t.index ["model_id"], name: "index_engine_epistemic_states_on_model_id", unique: true
    t.index ["prediction_readiness"], name: "index_engine_epistemic_states_on_prediction_readiness"
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

  create_table "engine_evidences", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "evidence_type", null: false
    t.jsonb "metadata", default: {}, null: false
    t.datetime "observed_at", null: false
    t.bigint "signal_id", null: false
    t.text "summary", null: false
    t.datetime "updated_at", null: false
    t.decimal "weight", precision: 6, scale: 5, null: false
    t.index ["evidence_type"], name: "index_engine_evidences_on_evidence_type"
    t.index ["observed_at"], name: "index_engine_evidences_on_observed_at"
    t.index ["signal_id", "evidence_type"], name: "index_engine_evidences_on_signal_id_and_evidence_type"
    t.index ["signal_id"], name: "index_engine_evidences_on_signal_id"
    t.index ["weight"], name: "index_engine_evidences_on_weight"
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

  create_table "engine_models", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.bigint "entity_id"
    t.bigint "goal_id", null: false
    t.text "hypothesis", null: false
    t.jsonb "metadata", default: {}, null: false
    t.string "model_type", null: false
    t.string "name", null: false
    t.jsonb "state", default: {}, null: false
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.integer "version", default: 1, null: false
    t.index ["entity_id"], name: "index_engine_models_on_entity_id"
    t.index ["goal_id", "model_type"], name: "index_engine_models_on_goal_id_and_model_type"
    t.index ["goal_id"], name: "index_engine_models_on_goal_id"
    t.index ["model_type"], name: "index_engine_models_on_model_type"
    t.index ["status"], name: "index_engine_models_on_status"
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

  create_table "engine_revision_evidences", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "evidence_id", null: false
    t.jsonb "metadata", default: {}, null: false
    t.bigint "revision_id", null: false
    t.string "role"
    t.datetime "updated_at", null: false
    t.decimal "weight", precision: 6, scale: 5
    t.index ["evidence_id"], name: "index_engine_revision_evidences_on_evidence_id"
    t.index ["revision_id", "evidence_id"], name: "index_engine_revision_evidences_uniqueness", unique: true
    t.index ["revision_id"], name: "index_engine_revision_evidences_on_revision_id"
  end

  create_table "engine_revisions", force: :cascade do |t|
    t.string "cause", null: false
    t.decimal "confidence_delta", precision: 6, scale: 5, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.jsonb "metadata", default: {}, null: false
    t.bigint "model_id", null: false
    t.jsonb "new_state", null: false
    t.string "outcome", null: false
    t.jsonb "previous_state", null: false
    t.text "summary", null: false
    t.datetime "updated_at", null: false
    t.index ["cause"], name: "index_engine_revisions_on_cause"
    t.index ["created_at"], name: "index_engine_revisions_on_created_at"
    t.index ["model_id", "created_at"], name: "index_engine_revisions_on_model_id_and_created_at"
    t.index ["model_id"], name: "index_engine_revisions_on_model_id"
    t.index ["outcome"], name: "index_engine_revisions_on_outcome"
  end

  create_table "engine_signal_observations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.jsonb "metadata", default: {}, null: false
    t.bigint "observation_id", null: false
    t.string "role"
    t.bigint "signal_id", null: false
    t.datetime "updated_at", null: false
    t.decimal "weight", precision: 6, scale: 5
    t.index ["observation_id"], name: "index_engine_signal_observations_on_observation_id"
    t.index ["signal_id", "observation_id"], name: "index_engine_signal_observations_uniqueness", unique: true
    t.index ["signal_id"], name: "index_engine_signal_observations_on_signal_id"
  end

  create_table "engine_signals", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "detected_at", null: false
    t.string "direction"
    t.jsonb "metadata", default: {}, null: false
    t.string "signal_type", null: false
    t.decimal "strength", precision: 6, scale: 5, null: false
    t.text "summary", null: false
    t.datetime "updated_at", null: false
    t.index ["detected_at"], name: "index_engine_signals_on_detected_at"
    t.index ["signal_type"], name: "index_engine_signals_on_signal_type"
    t.index ["strength"], name: "index_engine_signals_on_strength"
  end

  add_foreign_key "engine_epistemic_states", "engine_models", column: "model_id"
  add_foreign_key "engine_events", "engine_entities", column: "entity_id"
  add_foreign_key "engine_evidences", "engine_signals", column: "signal_id"
  add_foreign_key "engine_models", "engine_entities", column: "entity_id"
  add_foreign_key "engine_models", "engine_goals", column: "goal_id"
  add_foreign_key "engine_observations", "engine_entities", column: "entity_id"
  add_foreign_key "engine_observations", "engine_events", column: "event_id"
  add_foreign_key "engine_revision_evidences", "engine_evidences", column: "evidence_id"
  add_foreign_key "engine_revision_evidences", "engine_revisions", column: "revision_id"
  add_foreign_key "engine_revisions", "engine_models", column: "model_id"
  add_foreign_key "engine_signal_observations", "engine_observations", column: "observation_id"
  add_foreign_key "engine_signal_observations", "engine_signals", column: "signal_id"
end
