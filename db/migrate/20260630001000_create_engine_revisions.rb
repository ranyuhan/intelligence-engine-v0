# frozen_string_literal: true

class CreateEngineRevisions < ActiveRecord::Migration[8.1]
  def change
    create_table :engine_revisions do |t|
      t.references :model, null: false, foreign_key: { to_table: :engine_models }
      t.string :cause, null: false
      t.text :summary, null: false
      t.string :outcome, null: false
      t.jsonb :previous_state, null: false
      t.jsonb :new_state, null: false
      t.decimal :confidence_delta, precision: 6, scale: 5, null: false, default: 0
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end

    add_index :engine_revisions, :cause
    add_index :engine_revisions, :outcome
    add_index :engine_revisions, :created_at
    add_index :engine_revisions, [:model_id, :created_at]
  end
end
