# frozen_string_literal: true

require "rails_helper"

RSpec.describe Engine::SignalObservation, type: :model do
  def create_observation(observed_at: 1.hour.ago)
    event = Engine::Event.create!(
      event_type: "source_recorded",
      occurred_at: 2.hours.ago,
      source: "test_source",
      metadata: {}
    )

    Engine::Observation.create!(
      event: event,
      observation_type: "measurement",
      observed_at: observed_at,
      value: { "amount" => 1 },
      source: "test_source",
      metadata: {}
    )
  end

  def create_signal(detected_at: 30.minutes.ago)
    Engine::Signal.create!(
      signal_type: "pattern",
      strength: 0.75,
      summary: "A derived pattern was detected.",
      detected_at: detected_at,
      metadata: {}
    )
  end

  it "is valid with a signal and observation" do
    signal_observation = described_class.new(
      signal: create_signal,
      observation: create_observation,
      metadata: {}
    )

    expect(signal_observation).to be_valid
  end

  it "requires a signal and observation" do
    signal_observation = described_class.new(metadata: {})

    expect(signal_observation).not_to be_valid
    expect(signal_observation.errors[:signal]).to include("must exist")
    expect(signal_observation.errors[:observation]).to include("must exist")
  end

  it "requires each observation to be linked once per signal" do
    signal = create_signal
    observation = create_observation

    described_class.create!(signal: signal, observation: observation, metadata: {})
    duplicate = described_class.new(signal: signal, observation: observation, metadata: {})

    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:observation_id]).to include("has already been taken")
  end

  it "bounds optional weight between zero and one" do
    low_weight = described_class.new(
      signal: create_signal,
      observation: create_observation,
      weight: -0.01,
      metadata: {}
    )
    high_weight = described_class.new(
      signal: create_signal,
      observation: create_observation,
      weight: 1.01,
      metadata: {}
    )

    expect(low_weight).not_to be_valid
    expect(high_weight).not_to be_valid
  end

  it "does not allow signal detected at to be before observation observed at" do
    observation = create_observation(observed_at: 30.minutes.ago)
    signal = create_signal(detected_at: 1.hour.ago)

    signal_observation = described_class.new(signal: signal, observation: observation, metadata: {})

    expect(signal_observation).not_to be_valid
    expect(signal_observation.errors[:signal]).to include("detected_at cannot be before observation observed_at")
  end

  it "requires object-shaped metadata" do
    signal_observation = described_class.new(
      signal: create_signal,
      observation: create_observation,
      metadata: ["not", "an", "object"]
    )

    expect(signal_observation).not_to be_valid
    expect(signal_observation.errors[:metadata]).to include("must be an object")
  end

  it "is immutable after creation" do
    signal_observation = described_class.create!(
      signal: create_signal,
      observation: create_observation,
      metadata: {}
    )

    signal_observation.role = "changed"

    expect(signal_observation).not_to be_valid
    expect(signal_observation.errors[:base]).to include("signal observations are immutable after creation")
  end
end
