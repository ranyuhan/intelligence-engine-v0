# frozen_string_literal: true

require "rails_helper"

RSpec.describe Engine::Pipeline::ReviseModel, type: :service do
  subject(:service) { described_class.new }

  def create_model(state: { "confidence" => 0.4 }, hypothesis: "A provisional explanation.")
    goal = Engine::Goal.create!(
      name: "Improve explanatory accuracy #{SecureRandom.hex(4)}",
      goal_type: "learning",
      success_criteria: {},
      metadata: {}
    )

    Engine::Model.create!(
      goal: goal,
      model_type: "explanatory",
      name: "Baseline explanation #{SecureRandom.hex(4)}",
      hypothesis: hypothesis,
      state: state,
      metadata: {}
    )
  end

  def create_evidence
    event = Engine::Event.create!(
      event_type: "source_recorded",
      occurred_at: 3.hours.ago,
      source: "test_source",
      metadata: {}
    )
    observation = Engine::Observation.create!(
      event: event,
      observation_type: "measurement",
      observed_at: 2.hours.ago,
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
    Engine::SignalObservation.create!(signal: signal, observation: observation, metadata: {})
    Engine::Evidence.create!(
      signal: signal,
      evidence_type: "support",
      summary: "The signal is admissible evidence.",
      weight: 0.8,
      observed_at: 30.minutes.ago,
      metadata: {}
    )
  end

  it "creates a revision, links evidence, updates model state, and increments version" do
    model = create_model
    evidence = [create_evidence, create_evidence]

    revision = service.call(
      model: model,
      evidence: evidence,
      outcome: "revised",
      summary: "Evidence justified a revised model state.",
      new_state: { "confidence" => 0.6, "scope" => "expanded" },
      hypothesis: "A revised explanation."
    )

    expect(revision).to be_persisted
    expect(revision.cause).to eq("new_evidence")
    expect(revision.previous_state).to eq({ "confidence" => 0.4 })
    expect(revision.new_state).to eq({ "confidence" => 0.6, "scope" => "expanded" })
    expect(revision.confidence_delta).to eq(0)
    expect(revision.evidences).to match_array(evidence)

    model.reload
    expect(model.state).to eq({ "confidence" => 0.6, "scope" => "expanded" })
    expect(model.version).to eq(2)
    expect(model.hypothesis).to eq("A revised explanation.")
  end

  it "uses the provided cause when supplied" do
    model = create_model
    evidence = create_evidence

    revision = service.call(
      model: model,
      evidence: evidence,
      cause: "evaluation_feedback",
      outcome: "strengthened",
      summary: "Feedback-backed evidence strengthened the model.",
      new_state: { "confidence" => 0.5 }
    )

    expect(revision.cause).to eq("evaluation_feedback")
  end

  it "does not overwrite hypothesis when none is provided" do
    model = create_model
    evidence = create_evidence

    service.call(
      model: model,
      evidence: evidence,
      outcome: "strengthened",
      summary: "Evidence strengthened the model.",
      new_state: { "confidence" => 0.5 }
    )

    expect(model.reload.hypothesis).to eq("A provisional explanation.")
  end

  it "records unchanged revisions without mutating the model" do
    model = create_model(state: { "confidence" => 0.4, "scope" => "stable" })
    evidence = create_evidence
    original_updated_at = model.updated_at

    revision = service.call(
      model: model,
      evidence: evidence,
      outcome: "unchanged",
      summary: "Evidence did not justify a model state change.",
      new_state: { "confidence" => 0.9 }
    )

    expect(revision).to be_persisted
    expect(revision.previous_state).to eq({ "confidence" => 0.4, "scope" => "stable" })
    expect(revision.new_state).to eq(revision.previous_state)
    expect(revision.evidences).to contain_exactly(evidence)

    model.reload
    expect(model.state).to eq({ "confidence" => 0.4, "scope" => "stable" })
    expect(model.version).to eq(1)
    expect(model.updated_at).to eq(original_updated_at)
  end

  it "updates epistemic_state.last_revised_at without changing confidence" do
    model = create_model
    evidence = create_evidence
    epistemic_state = Engine::EpistemicState.create!(
      model: model,
      confidence: 0.35,
      observable_coverage: 0.2,
      prediction_readiness: "not_ready",
      known_unknowns: [],
      surprise_history: [],
      metadata: {}
    )

    revision = service.call(
      model: model,
      evidence: evidence,
      outcome: "weakened",
      summary: "Evidence weakened the model.",
      new_state: { "confidence" => 0.3 }
    )

    epistemic_state.reload
    expect(epistemic_state.last_revised_at).to eq(revision.created_at)
    expect(epistemic_state.confidence).to eq(BigDecimal("0.35"))
  end

  it "requires at least one evidence record" do
    model = create_model

    expect do
      service.call(
        model: model,
        evidence: [],
        outcome: "revised",
        summary: "Evidence justified a revised model state.",
        new_state: { "confidence" => 0.6 }
      )
    end.to raise_error(ArgumentError, "at least one evidence record is required")

    expect(model.reload.state).to eq({ "confidence" => 0.4 })
    expect(model.version).to eq(1)
    expect(Engine::Revision.count).to eq(0)
    expect(Engine::RevisionEvidence.count).to eq(0)
  end

  it "does not persist partial writes when a downstream update fails" do
    model = create_model
    evidence = create_evidence
    epistemic_state = Engine::EpistemicState.create!(
      model: model,
      confidence: 0.35,
      observable_coverage: 0.2,
      prediction_readiness: "not_ready",
      known_unknowns: [],
      surprise_history: [],
      metadata: {}
    )

    allow_any_instance_of(Engine::EpistemicState).to receive(:update!).and_raise(ActiveRecord::RecordInvalid.new(epistemic_state))

    expect do
      service.call(
        model: model,
        evidence: evidence,
        outcome: "revised",
        summary: "Evidence justified a revised model state.",
        new_state: { "confidence" => 0.6 }
      )
    end.to raise_error(ActiveRecord::RecordInvalid)

    expect(model.reload.state).to eq({ "confidence" => 0.4 })
    expect(model.version).to eq(1)
    expect(Engine::Revision.count).to eq(0)
    expect(Engine::RevisionEvidence.count).to eq(0)
  end

  it "does not create predictions or recommendations" do
    model = create_model
    evidence = create_evidence
    sql = []
    callback = lambda do |_name, _start, _finish, _id, payload|
      sql << payload[:sql]
    end

    ActiveSupport::Notifications.subscribed(callback, "sql.active_record") do
      service.call(
        model: model,
        evidence: evidence,
        outcome: "revised",
        summary: "Evidence justified a revised model state.",
        new_state: { "confidence" => 0.6 }
      )
    end

    expect(sql.grep(/engine_predictions|engine_recommendations/)).to be_empty
  end
end
