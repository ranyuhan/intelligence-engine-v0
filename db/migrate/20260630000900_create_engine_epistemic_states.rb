# frozen_string_literal: true

class CreateEngineEpistemicStates < ActiveRecord::Migration[8.1]
  def change
    create_table :engine_epistemic_states do |t|
      t.references :model, null: false, foreign_key: { to_table: :engine_models }
      t.decimal :confidence, precision: 6, scale: 5, null: false, default: 0
      t.decimal :observable_coverage, precision: 6, scale: 5
      t.jsonb :known_unknowns, null: false, default: []
      t.string :prediction_readiness, null: false, default: "not_ready"
      t.jsonb :surprise_history, null: false, default: []
      t.decimal :revision_velocity, precision: 10, scale: 5
      t.datetime :last_revised_at
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end

    add_index :engine_epistemic_states, :model_id, unique: true
    add_index :engine_epistemic_states, :prediction_readiness
    add_index :engine_epistemic_states, :last_revised_at
  end
end
