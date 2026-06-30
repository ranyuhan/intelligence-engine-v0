# frozen_string_literal: true

module Engine
  class Goal < ApplicationRecord
    self.table_name = "engine_goals"

    validates :name, presence: true, uniqueness: true
    validates :goal_type, presence: true
    validates :status, presence: true
    validate :success_criteria_must_be_object
    validate :metadata_must_be_object

    private

    def success_criteria_must_be_object
      return if success_criteria.is_a?(Hash)

      errors.add(:success_criteria, "must be an object")
    end

    def metadata_must_be_object
      return if metadata.is_a?(Hash)

      errors.add(:metadata, "must be an object")
    end
  end
end
