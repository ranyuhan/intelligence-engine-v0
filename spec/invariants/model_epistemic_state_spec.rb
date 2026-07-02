# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Model epistemic state", type: :model do
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

  it "exposes models missing epistemic state without blocking model creation yet" do
    model = create_model

    expect(model).to be_persisted
    expect(model.epistemic_state).to be_nil
  end

  it "supports one current epistemic state per model" do
    model = create_model

    epistemic_state = Engine::EpistemicState.create!(
      model: model,
      confidence: 0.5,
      known_unknowns: [],
      prediction_readiness: "not_ready",
      surprise_history: [],
      metadata: {}
    )

    expect(model.reload.epistemic_state).to eq(epistemic_state)
  end

  it "keeps prediction readiness string-based" do
    model = create_model

    epistemic_state = Engine::EpistemicState.new(
      model: model,
      confidence: 0.5,
      known_unknowns: [],
      prediction_readiness: true,
      surprise_history: [],
      metadata: {}
    )

    expect(epistemic_state).not_to be_valid
    expect(epistemic_state.errors[:prediction_readiness]).to include("is not included in the list")
  end
end
