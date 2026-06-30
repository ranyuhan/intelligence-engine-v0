# frozen_string_literal: true

module Engine
  class Evidence < ApplicationRecord
    self.table_name = "engine_evidences"

    belongs_to :signal, class_name: "Engine::Signal"

    validates :evidence_type, presence: true
    validates :summary, presence: true
    validates :weight, presence: true,
      numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }
    validates :observed_at, presence: true
    validate :metadata_must_be_object
    validate :observed_at_cannot_be_future
    validate :observed_at_cannot_precede_signal
    validate :signal_must_trace_to_observable_reality
    validate :immutable_after_create, on: :update

    private

    def metadata_must_be_object
      return if metadata.is_a?(Hash)

      errors.add(:metadata, "must be an object")
    end

    def observed_at_cannot_be_future
      return if observed_at.blank? || observed_at <= Time.current

      errors.add(:observed_at, "cannot be in the future")
    end

    def observed_at_cannot_precede_signal
      return if observed_at.blank? || signal&.detected_at.blank?
      return if observed_at >= signal.detected_at

      errors.add(:observed_at, "cannot be before the signal was detected")
    end

    def signal_must_trace_to_observable_reality
      return if signal.blank?
      return if signal.signal_observations.any? { |signal_observation| signal_observation.observation&.event.present? }

      errors.add(:signal, "must trace to at least one observation with an event")
    end

    def immutable_after_create
      errors.add(:base, "evidence is immutable after creation")
    end
  end
end
