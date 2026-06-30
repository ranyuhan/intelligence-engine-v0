# frozen_string_literal: true

module Engine
  class Entity < ApplicationRecord
    self.table_name = "engine_entities"

    has_many :events, class_name: "Engine::Event", dependent: :restrict_with_error
    has_many :observations, class_name: "Engine::Observation", dependent: :restrict_with_error

    validates :entity_type, presence: true
    validates :name, presence: true
    validates :external_id, uniqueness: { scope: :entity_type }, allow_nil: true
    validate :metadata_must_be_object
    validate :identity_fields_are_stable, on: :update

    private

    def metadata_must_be_object
      return if metadata.is_a?(Hash)

      errors.add(:metadata, "must be an object")
    end

    def identity_fields_are_stable
      errors.add(:entity_type, "cannot change after creation") if will_save_change_to_entity_type?
      errors.add(:external_id, "cannot change after creation") if will_save_change_to_external_id?
    end
  end
end
