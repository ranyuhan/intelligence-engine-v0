# frozen_string_literal: true

class CreateEngineEntities < ActiveRecord::Migration[8.1]
  def change
    create_table :engine_entities do |t|
      t.string :external_id
      t.string :entity_type, null: false
      t.string :name, null: false
      t.text :description
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end

    add_index :engine_entities, :entity_type
    add_index :engine_entities, :external_id
    add_index :engine_entities, [:entity_type, :external_id], unique: true
  end
end
