# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Model revision traceability", type: :model do
  subject(:service) { Engine::Pipeline::ReviseModel.new }

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

  def create_evidence
    event = Engine::Event.create!(
      event_type: "source_recorded",
      occurred_at: 3.hours.ago,
      source: "test_source",
      metadata: {}
    )
    observation = Engine::Observation.create!(
      event: event,
      observation_type: "measurement",
      observed_at: 2.hours.ago,
      value: { "amount" => 1 },
      source: "test_source",
      metadata: {}
    )
    signal = Engine::Signal.create!(
      signal_type: "pattern",
      strength: 0.75,
      summary: "A derived pattern was detected.",
      detected_at: 1.hour.ago,
      metadata: {}
    )
    Engine::SignalObservation.create!(signal: signal, observation: observation, metadata: {})
    Engine::Evidence.create!(
      signal: signal,
      evidence_type: "support",
      summary: "The signal is admissible evidence.",
      weight: 0.8,
      observed_at: 30.minutes.ago,
      metadata: {}
    )
  end

  it "does not allow revisions without evidence" do
    revision = Engine::Revision.new(
      model: create_model,
      cause: "new_evidence",
      summary: "Evidence changed the model state.",
      outcome: "strengthened",
      previous_state: {},
      new_state: {},
      confidence_delta: 0.1,
      metadata: {}
    )

    expect(revision).not_to be_valid
    expect(revision.errors[:base]).to include("revisions require at least one evidence record")
  end

  it "requires every revision to record state snapshots and an approved outcome" do
    revision = Engine::Revision.new(
      model: create_model,
      cause: "new_evidence",
      summary: "Evidence changed the model state.",
      outcome: "unknown",
      previous_state: [],
      new_state: [],
      confidence_delta: 0.1,
      metadata: {}
    )
    revision.revision_evidences.build(evidence: create_evidence, metadata: {})

    expect(revision).not_to be_valid
    expect(revision.errors[:outcome]).to include("is not included in the list")
    expect(revision.errors[:previous_state]).to include("must be an object")
    expect(revision.errors[:new_state]).to include("must be an object")
  end

  it "preserves evidence links for persisted revisions" do
    evidence = create_evidence
    revision = Engine::Revision.new(
      model: create_model,
      cause: "new_evidence",
      summary: "Evidence changed the model state.",
      outcome: "strengthened",
      previous_state: { "confidence" => 0.4 },
      new_state: { "confidence" => 0.5 },
      confidence_delta: 0.1,
      metadata: {}
    )
    revision.revision_evidences.build(evidence: evidence, metadata: {})
    revision.save!

    expect(revision.evidences).to contain_exactly(evidence)
    expect(revision.previous_state).to eq({ "confidence" => 0.4 })
    expect(revision.new_state).to eq({ "confidence" => 0.5 })
  end

  it "mutates model state only through a persisted revision with linked evidence" do
    model = create_model
    evidence = create_evidence

    revision = service.call(
      model: model,
      evidence: evidence,
      outcome: "revised",
      summary: "Evidence justified a revised explanatory state.",
      new_state: { "confidence" => 0.6, "coverage" => "expanded" }
    )

    expect(revision).to be_persisted
    expect(revision.evidences).to contain_exactly(evidence)
    expect(revision.previous_state).to eq({})
    expect(revision.new_state).to eq({ "confidence" => 0.6, "coverage" => "expanded" })
    expect(model.reload.state).to eq(revision.new_state)
  end
end
