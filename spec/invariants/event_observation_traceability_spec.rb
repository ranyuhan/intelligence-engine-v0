# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Event to Observation traceability", type: :model do
  def create_entity(external_id:)
    Engine::Entity.create!(
      entity_type: "subject",
      external_id: external_id,
      name: "Subject #{external_id}",
      metadata: {}
    )
  end

  def create_event(entity: nil)
    Engine::Event.create!(
      entity: entity,
      event_type: "source_recorded",
      occurred_at: 2.hours.ago,
      source: "test_source",
      metadata: {}
    )
  end

  it "requires every observation to belong to an event" do
    observation = Engine::Observation.new(
      observation_type: "measurement",
      observed_at: 1.hour.ago,
      value: { "amount" => 1 },
      source: "test_source",
      metadata: {}
    )

    expect(observation).not_to be_valid
    expect(observation.errors[:event]).to include("must exist")
  end

  it "allows observation entity to match event entity when both are present" do
    entity = create_entity(external_id: "entity-1")
    event = create_event(entity: entity)

    observation = Engine::Observation.new(
      event: event,
      entity: entity,
      observation_type: "measurement",
      observed_at: 1.hour.ago,
      value: { "amount" => 1 },
      source: "test_source",
      metadata: {}
    )

    expect(observation).to be_valid
  end

  it "requires observation entity to match event entity when both are present" do
    event_entity = create_entity(external_id: "entity-1")
    observation_entity = create_entity(external_id: "entity-2")
    event = create_event(entity: event_entity)

    observation = Engine::Observation.new(
      event: event,
      entity: observation_entity,
      observation_type: "measurement",
      observed_at: 1.hour.ago,
      value: { "amount" => 1 },
      source: "test_source",
      metadata: {}
    )

    expect(observation).not_to be_valid
    expect(observation.errors[:entity]).to include("must match the event entity")
  end
end
