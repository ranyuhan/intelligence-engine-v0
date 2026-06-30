# frozen_string_literal: true

class CreateEngineEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :engine_events do |t|
      t.references :entity, foreign_key: { to_table: :engine_entities }
      t.string :event_type, null: false
      t.datetime :occurred_at, null: false
      t.string :source, null: false
      t.text :description
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end

    add_index :engine_events, :event_type
    add_index :engine_events, :occurred_at
    add_index :engine_events, [:entity_id, :event_type, :occurred_at]
  end
end
