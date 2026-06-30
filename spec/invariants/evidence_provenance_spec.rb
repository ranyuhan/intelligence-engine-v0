# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Evidence provenance", type: :model do
  def create_signal_with_trace
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
    signal
  end

  it "requires evidence to preserve provenance from signal to observation to event" do
    signal = create_signal_with_trace
    evidence = Engine::Evidence.create!(
      signal: signal,
      evidence_type: "support",
      summary: "The signal is admissible evidence.",
      weight: 0.8,
      observed_at: 15.minutes.ago,
      metadata: {}
    )

    traced_events = evidence.signal.signal_observations.map { |link| link.observation.event }

    expect(traced_events).to all(be_present)
  end

  it "does not allow evidence from a signal with no observation trace" do
    signal = Engine::Signal.create!(
      signal_type: "pattern",
      strength: 0.75,
      summary: "Untraced signal.",
      detected_at: 30.minutes.ago,
      metadata: {}
    )
    evidence = Engine::Evidence.new(
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
end
