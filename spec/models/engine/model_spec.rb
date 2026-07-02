# frozen_string_literal: true

require "rails_helper"

RSpec.describe Engine::Model, type: :model do
  def create_goal
    Engine::Goal.create!(
      name: "Improve explanatory accuracy",
      goal_type: "learning",
      success_criteria: {},
      metadata: {}
    )
  end

  it "is valid with required attributes" do
    model = described_class.new(
      goal: create_goal,
      model_type: "explanatory",
      name: "Baseline explanation",
      hypothesis: "A provisional explanation.",
      state: {},
      metadata: {}
    )

    expect(model).to be_valid
  end

  it "can belong to an entity" do
    entity = Engine::Entity.create!(
      entity_type: "subject",
      external_id: "subject-1",
      name: "Subject 1",
      metadata: {}
    )

    model = described_class.new(
      goal: create_goal,
      entity: entity,
      model_type: "explanatory",
      name: "Entity explanation",
      hypothesis: "A provisional explanation.",
      state: {},
      metadata: {}
    )

    expect(model).to be_valid
  end

  it "requires goal, model type, name, hypothesis, status, and version" do
    model = described_class.new(state: {}, metadata: {})
    model.status = nil
    model.version = nil

    expect(model).not_to be_valid
    expect(model.errors[:goal]).to include("must exist")
    expect(model.errors[:model_type]).to include("can't be blank")
    expect(model.errors[:name]).to include("can't be blank")
    expect(model.errors[:hypothesis]).to include("can't be blank")
    expect(model.errors[:status]).to include("can't be blank")
    expect(model.errors[:version]).to include("can't be blank")
  end

  it "requires version to be positive" do
    model = described_class.new(
      goal: create_goal,
      model_type: "explanatory",
      name: "Invalid version",
      hypothesis: "A provisional explanation.",
      version: 0,
      state: {},
      metadata: {}
    )

    expect(model).not_to be_valid
    expect(model.errors[:version]).to include("must be greater than or equal to 1")
  end

  it "requires object-shaped state and metadata" do
    model = described_class.new(
      goal: create_goal,
      model_type: "explanatory",
      name: "Invalid shape",
      hypothesis: "A provisional explanation.",
      state: ["not", "an", "object"],
      metadata: ["not", "an", "object"]
    )

    expect(model).not_to be_valid
    expect(model.errors[:state]).to include("must be an object")
    expect(model.errors[:metadata]).to include("must be an object")
  end

  it "does not require epistemic state at model validation time in this cluster" do
    model = described_class.new(
      goal: create_goal,
      model_type: "explanatory",
      name: "No epistemic state yet",
      hypothesis: "A provisional explanation.",
      state: {},
      metadata: {}
    )

    expect(model).to be_valid
  end
end
