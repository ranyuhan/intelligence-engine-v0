# frozen_string_literal: true

require "rails_helper"

RSpec.describe Engine::Observation, type: :model do
  def create_event(entity: nil, occurred_at: 2.hours.ago)
    Engine::Event.create!(
      entity: entity,
      event_type: "source_recorded",
      occurred_at: occurred_at,
      source: "test_source",
      metadata: {}
    )
  end

  it "belongs to an event and can belong to an entity" do
    event_association = described_class.reflect_on_association(:event)
    entity_association = described_class.reflect_on_association(:entity)

    expect(event_association.macro).to eq(:belongs_to)
    expect(entity_association.macro).to eq(:belongs_to)
    expect(entity_association.options[:optional]).to be(true)
  end

  it "is valid with required attributes" do
    event = create_event
    observation = described_class.new(
      event: event,
      observation_type: "measurement",
      observed_at: 1.hour.ago,
      value: { "amount" => 1 },
      source: "test_source",
      metadata: {}
    )

    expect(observation).to be_valid
  end

  it "requires event traceability" do
    observation = described_class.new(
      observation_type: "measurement",
      observed_at: 1.hour.ago,
      value: { "amount" => 1 },
      source: "test_source",
      metadata: {}
    )

    expect(observation).not_to be_valid
    expect(observation.errors[:event]).to include("must exist")
  end

  it "requires observation type, observed at, source, and value" do
    event = create_event
    observation = described_class.new(event: event, metadata: {})
    observation.value = nil

    expect(observation).not_to be_valid
    expect(observation.errors[:observation_type]).to include("can't be blank")
    expect(observation.errors[:observed_at]).to include("can't be blank")
    expect(observation.errors[:source]).to include("can't be blank")
    expect(observation.errors[:value]).to include("must be present")
  end

  it "does not allow observed at to be before the event occurred" do
    event = create_event(occurred_at: 1.hour.ago)
    observation = described_class.new(
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

  it "does not allow observed at to be in the future" do
    event = create_event
    observation = described_class.new(
      event: event,
      observation_type: "measurement",
      observed_at: 1.hour.from_now,
      value: { "amount" => 1 },
      source: "test_source",
      metadata: {}
    )

    expect(observation).not_to be_valid
    expect(observation.errors[:observed_at]).to include("cannot be in the future")
  end

  it "allows observation entity to match the event entity" do
    entity = Engine::Entity.create!(
      entity_type: "subject",
      external_id: "subject-1",
      name: "Subject 1",
      metadata: {}
    )
    event = create_event(entity: entity)

    observation = described_class.new(
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

  it "does not allow observation entity to conflict with event entity" do
    event_entity = Engine::Entity.create!(
      entity_type: "subject",
      external_id: "subject-1",
      name: "Subject 1",
      metadata: {}
    )
    observation_entity = Engine::Entity.create!(
      entity_type: "subject",
      external_id: "subject-2",
      name: "Subject 2",
      metadata: {}
    )
    event = create_event(entity: event_entity)

    observation = described_class.new(
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

  it "is immutable after creation" do
    event = create_event
    observation = described_class.create!(
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

  it "requires object-shaped metadata" do
    event = create_event
    observation = described_class.new(
      event: event,
      observation_type: "measurement",
      observed_at: 1.hour.ago,
      value: { "amount" => 1 },
      source: "test_source",
      metadata: ["not", "an", "object"]
    )

    expect(observation).not_to be_valid
    expect(observation.errors[:metadata]).to include("must be an object")
  end
end
