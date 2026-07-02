# frozen_string_literal: true

require "rails_helper"

RSpec.describe Engine::RevisionEvidence, type: :model do
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

  def create_revision(evidence)
    revision = Engine::Revision.new(
      model: create_model,
      cause: "new_evidence",
      summary: "Evidence changed the model state.",
      outcome: "strengthened",
      previous_state: {},
      new_state: { "confidence" => 0.1 },
      confidence_delta: 0.1,
      metadata: {}
    )
    revision.revision_evidences.build(evidence: evidence, metadata: {})
    revision.save!
    revision
  end

  it "is valid with revision and evidence" do
    evidence = create_evidence
    revision = create_revision(evidence)
    link = revision.revision_evidences.first

    expect(link).to be_valid
  end

  it "requires revision and evidence" do
    link = described_class.new(metadata: {})

    expect(link).not_to be_valid
    expect(link.errors[:revision]).to include("must exist")
    expect(link.errors[:evidence]).to include("must exist")
  end

  it "requires evidence to be linked once per revision" do
    evidence = create_evidence
    revision = create_revision(evidence)
    duplicate = described_class.new(revision: revision, evidence: evidence, metadata: {})

    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:evidence_id]).to include("has already been taken")
  end

  it "bounds optional weight between zero and one" do
    evidence = create_evidence
    revision = create_revision(evidence)
    low_weight = described_class.new(revision: revision, evidence: create_evidence, weight: -0.01, metadata: {})
    high_weight = described_class.new(revision: revision, evidence: create_evidence, weight: 1.01, metadata: {})

    expect(low_weight).not_to be_valid
    expect(high_weight).not_to be_valid
  end

  it "requires object-shaped metadata" do
    evidence = create_evidence
    revision = create_revision(evidence)
    link = described_class.new(revision: revision, evidence: create_evidence, metadata: [])

    expect(link).not_to be_valid
    expect(link.errors[:metadata]).to include("must be an object")
  end

  it "is immutable after creation" do
    evidence = create_evidence
    revision = create_revision(evidence)
    link = revision.revision_evidences.first

    link.role = "changed"

    expect(link).not_to be_valid
    expect(link.errors[:base]).to include("revision evidence links are immutable after creation")
  end
end
