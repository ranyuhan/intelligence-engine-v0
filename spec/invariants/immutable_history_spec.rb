# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Immutable history", type: :model do
  def create_event
    Engine::Event.create!(
      event_type: "source_recorded",
      occurred_at: 2.hours.ago,
      source: "test_source",
      metadata: {}
    )
  end

  it "prevents events from being updated through normal ActiveRecord validation" do
    event = create_event

    event.description = "Changed"

    expect(event).not_to be_valid
    expect(event.errors[:base]).to include("events are immutable after creation")
  end

  it "prevents observations from being updated through normal ActiveRecord validation" do
    event = create_event
    observation = Engine::Observation.create!(
      event: event,
      observation_type: "measurement",
      observed_at: 1.hour.ago,
      value: { "amount" => 1 },
      source: "test_source",
      metadata: {}
    )

    observation.value = { "amount" => 2 }

    expect(observation).not_to be_valid
    expect(observation.errors[:base]).to include("observations are immutable after creation")
  end

  it "prevents signals from being updated through normal ActiveRecord validation" do
    signal = Engine::Signal.create!(
      signal_type: "pattern",
      strength: 0.75,
      summary: "A derived pattern was detected.",
      detected_at: 1.hour.ago,
      metadata: {}
    )

    signal.summary = "Changed"

    expect(signal).not_to be_valid
    expect(signal.errors[:base]).to include("signals are immutable after creation")
  end

  it "prevents signal observations from being updated through normal ActiveRecord validation" do
    event = create_event
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
      detected_at: 30.minutes.ago,
      metadata: {}
    )
    signal_observation = Engine::SignalObservation.create!(
      signal: signal,
      observation: observation,
      metadata: {}
    )

    signal_observation.role = "changed"

    expect(signal_observation).not_to be_valid
    expect(signal_observation.errors[:base]).to include("signal observations are immutable after creation")
  end

  it "prevents evidence from being updated through normal ActiveRecord validation" do
    event = create_event
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
      detected_at: 30.minutes.ago,
      metadata: {}
    )
    Engine::SignalObservation.create!(signal: signal, observation: observation, metadata: {})
    evidence = Engine::Evidence.create!(
      signal: signal,
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
