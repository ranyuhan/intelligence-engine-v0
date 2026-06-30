# Object Model

## Purpose

The Engine object model defines the stable conceptual objects required for a
domain-independent intelligence engine.

The object model is not primarily a database design. It exists to support the
learning dynamics described by the Constitution:

- Reality is observed through Events.
- Events become Observations.
- Observations become Signals.
- Signals become Evidence.
- Evidence may justify Model Revision.
- Models generate Predictions.
- Reality produces Feedback.
- Feedback produces Evaluation.
- Evaluation produces Revision.
- Revision changes the Model.

The purpose of the object model is to preserve this learning loop without
embedding domain knowledge in the engine layer.

## Learning Dependency Graph

```text
Goal ───────────────────────────────┐
                                    │
                                    ▼
Reality ──▶ Event ──▶ Observation ──▶ Signal ──▶ Evidence
                                                        │
                                                        ▼
                                                  Evaluation
                                                        │
                                                        ▼
Revision ◀─────────────────────────────────────── Model
   │                                                │
   │                                                ▼
   └──────────────────────────────────────────▶ EpistemicState
                                                    │
                                                    ▼
                                             Prediction Gate
                                                    │
                                                    ▼
                                                Prediction
                                                    │
                                                    ▼
                                                 Reality
                                                    │
                                                    ▼
                                                 Feedback
                                                    │
                                                    ▼
                                                Evaluation

Goal + Model + EpistemicState ──▶ Recommendation ──▶ Human Action ──▶ Reality
```

The graph describes learning dependencies, not necessarily database
relationships.

## Object Table

| Object | Persistent | Mutable | Derived | Versioned | Created By | Consumed By | Primary Learning Loop |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Goal | Yes | Yes | No | No | Human/application | Model, Prediction, Recommendation, Evaluation | Recommendation, Model Revision |
| Entity | Yes | Limited | No | No | Domain ontology/import | Event, Observation, Model, Prediction | Observation |
| Event | Yes | No | No | No | Reality ingestion | Observation, Feedback, Evaluation | Observation, Surprise |
| Observation | Yes | No | Yes | No | Observation pipeline | Signal, EpistemicState | Observation |
| Signal | Yes | No | Yes | No | Signal pipeline | Evidence | Observation, Surprise |
| Evidence | Yes | No | Yes | No | Evidence pipeline | Evaluation, Revision | Model Revision |
| Model | Yes | Yes | No | Through Revision | Revision engine | Prediction, Recommendation, EpistemicState | Model Revision, Prediction |
| EpistemicState | Yes | Yes | Partly | Through Revision/Evaluation history | Epistemic engine | Prediction gate, Recommendation engine | Epistemic, Prediction |
| Prediction | Yes | No | No | No | Prediction engine | Feedback, Evaluation | Prediction |
| Feedback | Yes | No | No | No | Reality ingestion | Evaluation | Prediction, Recommendation aftermath |
| Evaluation | Yes | No | Yes | No | Evaluation engine | Revision, EpistemicState | Prediction, Model Revision |
| Revision | Yes | No | Yes | No | Revision engine | Model, audit, EpistemicState | Model Revision |
| Recommendation | Yes | No | Yes | No | Recommendation engine | Human/application | Recommendation |

## Object Responsibilities

### Goal

A Goal defines what the engine is trying to understand, improve, or decide
against.

Goals are human- or application-created. They are mutable because humans may
change priorities, but changes to a Goal must not rewrite historical
Predictions, Evaluations, Revisions, or Recommendations.

Goals are consumed by Models, Predictions, Evaluations, and Recommendations.
They participate primarily in the Model Revision and Recommendation loops.

Candidate invariants:

- Every Prediction belongs to a Goal.
- Every Recommendation belongs to a Goal.
- Historical engine outputs retain the Goal context that existed when they were
  created.

### Entity

An Entity is a stable domain-neutral referent for something reality can expose.

Entity identity is stable. Non-learning metadata may be corrected, but an Entity
must not contain learning state. Learning belongs in Models, EpistemicState,
Evidence, Evaluations, and Revisions.

Entities are created from domain ontology, import, or source mapping. They are
consumed by Events, Observations, Models, and Predictions.

Candidate invariants:

- Entity identity is stable after creation.
- Entity metadata corrections do not create learning.
- Engine Entity code must not contain domain learning logic.
- Entity type vocabulary comes from domain ontology, not engine behavior.

### Event

An Event is the engine's record that something happened in reality.

Events are persistent and immutable. They are created by reality ingestion and
consumed by Observation extraction, Feedback construction, and Evaluation.

Events participate in the Observation and Surprise loops. They are governed by
the constitutional law that reality is only observable through events.

Candidate invariants:

- Every Observation traces to an Event.
- Events record when reality occurred, not merely when the engine received the
  record.
- Events are not revised in place.

### Observation

An Observation is a structured measurement or interpretation extracted from an
Event.

Observations are persistent, immutable, and derived from Events. They are
created by the Observation pipeline and consumed by Signal extraction and
EpistemicState coverage calculations.

Candidate invariants:

- Every Observation traces to exactly one source Event.
- Observation extraction must satisfy the Event to Observation gate.
- Failed or insufficient extraction does not create an Observation.

### Signal

A Signal is a higher-level pattern, implication, or feature derived from one or
more Observations.

Signals are persistent, immutable, and derived. They are created by the Signal
pipeline and consumed by the Evidence pipeline.

Signals participate in the Observation and Surprise loops. They are not yet
admissible learning by themselves; they become learning-relevant only when
converted into Evidence.

Candidate invariants:

- Every Signal traces to one or more Observations.
- Signal strength, direction, and provenance do not mutate after creation.
- A Signal cannot directly change a Model.

### Evidence

Evidence is admissible, provenance-bearing support that may justify Evaluation
or Revision.

Evidence is persistent, immutable, and derived from Signals, Observations, or
Events. It is created by the Evidence pipeline and consumed by Evaluation and
Revision.

Evidence is central to the Discipline virtue: no evidence, no revision, no
learning.

Candidate invariants:

- Every confidence change traces to Evidence.
- Evidence must preserve provenance back to observable reality.
- Evidence cannot directly mutate a Model.

### Model

A Model is the engine's mutable current explanatory snapshot for a Goal.

The Model is the current state. Revision is the immutable history of how that
state changed. The Model may be updated only by the Revision engine after an
Evaluation determines the learning outcome.

Models are consumed by Prediction generation, Recommendation generation, and
EpistemicState assessment.

Candidate invariants:

- A Model changes only through Revision.
- Every Model has an EpistemicState.
- The current Model snapshot and Revision history must not contradict each
  other.
- Model state remains domain-independent.

### EpistemicState

EpistemicState is the engine's current assessment of a Model's trustworthiness
and limitations.

It is a current snapshot. Some dimensions may be derived or cached, including
prediction_readiness and revision_velocity. The Constitution requires the
dimensions of EpistemicState to remain distinct rather than being collapsed into
a single score.

EpistemicState is created and updated by the epistemic engine from Evaluation,
Observation coverage, surprise history, and revision history. It is consumed by
the Prediction gate and Recommendation engine.

Candidate invariants:

- Prediction readiness is not equivalent to confidence alone.
- The engine does not generate Predictions when EpistemicState is not ready.
- Epistemic dimensions remain separately inspectable.
- Cached derived values can be recomputed from underlying history.

### Prediction

A Prediction is a specific, time-boxed, falsifiable hypothesis emitted by a
Model for a Goal.

Predictions are persistent and immutable once issued. A Prediction does not
reference a future Event directly. Instead, it defines:

- expected_event_type
- expected_event_matcher

The matcher describes how future Events may satisfy, falsify, or remain
irrelevant to the Prediction.

Predictions are consumed by Feedback and Evaluation. They participate in the
Prediction loop.

Candidate invariants:

- Every Prediction is linked to a Model and Goal.
- Every Prediction is specific, time-boxed, falsifiable, and event-addressable.
- Every Prediction defines expected_event_type and expected_event_matcher.
- Prediction outcomes are represented by Feedback and Evaluation, not by
  mutating the Prediction.

### Feedback

Feedback is reality observed after a Prediction, Recommendation, action, or
elapsed time.

Feedback is persistent and immutable. It is created by reality ingestion and
consumed by Evaluation. Feedback does not directly revise a Model.

In the Prediction loop, Feedback compares hypotheses against reality. In the
Recommendation loop, Feedback is indirect: later Events may have many causes,
so the engine must not assume deterministic attribution to a Recommendation.

Candidate invariants:

- Feedback must reference observed reality.
- Feedback does not directly mutate Model or EpistemicState.
- Recommendation effects re-enter learning through Events and Feedback, not
  direct causal overwrite.

### Evaluation

Evaluation is the engine's assessment of observed reality against a Prediction,
Model expectation, or relevant Evidence.

Evaluations are persistent, immutable, and derived. They are created by the
Evaluation engine and consumed by the Revision engine and Epistemic engine.

Withheld Predictions are meaningful behavior in v0, but they should be recorded
in metadata or Evaluation rather than as a new object.

Candidate invariants:

- Evaluation must be traceable to Feedback, Evidence, or observed Events.
- Evaluation must not directly mutate a Model.
- A complete learning cycle produces one of: strengthened, weakened, revised,
  unchanged.
- Withheld Prediction decisions are auditable in v0 through metadata or
  Evaluation records.

### Revision

A Revision is the immutable history of a Model change or explicit non-change.

Revisions are created only by the Revision engine and consumed by the Model,
EpistemicState, and audit processes.

Revision supports the following outcomes:

- strengthened
- weakened
- revised
- unchanged

The unchanged outcome is important: a complete learning cycle may confirm that
no Model change is justified, but that conclusion must still be explicit.

Candidate invariants:

- No Revision exists without Evidence or Evaluation cause.
- No Model state change occurs without Revision.
- Every Revision captures previous state, new state, outcome, cause, and
  evidence.
- Unchanged Revisions preserve Discipline by recording why no change occurred.

### Recommendation

A Recommendation is a proposed intervention generated from Goal, Model, and
EpistemicState.

Recommendations are persistent and immutable once issued. They are control-loop
outputs, not prediction-loop hypotheses. Their effects are observed indirectly
through future Events that re-enter the Observation loop.

Recommendations are consumed by humans or applications.

Candidate invariants:

- Every Recommendation links to Goal, Model, and EpistemicState context.
- A Recommendation must satisfy Goal alignment and epistemic restraint.
- A Recommendation is not treated as deterministically causing future Events.

## Decisions Settled

1. Model is the mutable current snapshot; Revision is immutable history.
2. Prediction uses expected_event_type and expected_event_matcher, not a future
   event_id.
3. EpistemicState is a current snapshot; prediction_readiness and
   revision_velocity may be derived or cached.
4. Revision supports outcome: strengthened, weakened, revised, unchanged.
5. Entity identity is stable, but non-learning metadata may be corrected.
   Entity must not contain learning state.
6. Recommendation is generated from Goal, Model, and EpistemicState, not
   EpistemicState alone.
7. Withheld Predictions are meaningful behavior but should be stored in
   metadata or Evaluation for v0, not as a new object.

## Open Questions

- What structure should expected_event_matcher use so it remains
  domain-independent while still being executable?
- Which EpistemicState fields are persisted snapshots, cached derived values,
  or purely computed at read time?
- How should Entity identity corrections be represented when the correction is
  more than metadata but still not learning?
- Should every failed constitutional gate produce an Evaluation record, or only
  gates that affect Prediction and Revision?
- How much of the Model current snapshot must be reconstructable from Revision
  history in v0?
- What metadata is sufficient to audit withheld Predictions without creating a
  dedicated object?

## Implementation Order

1. Define the core observation objects: Goal, Entity, Event, Observation.
2. Define the derivation chain: Signal and Evidence.
3. Define learning state: Model, EpistemicState, Revision.
4. Define hypothesis testing: Prediction, Feedback, Evaluation.
5. Define control-loop output: Recommendation.
6. Add invariant specs alongside each constitutional cluster:
   domain independence, evidence traceability, revision traceability,
   prediction falsifiability, epistemic gating, timestamp integrity, and
   immutable history.
7. Implement services only after object responsibilities and invariants are
   represented clearly enough to prevent bypassing the learning boundary.
