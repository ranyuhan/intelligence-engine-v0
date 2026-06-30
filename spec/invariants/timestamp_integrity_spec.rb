# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Timestamp integrity", type: :model do
  def create_event(occurred_at: 1.hour.ago)
    Engine::Event.create!(
      event_type: "source_recorded",
      occurred_at: occurred_at,
      source: "test_source",
      metadata: {}
    )
  end

  it "requires events to record when they occurred" do
    event = Engine::Event.new(
      event_type: "source_recorded",
      source: "test_source",
      metadata: {}
    )

    expect(event).not_to be_valid
    expect(event.errors[:occurred_at]).to include("can't be blank")
  end

  it "requires observations to record when they were observed" do
    observation = Engine::Observation.new(
      event: create_event,
      observation_type: "measurement",
      value: { "amount" => 1 },
      source: "test_source",
      metadata: {}
    )

    expect(observation).not_to be_valid
    expect(observation.errors[:observed_at]).to include("can't be blank")
  end

  it "prevents observations from being observed before their event occurred" do
    event = create_event(occurred_at: 1.hour.ago)
    observation = Engine::Observation.new(
      event: event,
      observation_type: "measurement",
      observed_at: 2.hours.ago,
      value: { "amount" => 1 },
      source: "test_source",
      metadata: {}
    )

    expect(observation).not_to be_valid
    expect(observation.errors[:observed_at]).to include("cannot be before the event occurred")
  end
end
