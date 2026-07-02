# frozen_string_literal: true

module Engine
  class EpistemicState < ApplicationRecord
    self.table_name = "engine_epistemic_states"

    PREDICTION_READINESS_VALUES = %w[not_ready ready withheld].freeze

    belongs_to :model, class_name: "Engine::Model"

    validates :model_id, uniqueness: true
    validates :confidence, presence: true,
      numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }
    validates :observable_coverage,
      numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 },
      allow_nil: true
    validates :prediction_readiness, presence: true, inclusion: { in: PREDICTION_READINESS_VALUES }
    validates :revision_velocity, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
    validate :known_unknowns_must_be_array
    validate :surprise_history_must_be_array
    validate :metadata_must_be_object

    private

    def known_unknowns_must_be_array
      return if known_unknowns.is_a?(Array)

      errors.add(:known_unknowns, "must be an array")
    end

    def surprise_history_must_be_array
      return if surprise_history.is_a?(Array)

      errors.add(:surprise_history, "must be an array")
    end

    def metadata_must_be_object
      return if metadata.is_a?(Hash)

      errors.add(:metadata, "must be an object")
    end
  end
end
