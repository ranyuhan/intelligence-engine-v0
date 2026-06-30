# frozen_string_literal: true

class CreateEngineSignals < ActiveRecord::Migration[8.1]
  def change
    create_table :engine_signals do |t|
      t.string :signal_type, null: false
      t.decimal :strength, precision: 6, scale: 5, null: false
      t.string :direction
      t.text :summary, null: false
      t.datetime :detected_at, null: false
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end

    add_index :engine_signals, :signal_type
    add_index :engine_signals, :detected_at
    add_index :engine_signals, :strength
  end
end
