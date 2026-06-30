# frozen_string_literal: true

class CreateEngineSignalObservations < ActiveRecord::Migration[8.1]
  def change
    create_table :engine_signal_observations do |t|
      t.references :signal, null: false, foreign_key: { to_table: :engine_signals }
      t.references :observation, null: false, foreign_key: { to_table: :engine_observations }
      t.string :role
      t.decimal :weight, precision: 6, scale: 5
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end

    add_index :engine_signal_observations,
      [:signal_id, :observation_id],
      unique: true,
      name: "index_engine_signal_observations_uniqueness"
  end
end
