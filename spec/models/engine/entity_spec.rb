# frozen_string_literal: true

require "rails_helper"

RSpec.describe Engine::Entity, type: :model do
  it "uses the stable pluralized engine table name" do
    expect(described_class.table_name).to eq("engine_entities")
  end

  it "is valid with required attributes" do
    entity = described_class.new(
      entity_type: "subject",
      external_id: "subject-1",
      name: "Subject 1",
      metadata: {}
    )

    expect(entity).to be_valid
  end

  it "requires entity type and name" do
    entity = described_class.new(metadata: {})

    expect(entity).not_to be_valid
    expect(entity.errors[:entity_type]).to include("can't be blank")
    expect(entity.errors[:name]).to include("can't be blank")
  end

  it "allows the same external id for different entity types" do
    described_class.create!(
      entity_type: "subject",
      external_id: "shared-id",
      name: "Subject",
      metadata: {}
    )

    entity = described_class.new(
      entity_type: "other_subject",
      external_id: "shared-id",
      name: "Other Subject",
      metadata: {}
    )

    expect(entity).to be_valid
  end

  it "requires external id to be unique within entity type when present" do
    described_class.create!(
      entity_type: "subject",
      external_id: "subject-1",
      name: "Subject 1",
      metadata: {}
    )

    duplicate = described_class.new(
      entity_type: "subject",
      external_id: "subject-1",
      name: "Duplicate",
      metadata: {}
    )

    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:external_id]).to include("has already been taken")
  end

  it "allows non-learning fields to be corrected" do
    entity = described_class.create!(
      entity_type: "subject",
      external_id: "subject-1",
      name: "Original",
      description: "Original description",
      metadata: { "source" => "import" }
    )

    entity.update!(
      name: "Corrected",
      description: "Corrected description",
      metadata: { "source" => "manual correction" }
    )

    expect(entity.reload.name).to eq("Corrected")
    expect(entity.description).to eq("Corrected description")
    expect(entity.metadata).to eq({ "source" => "manual correction" })
  end

  it "does not allow identity fields to change after creation" do
    entity = described_class.create!(
      entity_type: "subject",
      external_id: "subject-1",
      name: "Subject 1",
      metadata: {}
    )

    entity.entity_type = "changed"
    entity.external_id = "changed-id"

    expect(entity).not_to be_valid
    expect(entity.errors[:entity_type]).to include("cannot change after creation")
    expect(entity.errors[:external_id]).to include("cannot change after creation")
  end

  it "requires object-shaped metadata" do
    entity = described_class.new(
      entity_type: "subject",
      name: "Subject 1",
      metadata: ["not", "an", "object"]
    )

    expect(entity).not_to be_valid
    expect(entity.errors[:metadata]).to include("must be an object")
  end
end
