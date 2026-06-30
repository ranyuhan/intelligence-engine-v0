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
end
