# frozen_string_literal: true

module Engine
  class SignalObservation < ApplicationRecord
    self.table_name = "engine_signal_observations"

    belongs_to :signal, class_name: "Engine::Signal"
    belongs_to :observation, class_name: "Engine::Observation"

    validates :observation_id, uniqueness: { scope: :signal_id }
    validates :weight, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }, allow_nil: true
    validate :metadata_must_be_object
    validate :signal_cannot_precede_observation
    validate :immutable_after_create, on: :update

    private

    def metadata_must_be_object
      return if metadata.is_a?(Hash)

      errors.add(:metadata, "must be an object")
    end

    def signal_cannot_precede_observation
      return if signal&.detected_at.blank? || observation&.observed_at.blank?
      return if signal.detected_at >= observation.observed_at

      errors.add(:signal, "detected_at cannot be before observation observed_at")
    end

    def immutable_after_create
      errors.add(:base, "signal observations are immutable after creation")
    end
  end
end
