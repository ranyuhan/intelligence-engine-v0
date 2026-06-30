# frozen_string_literal: true

class CreateEngineGoals < ActiveRecord::Migration[8.1]
  def change
    create_table :engine_goals do |t|
      t.string :name, null: false
      t.string :goal_type, null: false
      t.string :status, null: false, default: "active"
      t.text :description
      t.jsonb :success_criteria, null: false, default: {}
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end

    add_index :engine_goals, :name, unique: true
    add_index :engine_goals, :goal_type
    add_index :engine_goals, :status
  end
end
