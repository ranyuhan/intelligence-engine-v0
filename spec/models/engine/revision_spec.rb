# frozen_string_literal: true

require "rails_helper"

RSpec.describe Engine::Revision, type: :model do
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
      state: { "version" => 1 },
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

  it "is valid with required attributes and evidence" do
    revision = described_class.new(
      model: create_model,
      cause: "new_evidence",
      summary: "Evidence changed the model state.",
      outcome: "strengthened",
      previous_state: { "confidence" => 0.4 },
      new_state: { "confidence" => 0.5 },
      confidence_delta: 0.1,
      metadata: {}
    )
    revision.revision_evidences.build(evidence: create_evidence, metadata: {})

    expect(revision).to be_valid
  end

  it "requires model, cause, summary, outcome, state snapshots, and confidence delta" do
    revision = described_class.new(metadata: {})
    revision.confidence_delta = nil

    expect(revision).not_to be_valid
    expect(revision.errors[:model]).to include("must exist")
    expect(revision.errors[:cause]).to include("can't be blank")
    expect(revision.errors[:summary]).to include("can't be blank")
    expect(revision.errors[:outcome]).to include("can't be blank")
    expect(revision.errors[:previous_state]).to include("must be an object")
    expect(revision.errors[:new_state]).to include("must be an object")
    expect(revision.errors[:confidence_delta]).to include("can't be blank")
  end

  it "allows only approved outcomes" do
    revision = described_class.new(
      model: create_model,
      cause: "new_evidence",
      summary: "Evidence changed the model state.",
      outcome: "unknown",
      previous_state: {},
      new_state: {},
      confidence_delta: 0,
      metadata: {}
    )
    revision.revision_evidences.build(evidence: create_evidence, metadata: {})

    expect(revision).not_to be_valid
    expect(revision.errors[:outcome]).to include("is not included in the list")
  end

  it "allows unchanged outcome with identical previous and new state" do
    state = { "confidence" => 0.5 }
    revision = described_class.new(
      model: create_model,
      cause: "new_evidence",
      summary: "Evidence did not justify a model change.",
      outcome: "unchanged",
      previous_state: state,
      new_state: state,
      confidence_delta: 0,
      metadata: {}
    )
    revision.revision_evidences.build(evidence: create_evidence, metadata: {})

    expect(revision).to be_valid
  end

  it "requires at least one evidence record" do
    revision = described_class.new(
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

  it "requires object-shaped state snapshots and metadata" do
    revision = described_class.new(
      model: create_model,
      cause: "new_evidence",
      summary: "Evidence changed the model state.",
      outcome: "strengthened",
      previous_state: [],
      new_state: [],
      confidence_delta: 0.1,
      metadata: []
    )
    revision.revision_evidences.build(evidence: create_evidence, metadata: {})

    expect(revision).not_to be_valid
    expect(revision.errors[:previous_state]).to include("must be an object")
    expect(revision.errors[:new_state]).to include("must be an object")
    expect(revision.errors[:metadata]).to include("must be an object")
  end

  it "is immutable after creation" do
    revision = described_class.new(
      model: create_model,
      cause: "new_evidence",
      summary: "Evidence changed the model state.",
      outcome: "strengthened",
      previous_state: { "confidence" => 0.4 },
      new_state: { "confidence" => 0.5 },
      confidence_delta: 0.1,
      metadata: {}
    )
    revision.revision_evidences.build(evidence: create_evidence, metadata: {})
    revision.save!

    revision.summary = "Changed"

    expect(revision).not_to be_valid
    expect(revision.errors[:base]).to include("revisions are immutable after creation")
  end
end
