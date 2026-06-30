# frozen_string_literal: true

module Engine
  class Signal < ApplicationRecord
    self.table_name = "engine_signals"

    has_many :signal_observations, class_name: "Engine::SignalObservation", dependent: :restrict_with_error
    has_many :observations, through: :signal_observations
    has_many :evidences, class_name: "Engine::Evidence", dependent: :restrict_with_error

    validates :signal_type, presence: true
    validates :strength, presence: true,
      numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }
    validates :summary, presence: true
    validates :detected_at, presence: true
    validate :metadata_must_be_object
    validate :detected_at_cannot_be_future
    validate :immutable_after_create, on: :update

    private

    def metadata_must_be_object
      return if metadata.is_a?(Hash)

      errors.add(:metadata, "must be an object")
    end

    def detected_at_cannot_be_future
      return if detected_at.blank? || detected_at <= Time.current

      errors.add(:detected_at, "cannot be in the future")
    end

    def immutable_after_create
      errors.add(:base, "signals are immutable after creation")
    end
  end
end
