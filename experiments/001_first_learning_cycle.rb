# frozen_string_literal: true

require "securerandom"

puts "=== First Learning Cycle Experiment ==="
puts

run_token = ENV.fetch("EXPERIMENT_RUN_TOKEN", Time.current.strftime("%Y%m%d%H%M%S"))
suffix = "exp-001-#{run_token}"

goal = Engine::Goal.find_or_create_by!(name: "Experiment 001 Learning Goal #{suffix}") do |record|
  record.goal_type = "learning"
  record.success_criteria = {}
  record.metadata = { "experiment" => "001_first_learning_cycle" }
end

entity = Engine::Entity.find_or_create_by!(entity_type: "limited_partner", external_id: suffix) do |record|
  record.name = "LP #{suffix}"
  record.description = "Experiment-only entity for a fundraising learning cycle."
  record.metadata = { "experiment" => "001_first_learning_cycle" }
end

event = Engine::Event.create!(
  entity: entity,
  event_type: "fundraising_interaction",
  occurred_at: 10.days.ago,
  source: "experiment_script",
  description: "LP requested multiple follow-up meetings within two weeks.",
  metadata: {
    "experiment" => "001_first_learning_cycle",
    "story" => "multiple follow-up meetings requested within two weeks"
  }
)

observation = Engine::Observation.create!(
  event: event,
  entity: entity,
  observation_type: "meeting_request_pattern",
  observed_at: 9.days.ago,
  value: {
    "follow_up_meetings_requested" => 3,
    "time_window_days" => 14,
    "interpretation" => "multiple follow-up meetings requested"
  },
  source: "experiment_script",
  metadata: { "experiment" => "001_first_learning_cycle" }
)

signal = Engine::Signal.create!(
  signal_type: "engagement_increase",
  strength: 0.82,
  summary: "Increasing engagement was inferred from repeated follow-up meeting requests.",
  detected_at: 8.days.ago,
  metadata: { "experiment" => "001_first_learning_cycle" }
)

Engine::SignalObservation.find_or_create_by!(signal: signal, observation: observation) do |record|
  record.role = "supporting_observation"
  record.weight = 0.82
  record.metadata = { "experiment" => "001_first_learning_cycle" }
end

evidence = Engine::Evidence.create!(
  signal: signal,
  evidence_type: "support",
  summary: "Engagement signal supported by observable meeting cadence.",
  weight: 0.82,
  observed_at: 7.days.ago,
  metadata: { "experiment" => "001_first_learning_cycle" }
)

model = Engine::Model.find_or_create_by!(goal: goal, entity: entity, name: "LP Engagement Model #{suffix}") do |record|
  record.model_type = "relationship_assessment"
  record.hypothesis = "LP has exploratory interest"
  record.description = "Experiment-only model for testing one learning cycle."
  record.state = {
    "engagement_level" => "exploratory",
    "meeting_cadence" => "sporadic",
    "supporting_pattern" => "initial_contact_only"
  }
  record.status = "active"
  record.metadata = { "experiment" => "001_first_learning_cycle" }
end

epistemic_state = Engine::EpistemicState.find_or_create_by!(model: model) do |record|
  record.confidence = 0.35
  record.observable_coverage = 0.2
  record.prediction_readiness = "not_ready"
  record.known_unknowns = ["decision timeline", "check size", "internal sponsor strength"]
  record.surprise_history = []
  record.metadata = { "experiment" => "001_first_learning_cycle" }
end

previous_hypothesis = model.hypothesis
previous_state = model.state.deep_dup
previous_version = model.version

puts "=== Initial Model ==="
puts "Goal: #{goal.name}"
puts "Entity: #{entity.name}"
puts "Hypothesis: #{previous_hypothesis}"
puts "State: #{JSON.pretty_generate(previous_state)}"
puts "Version: #{previous_version}"
puts "Epistemic last revised at: #{epistemic_state.last_revised_at.inspect}"
puts

revision = Engine::Pipeline::ReviseModel.new.call(
  model: model,
  evidence: evidence,
  outcome: "revised",
  cause: "new_evidence",
  summary: "Follow-up meeting cadence supports sustained engagement.",
  new_state: {
    "engagement_level" => "sustained",
    "meeting_cadence" => "repeated_within_two_weeks",
    "supporting_pattern" => "multiple_follow_up_requests"
  },
  hypothesis: "LP demonstrates sustained engagement"
)

model.reload
epistemic_state.reload

puts "=== Revision Result ==="
puts "Previous hypothesis: #{previous_hypothesis}"
puts "New hypothesis: #{model.hypothesis}"
puts "Previous state: #{JSON.pretty_generate(previous_state)}"
puts "New state: #{JSON.pretty_generate(model.state)}"
puts "Previous version: #{previous_version}"
puts "New version: #{model.version}"
puts "Revision outcome: #{revision.outcome}"
puts "Revision id: #{revision.id}"
puts "Linked evidence count: #{revision.evidences.count}"
puts "Epistemic last revised at: #{epistemic_state.last_revised_at.inspect}"
