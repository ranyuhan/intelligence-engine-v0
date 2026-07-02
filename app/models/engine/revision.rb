# frozen_string_literal: true

module Engine
  class Revision < ApplicationRecord
    self.table_name = "engine_revisions"

    OUTCOMES = %w[strengthened weakened revised unchanged].freeze

    belongs_to :model, class_name: "Engine::Model"
    has_many :revision_evidences, class_name: "Engine::RevisionEvidence", dependent: :restrict_with_error
    has_many :evidences, through: :revision_evidences, class_name: "Engine::Evidence"

    validates :cause, presence: true
    validates :summary, presence: true
    validates :outcome, presence: true, inclusion: { in: OUTCOMES }
    validates :confidence_delta, presence: true,
      numericality: { greater_than_or_equal_to: -1, less_than_or_equal_to: 1 }
    validate :previous_state_must_be_object
    validate :new_state_must_be_object
    validate :metadata_must_be_object
    validate :must_have_evidence
    validate :immutable_after_create, on: :update

    private

    def previous_state_must_be_object
      return if previous_state.is_a?(Hash)

      errors.add(:previous_state, "must be an object")
    end

    def new_state_must_be_object
      return if new_state.is_a?(Hash)

      errors.add(:new_state, "must be an object")
    end

    def metadata_must_be_object
      return if metadata.is_a?(Hash)

      errors.add(:metadata, "must be an object")
    end

    def must_have_evidence
      return if revision_evidences.any? || evidences.any?

      errors.add(:base, "revisions require at least one evidence record")
    end

    def immutable_after_create
      errors.add(:base, "revisions are immutable after creation")
    end
  end
end
