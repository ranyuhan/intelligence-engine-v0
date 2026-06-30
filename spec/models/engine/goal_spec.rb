# frozen_string_literal: true

require "rails_helper"

RSpec.describe Engine::Goal, type: :model do
  it "is valid with required attributes" do
    goal = described_class.new(
      name: "Improve explanatory accuracy",
      goal_type: "learning",
      success_criteria: { "measure" => "revision quality" },
      metadata: {}
    )

    expect(goal).to be_valid
  end

  it "requires a name, goal type, and status" do
    goal = described_class.new(success_criteria: {}, metadata: {})
    goal.status = nil

    expect(goal).not_to be_valid
    expect(goal.errors[:name]).to include("can't be blank")
    expect(goal.errors[:goal_type]).to include("can't be blank")
    expect(goal.errors[:status]).to include("can't be blank")
  end

  it "requires a unique name" do
    described_class.create!(
      name: "Understand reality",
      goal_type: "learning",
      success_criteria: {},
      metadata: {}
    )

    duplicate = described_class.new(
      name: "Understand reality",
      goal_type: "learning",
      success_criteria: {},
      metadata: {}
    )

    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:name]).to include("has already been taken")
  end

  it "requires object-shaped success criteria and metadata" do
    goal = described_class.new(
      name: "Invalid shape",
      goal_type: "learning",
      success_criteria: ["not", "an", "object"],
      metadata: ["not", "an", "object"]
    )

    expect(goal).not_to be_valid
    expect(goal.errors[:success_criteria]).to include("must be an object")
    expect(goal.errors[:metadata]).to include("must be an object")
  end
end
