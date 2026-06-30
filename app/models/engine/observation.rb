# frozen_string_literal: true

module Engine
  class Observation < ApplicationRecord
    self.table_name = "engine_observations"

    belongs_to :event, class_name: "Engine::Event"
    belongs_to :entity, class_name: "Engine::Entity", optional: true

    validates :observation_type, presence: true
    validates :observed_at, presence: true
    validates :source, presence: true
    validate :value_must_be_present
    validate :metadata_must_be_object
    validate :observed_at_cannot_be_future
    validate :observed_at_cannot_precede_event
    validate :entity_must_match_event_entity
    validate :immutable_after_create, on: :update

    private

    def value_must_be_present
      return unless value.nil?

      errors.add(:value, "must be present")
    end

    def metadata_must_be_object
      return if metadata.is_a?(Hash)

      errors.add(:metadata, "must be an object")
    end

    def observed_at_cannot_be_future
      return if observed_at.blank? || observed_at <= Time.current

      errors.add(:observed_at, "cannot be in the future")
    end

    def observed_at_cannot_precede_event
      return if observed_at.blank? || event&.occurred_at.blank?
      return if observed_at >= event.occurred_at

      errors.add(:observed_at, "cannot be before the event occurred")
    end

    def entity_must_match_event_entity
      return if entity.blank? || event&.entity.blank?
      return if entity == event.entity

      errors.add(:entity, "must match the event entity")
    end

    def immutable_after_create
      errors.add(:base, "observations are immutable after creation")
    end
  end
end
