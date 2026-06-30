# frozen_string_literal: true

require "rails_helper"

RSpec.describe Engine::Event, type: :model do
  it "can belong to an entity" do
    association = described_class.reflect_on_association(:entity)

    expect(association.macro).to eq(:belongs_to)
    expect(association.options[:optional]).to be(true)
  end

  it "is valid with required attributes" do
    event = described_class.new(
      event_type: "source_recorded",
      occurred_at: 1.hour.ago,
      source: "test_source",
      metadata: {}
    )

    expect(event).to be_valid
  end

  it "requires event type, occurred at, and source" do
    event = described_class.new(metadata: {})

    expect(event).not_to be_valid
    expect(event.errors[:event_type]).to include("can't be blank")
    expect(event.errors[:occurred_at]).to include("can't be blank")
    expect(event.errors[:source]).to include("can't be blank")
  end

  it "does not allow events to occur in the future" do
    event = described_class.new(
      event_type: "source_recorded",
      occurred_at: 1.hour.from_now,
      source: "test_source",
      metadata: {}
    )

    expect(event).not_to be_valid
    expect(event.errors[:occurred_at]).to include("cannot be in the future")
  end

  it "is immutable after creation" do
    event = described_class.create!(
      event_type: "source_recorded",
      occurred_at: 1.hour.ago,
      source: "test_source",
      metadata: {}
    )

    event.description = "Changed"

    expect(event).not_to be_valid
    expect(event.errors[:base]).to include("events are immutable after creation")
  end

  it "requires object-shaped metadata" do
    event = described_class.new(
      event_type: "source_recorded",
      occurred_at: 1.hour.ago,
      source: "test_source",
      metadata: ["not", "an", "object"]
    )

    expect(event).not_to be_valid
    expect(event.errors[:metadata]).to include("must be an object")
  end
end
