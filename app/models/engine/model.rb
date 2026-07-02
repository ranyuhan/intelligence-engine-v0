# frozen_string_literal: true

module Engine
  class Model < ApplicationRecord
    self.table_name = "engine_models"

    belongs_to :goal, class_name: "Engine::Goal"
    belongs_to :entity, class_name: "Engine::Entity", optional: true
    has_one :epistemic_state, class_name: "Engine::EpistemicState", dependent: :restrict_with_error
    has_many :revisions, class_name: "Engine::Revision", dependent: :restrict_with_error

    validates :model_type, presence: true
    validates :name, presence: true
    validates :hypothesis, presence: true
    validates :status, presence: true
    validates :version, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
    validate :state_must_be_object
    validate :metadata_must_be_object

    private

    def state_must_be_object
      return if state.is_a?(Hash)

      errors.add(:state, "must be an object")
    end

    def metadata_must_be_object
      return if metadata.is_a?(Hash)

      errors.add(:metadata, "must be an object")
    end
  end
end
