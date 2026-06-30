# frozen_string_literal: true

require "rails_helper"

RSpec.describe Engine::Evidence, type: :model do
  def create_traceable_signal(detected_at: 30.minutes.ago)
    event = Engine::Event.create!(
      event_type: "source_recorded",
      occurred_at: 2.hours.ago,
      source: "test_source",
      metadata: {}
    )
    observation = Engine::Observation.create!(
      event: event,
      observation_type: "measurement",
      observed_at: 1.hour.ago,
      value: { "amount" => 1 },
      source: "test_source",
      metadata: {}
    )
    signal = Engine::Signal.create!(
      signal_type: "pattern",
      strength: 0.75,
      summary: "A derived pattern was detected.",
      detected_at: detected_at,
      metadata: {}
    )

    Engine::SignalObservation.create!(signal: signal, observation: observation, metadata: {})
    signal
  end

  it "uses the Rails-conventional plural table name" do
    expect(described_class.table_name).to eq("engine_evidences")
  end

  it "is valid with signal provenance" do
    evidence = described_class.new(
      signal: create_traceable_signal,
      evidence_type: "support",
      summary: "The signal is admissible evidence.",
      weight: 0.8,
      observed_at: 15.minutes.ago,
      metadata: {}
    )

    expect(evidence).to be_valid
  end

  it "requires signal, evidence type, summary, weight, and observed at" do
    evidence = described_class.new(metadata: {})

    expect(evidence).not_to be_valid
    expect(evidence.errors[:signal]).to include("must exist")
    expect(evidence.errors[:evidence_type]).to include("can't be blank")
    expect(evidence.errors[:summary]).to include("can't be blank")
    expect(evidence.errors[:weight]).to include("can't be blank")
    expect(evidence.errors[:observed_at]).to include("can't be blank")
  end

  it "requires weight to be between zero and one" do
    low_evidence = described_class.new(
      signal: create_traceable_signal,
      evidence_type: "support",
      summary: "Too low.",
      weight: -0.01,
      observed_at: 15.minutes.ago,
      metadata: {}
    )
    high_evidence = described_class.new(
      signal: create_traceable_signal,
      evidence_type: "support",
      summary: "Too high.",
      weight: 1.01,
      observed_at: 15.minutes.ago,
      metadata: {}
    )

    expect(low_evidence).not_to be_valid
    expect(high_evidence).not_to be_valid
  end

  it "does not allow observed at to be in the future" do
    evidence = described_class.new(
      signal: create_traceable_signal,
      evidence_type: "support",
      summary: "Future evidence.",
      weight: 0.8,
      observed_at: 1.hour.from_now,
      metadata: {}
    )

    expect(evidence).not_to be_valid
    expect(evidence.errors[:observed_at]).to include("cannot be in the future")
  end

  it "does not allow observed at to be before signal detected at" do
    signal = create_traceable_signal(detected_at: 30.minutes.ago)
    evidence = described_class.new(
      signal: signal,
      evidence_type: "support",
      summary: "Evidence before signal.",
      weight: 0.8,
      observed_at: 45.minutes.ago,
      metadata: {}
    )

    expect(evidence).not_to be_valid
    expect(evidence.errors[:observed_at]).to include("cannot be before the signal was detected")
  end

  it "requires signal provenance to observable reality" do
    signal = Engine::Signal.create!(
      signal_type: "pattern",
      strength: 0.75,
      summary: "Untraced signal.",
      detected_at: 30.minutes.ago,
      metadata: {}
    )
    evidence = described_class.new(
      signal: signal,
      evidence_type: "support",
      summary: "Untraced evidence.",
      weight: 0.8,
      observed_at: 15.minutes.ago,
      metadata: {}
    )

    expect(evidence).not_to be_valid
    expect(evidence.errors[:signal]).to include("must trace to at least one observation with an event")
  end

  it "requires object-shaped metadata" do
    evidence = described_class.new(
      signal: create_traceable_signal,
      evidence_type: "support",
      summary: "Invalid metadata.",
      weight: 0.8,
      observed_at: 15.minutes.ago,
      metadata: ["not", "an", "object"]
    )

    expect(evidence).not_to be_valid
    expect(evidence.errors[:metadata]).to include("must be an object")
  end

  it "is immutable after creation" do
    evidence = described_class.create!(
      signal: create_traceable_signal,
      evidence_type: "support",
      summary: "The signal is admissible evidence.",
      weight: 0.8,
      observed_at: 15.minutes.ago,
      metadata: {}
    )

    evidence.summary = "Changed"

    expect(evidence).not_to be_valid
    expect(evidence.errors[:base]).to include("evidence is immutable after creation")
  end
end
