# frozen_string_literal: true

module Engine
  class RevisionEvidence < ApplicationRecord
    self.table_name = "engine_revision_evidences"

    belongs_to :revision, class_name: "Engine::Revision"
    belongs_to :evidence, class_name: "Engine::Evidence"

    validates :evidence_id, uniqueness: { scope: :revision_id }
    validates :weight, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }, allow_nil: true
    validate :metadata_must_be_object
    validate :immutable_after_create, on: :update

    private

    def metadata_must_be_object
      return if metadata.is_a?(Hash)

      errors.add(:metadata, "must be an object")
    end

    def immutable_after_create
      errors.add(:base, "revision evidence links are immutable after creation")
    end
  end
end
