# frozen_string_literal: true

class CreateEngineModels < ActiveRecord::Migration[8.1]
  def change
    create_table :engine_models do |t|
      t.references :goal, null: false, foreign_key: { to_table: :engine_goals }
      t.references :entity, foreign_key: { to_table: :engine_entities }
      t.string :model_type, null: false
      t.string :name, null: false
      t.text :description
      t.text :hypothesis, null: false
      t.jsonb :state, null: false, default: {}
      t.string :status, null: false, default: "active"
      t.integer :version, null: false, default: 1
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end

    add_index :engine_models, :model_type
    add_index :engine_models, :status
    add_index :engine_models, [:goal_id, :model_type]
  end
end
