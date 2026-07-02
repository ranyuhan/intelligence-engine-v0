# frozen_string_literal: true

require "rails_helper"

RSpec.describe Engine::EpistemicState, type: :model do
  def create_model
    goal = Engine::Goal.create!(
      name: "Improve explanatory accuracy",
      goal_type: "learning",
      success_criteria: {},
      metadata: {}
    )

    Engine::Model.create!(
      goal: goal,
      model_type: "explanatory",
      name: "Baseline explanation",
      hypothesis: "A provisional explanation.",
      state: {},
      metadata: {}
    )
  end

  it "is valid with required attributes" do
    epistemic_state = described_class.new(
      model: create_model,
      confidence: 0.5,
      observable_coverage: 0.25,
      known_unknowns: [],
      prediction_readiness: "not_ready",
      surprise_history: [],
      revision_velocity: 0,
      metadata: {}
    )

    expect(epistemic_state).to be_valid
  end

  it "requires a model, confidence, and prediction readiness" do
    epistemic_state = described_class.new(known_unknowns: [], surprise_history: [], metadata: {})
    epistemic_state.confidence = nil
    epistemic_state.prediction_readiness = nil

    expect(epistemic_state).not_to be_valid
    expect(epistemic_state.errors[:model]).to include("must exist")
    expect(epistemic_state.errors[:confidence]).to include("can't be blank")
    expect(epistemic_state.errors[:prediction_readiness]).to include("can't be blank")
  end

  it "allows only string readiness states" do
    epistemic_state = described_class.new(
      model: create_model,
      confidence: 0.5,
      known_unknowns: [],
      prediction_readiness: "maybe",
      surprise_history: [],
      metadata: {}
    )

    expect(epistemic_state).not_to be_valid
    expect(epistemic_state.errors[:prediction_readiness]).to include("is not included in the list")
  end

  it "bounds confidence and observable coverage between zero and one" do
    epistemic_state = described_class.new(
      model: create_model,
      confidence: 1.01,
      observable_coverage: -0.01,
      known_unknowns: [],
      prediction_readiness: "not_ready",
      surprise_history: [],
      metadata: {}
    )

    expect(epistemic_state).not_to be_valid
    expect(epistemic_state.errors[:confidence]).to include("must be less than or equal to 1")
    expect(epistemic_state.errors[:observable_coverage]).to include("must be greater than or equal to 0")
  end

  it "requires known unknowns and surprise history to be arrays" do
    epistemic_state = described_class.new(
      model: create_model,
      confidence: 0.5,
      known_unknowns: {},
      prediction_readiness: "not_ready",
      surprise_history: {},
      metadata: {}
    )

    expect(epistemic_state).not_to be_valid
    expect(epistemic_state.errors[:known_unknowns]).to include("must be an array")
    expect(epistemic_state.errors[:surprise_history]).to include("must be an array")
  end

  it "requires object-shaped metadata" do
    epistemic_state = described_class.new(
      model: create_model,
      confidence: 0.5,
      known_unknowns: [],
      prediction_readiness: "not_ready",
      surprise_history: [],
      metadata: ["not", "an", "object"]
    )

    expect(epistemic_state).not_to be_valid
    expect(epistemic_state.errors[:metadata]).to include("must be an object")
  end

  it "allows only one epistemic state per model" do
    model = create_model
    described_class.create!(
      model: model,
      confidence: 0.5,
      known_unknowns: [],
      prediction_readiness: "not_ready",
      surprise_history: [],
      metadata: {}
    )

    duplicate = described_class.new(
      model: model,
      confidence: 0.6,
      known_unknowns: [],
      prediction_readiness: "ready",
      surprise_history: [],
      metadata: {}
    )

    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:model_id]).to include("has already been taken")
  end
end
