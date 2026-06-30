# frozen_string_literal: true

module Engine
  class Event < ApplicationRecord
    self.table_name = "engine_events"

    belongs_to :entity, class_name: "Engine::Entity", optional: true
    has_many :observations, class_name: "Engine::Observation", dependent: :restrict_with_error

    validates :event_type, presence: true
    validates :occurred_at, presence: true
    validates :source, presence: true
    validate :metadata_must_be_object
    validate :occurred_at_cannot_be_future
    validate :immutable_after_create, on: :update

    private

    def metadata_must_be_object
      return if metadata.is_a?(Hash)

      errors.add(:metadata, "must be an object")
    end

    def occurred_at_cannot_be_future
      return if occurred_at.blank? || occurred_at <= Time.current

      errors.add(:occurred_at, "cannot be in the future")
    end

    def immutable_after_create
      errors.add(:base, "events are immutable after creation")
    end
  end
end
