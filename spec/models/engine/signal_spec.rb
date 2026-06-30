# frozen_string_literal: true

require "rails_helper"

RSpec.describe Engine::Signal, type: :model do
  it "is valid with required attributes before observations are attached" do
    signal = described_class.new(
      signal_type: "pattern",
      strength: 0.75,
      summary: "A derived pattern was detected.",
      detected_at: 1.hour.ago,
      metadata: {}
    )

    expect(signal).to be_valid
  end

  it "requires signal type, strength, summary, and detected at" do
    signal = described_class.new(metadata: {})

    expect(signal).not_to be_valid
    expect(signal.errors[:signal_type]).to include("can't be blank")
    expect(signal.errors[:strength]).to include("can't be blank")
    expect(signal.errors[:summary]).to include("can't be blank")
    expect(signal.errors[:detected_at]).to include("can't be blank")
  end

  it "requires strength to be between zero and one" do
    low_signal = described_class.new(
      signal_type: "pattern",
      strength: -0.01,
      summary: "Too low.",
      detected_at: 1.hour.ago,
      metadata: {}
    )
    high_signal = described_class.new(
      signal_type: "pattern",
      strength: 1.01,
      summary: "Too high.",
      detected_at: 1.hour.ago,
      metadata: {}
    )

    expect(low_signal).not_to be_valid
    expect(high_signal).not_to be_valid
  end

  it "does not allow detected at to be in the future" do
    signal = described_class.new(
      signal_type: "pattern",
      strength: 0.75,
      summary: "Future signal.",
      detected_at: 1.hour.from_now,
      metadata: {}
    )

    expect(signal).not_to be_valid
    expect(signal.errors[:detected_at]).to include("cannot be in the future")
  end

  it "requires object-shaped metadata" do
    signal = described_class.new(
      signal_type: "pattern",
      strength: 0.75,
      summary: "Invalid metadata.",
      detected_at: 1.hour.ago,
      metadata: ["not", "an", "object"]
    )

    expect(signal).not_to be_valid
    expect(signal.errors[:metadata]).to include("must be an object")
  end

  it "is immutable after creation" do
    signal = described_class.create!(
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
end
