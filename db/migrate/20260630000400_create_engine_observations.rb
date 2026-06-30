# frozen_string_literal: true

class CreateEngineObservations < ActiveRecord::Migration[8.1]
  def change
    create_table :engine_observations do |t|
      t.references :event, null: false, foreign_key: { to_table: :engine_events }
      t.references :entity, foreign_key: { to_table: :engine_entities }
      t.string :observation_type, null: false
      t.datetime :observed_at, null: false
      t.jsonb :value, null: false, default: {}
      t.string :unit
      t.string :source, null: false
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end

    add_index :engine_observations, :observation_type
    add_index :engine_observations, :observed_at
    add_index :engine_observations, [:event_id, :observation_type]
  end
end
