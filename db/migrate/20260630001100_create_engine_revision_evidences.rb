# frozen_string_literal: true

class CreateEngineRevisionEvidences < ActiveRecord::Migration[8.1]
  def change
    create_table :engine_revision_evidences do |t|
      t.references :revision, null: false, foreign_key: { to_table: :engine_revisions }
      t.references :evidence, null: false, foreign_key: { to_table: :engine_evidences }
      t.string :role
      t.decimal :weight, precision: 6, scale: 5
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end

    add_index :engine_revision_evidences,
      [:revision_id, :evidence_id],
      unique: true,
      name: "index_engine_revision_evidences_uniqueness"
  end
end
