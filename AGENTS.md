Intelligence Engine v0 — Contributor Instructions

This is a Rails prototype for testing a domain-independent intelligence engine.

Before changing code, read:

1. docs/constitution/ENGINE_CONSTITUTION.md
2. docs/prototype/ONE_MONTH_PROTOTYPE_PLAN.md
3. This file

The Constitution defines the principles. This file defines how to implement them in Rails.

⸻

Rails Structure

Use Rails conventions.

Engine code belongs inside the Rails app, not in a parallel framework.

Use these locations:

app/models/engine/
app/services/engine/
app/jobs/engine/
app/controllers/engine/
app/views/engine/
spec/models/engine/
spec/services/engine/
spec/jobs/engine/
spec/invariants/

Use the Engine:: namespace for engine classes.

Examples:

Engine::Entity
Engine::Event
Engine::Observation
Engine::Signal
Engine::Model
Engine::EpistemicState
Engine::Prediction

Do not create a separate top-level engine/ runtime directory unless explicitly requested.

⸻

Boundary Rule

The engine layer must remain domain-independent.

Engine code must not reference domain terms such as:

company
stock
ticker
earnings
market
LP
GP
fund
healthcare
customer

Domain vocabulary belongs under:

domains/

or in seed/config data.

A violation of this boundary should fail review.

⸻

Domain Ontology

Domain packages define vocabulary only.

They do not define how the engine learns.

The first domain is:

domains/public_markets/

Use YAML for domain vocabulary:

ontology.yml
entity_types.yml
event_types.yml
observation_types.yml
signal_types.yml
model_types.yml
prediction_types.yml
goals.yml

⸻

Core Engine Objects

The universal engine objects are:

Goal
Entity
Event
Observation
Signal
Evidence
Model
EpistemicState
Revision
Prediction
Feedback
Evaluation
Recommendation

These should be implemented as ActiveRecord models under app/models/engine/.

Prefer explicit associations and validations.

Do not hide important state changes in callbacks unless there is a strong reason.

⸻

Services

Use service objects for engine behavior.

Suggested folders:

app/services/engine/pipeline/
app/services/engine/behaviors/
app/services/engine/policies/

Pipeline services orchestrate steps.

Behavior services perform reusable logic.

Policy services enforce constitutional gates and thresholds.

Do not mix these responsibilities.

⸻

Jobs

Use jobs for async or replayable work.

Jobs should call services.

Jobs should not contain business logic.

⸻

Model Revision Rule

Never silently overwrite learning.

Model revision must create a Engine::Revision record.

A revision should capture:

model_id
cause
summary
evidence_ids
previous_state
new_state
confidence_delta
created_at

⸻

Epistemic State Rule

Every Engine::Model must have an associated Engine::EpistemicState.

Prediction generation must check Prediction Readiness first.

If the model is not ready, prediction must be withheld.

Silence is valid output.

⸻

Prediction Rule

Every prediction must be:

specific
time-boxed
falsifiable
event-addressable
linked to a model
linked to a goal

If these fields cannot be supplied, do not create a prediction.

⸻

Evidence Rule

Every confidence change must identify the evidence that caused it.

No evidence, no revision.

No revision, no learning.

⸻

Testing Expectations

For any new engine object, add model specs.

For any behavior or policy, add service specs.

For constitutional requirements, add invariant specs under:

spec/invariants/

Important invariants include:

domain_independence_spec.rb
prediction_falsifiability_spec.rb
model_revision_traceability_spec.rb
epistemic_state_gate_spec.rb
timestamp_integrity_spec.rb

⸻

Before Large Changes

Before making large edits, produce a short plan:

Files to change
Objects affected
Constitution rule involved
Expected tests
Risks / open questions

Then implement.

⸻

After Changes

After changes, report:

What changed
What tests were added
What tests were run
Any tests not run
Any architecture concerns
Any open questions created

If tests cannot be run, say so clearly.

⸻

Research Discipline

If implementation exposes ambiguity, do not invent architecture silently.

Update the appropriate file:

docs/research/OPEN_QUESTIONS.md
docs/research/ASSUMPTIONS.md
docs/research/EXPERIMENTS.md
docs/research/FAILED_IDEAS.md

Prefer recording uncertainty over hiding it in code.

⸻

Guiding Question

Every contribution should help answer:

Can a universal intelligence engine continuously build, evaluate, revise, and appropriately limit evidence-backed explanatory models of reality through feedback?

If a change does not help answer this, it probably does not belong in the prototype.