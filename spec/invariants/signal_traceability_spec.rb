# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Signal traceability", type: :model do
  it "traces signals to observable reality through observations and events" do
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
      detected_at: 30.minutes.ago,
      metadata: {}
    )

    Engine::SignalObservation.create!(signal: signal, observation: observation, metadata: {})

    expect(signal.observations).to contain_exactly(observation)
    expect(signal.observations.first.event).to eq(event)
  end

  it "prevents signal observation links that would make a signal predate its observation" do
    event = Engine::Event.create!(
      event_type: "source_recorded",
      occurred_at: 2.hours.ago,
      source: "test_source",
      metadata: {}
    )
    observation = Engine::Observation.create!(
      event: event,
      observation_type: "measurement",
      observed_at: 30.minutes.ago,
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

    signal_observation = Engine::SignalObservation.new(signal: signal, observation: observation, metadata: {})

    expect(signal_observation).not_to be_valid
    expect(signal_observation.errors[:signal]).to include("detected_at cannot be before observation observed_at")
  end
end
