# frozen_string_literal: true

class CreateEngineEvidences < ActiveRecord::Migration[8.1]
  def change
    create_table :engine_evidences do |t|
      t.references :signal, null: false, foreign_key: { to_table: :engine_signals }
      t.string :evidence_type, null: false
      t.text :summary, null: false
      t.decimal :weight, precision: 6, scale: 5, null: false
      t.datetime :observed_at, null: false
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end

    add_index :engine_evidences, :evidence_type
    add_index :engine_evidences, :observed_at
    add_index :engine_evidences, :weight
    add_index :engine_evidences, [:signal_id, :evidence_type]
  end
end
