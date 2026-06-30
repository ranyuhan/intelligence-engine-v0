# Learning Dynamics
### Version 1.0

---

## Purpose

The Intelligence Engine is not defined solely by the objects it stores.

Its intelligence emerges from the interactions between those objects over time.

This document defines those interactions.

The Constitution defines the principles.

The Object Model defines the persistent state.

This document defines the dynamics by which the engine continuously learns from reality.

If the Object Model answers:

> **What exists?**

This document answers:

> **How does it become less wrong?**

---

# Intelligence as Feedback

The engine is not a pipeline.

It is not:

```

Input → AI → Output

```

It is a continuously self-regulating system.

Reality continuously produces observations.

Observations continuously refine models.

Models continuously generate predictions.

Reality continuously evaluates those predictions.

Those evaluations continuously improve the models.

Learning never stops.

---

# The Core Learning Loop

The smallest complete learning cycle is:

```

Reality
│
▼
Event
│
▼
Observation
│
▼
Signal
│
▼
Evidence
│
▼
Model
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
│
▼
Revision
│
▼
Model

```

Every complete cycle must leave the Model in one of four states:

- strengthened
- weakened
- revised
- explicitly unchanged

No complete cycle should terminate without producing learning.

---

# Object Dynamics

The intelligence of the engine depends less on the objects themselves than on how they interact.

| Object | Created By | Updated By | Consumed By | Immutable | Stored | Derived | Primary Feedback Source |
|----------|------------|------------|-------------|-----------|--------|---------|-------------------------|
| Goal | Human | Human | Model, Prediction | No | Yes | No | Human |
| Entity | Domain Ontology | Never | Event, Model | Yes | Yes | No | None |
| Event | Reality | Never | Observation | Yes | Yes | No | Reality |
| Observation | Observation Pipeline | Never | Signal | Yes | Yes | No | Event |
| Signal | Signal Pipeline | Never | Evidence | Yes | Yes | No | Observation |
| Evidence | Evidence Pipeline | Never | Model Revision | Yes | Yes | No | Signal |
| Model | Revision Engine | Revision | Prediction | No | Yes | No | Evaluation |
| Epistemic State | Evaluation Engine | Evaluation | Prediction | No | Yes | Partly | Evaluation + Observation |
| Prediction | Prediction Engine | Never | Feedback | Yes | Yes | No | Model |
| Feedback | Reality | Never | Evaluation | Yes | Yes | No | Reality |
| Evaluation | Evaluation Engine | Never | Revision | Yes | Yes | No | Feedback |
| Revision | Revision Engine | Never | Model | Yes | Yes | No | Evaluation |
| Recommendation | Recommendation Engine | Never | Human | Yes | Yes | No | Model |

The arrows above describe learning relationships rather than database relationships.

---

# Regulatory Loops

The engine contains several simultaneous feedback loops.

Each regulates a different aspect of intelligence.

---

## Loop 1 — Observation Loop

Purpose

Increase visibility into reality.

```

Reality

↓

Event

↓

Observation

↓

Observable Coverage

```

Regulates:

- Observable Coverage

Question answered:

> How much of relevant reality can the engine actually see?

---

## Loop 2 — Model Revision Loop

Purpose

Continuously improve explanatory models.

```

Evidence

↓

Model

↓

Prediction

↓

Evaluation

↓

Revision

↓

Model

```

Regulates:

- Model Quality

Question answered:

> Does the current Model explain reality better than before?

---

## Loop 3 — Epistemic Loop

Purpose

Represent uncertainty honestly.

```

Observable Coverage

+

Prediction Accuracy

+

Surprise History

↓

Epistemic State

↓

Prediction Readiness

```

Regulates:

- Confidence
- Observable Coverage
- Prediction Readiness

Question answered:

> Is the engine currently capable of making a trustworthy prediction?

---

## Loop 4 — Prediction Loop

Purpose

Test Models against reality.

The Prediction Loop is the engine's primary perception loop.

Its purpose is not to change reality, but to improve the engine's explanatory Model by comparing hypotheses against observable outcomes.

```

Model

↓

Prediction

↓

Reality

↓

Feedback

↓

Evaluation

```

Regulates:

- Prediction Calibration

Question answered:

> How accurate are the engine's hypotheses?

---

## Loop 5 — Recommendation Loop

Purpose

Influence reality through action.

The Recommendation Loop is fundamentally different from the Prediction Loop.

The Prediction Loop is a **perception loop**.

Its purpose is to improve the engine's understanding of reality by testing hypotheses against observable outcomes.

The Recommendation Loop is a **control loop**.

Its purpose is to influence reality by proposing actions that move the system toward its Goal.

One improves the Model.

The other attempts to improve the world.

```

Model

↓

Recommendation

↓

Human Decision

↓

Reality

↓

Event

↓

Observation Loop
```

Unlike the Prediction Loop, the Recommendation Loop does not produce a direct Evaluation.

Predictions are hypotheses whose outcomes can be compared directly against observable reality.

Recommendations are interventions. Their purpose is to influence reality rather than merely describe it.

Any effect of a Recommendation is observed indirectly through subsequent Events that re-enter the Observation Loop. Those Events may be influenced by many factors beyond the Recommendation itself.

The engine therefore does not assume that later outcomes can be attributed solely to a Recommendation.

Instead, Recommendations generate new observations that may strengthen, weaken, or revise the underlying Model through the normal learning process.

Attribution is therefore probabilistic rather than deterministic.

Regulates:

- Decision Quality

Question answered:

> Given the engine's current Model and Goal, what intervention is most likely to improve future outcomes?

---

## Loop 6 — Surprise Loop

Purpose

Discover blind spots.

```

Unexpected Event

↓

Evaluation

↓

Known Unknowns

↓

Revision

↓

Model

```

Regulates:

- Curiosity

Question answered:

> What important aspect of reality were we not modeling?

Unexpected events are not failures.

They are among the highest-value learning opportunities available to the engine.

---

# Constitutional Gates

Every transition between objects is governed by constitutional constraints.

| Transition | Gate |
|------------|------|
| Event → Observation | Trusted source |
| Observation → Signal | Extraction confidence |
| Signal → Evidence | Provenance traceability |
| Evidence → Model | Evidence threshold |
| Model → Prediction | Prediction Readiness |
| Prediction → Recommendation | Goal Alignment |
| Feedback → Evaluation | Reality observed |
| Evaluation → Revision | Evaluation complete |

A gate may prevent a transition.

Preventing an unjustified transition is itself correct engine behavior.

---

# Derived State

Not every property should be persisted.

Many properties are continuously derived from existing state.

| Property | Persisted | Derived |
|------------|-----------|----------|
| Confidence | ✓ | |
| Observable Coverage | | ✓ |
| Prediction Readiness | | ✓ |
| Revision Velocity | | ✓ |
| Surprise Score | | ✓ |

The engine should prefer deriving state whenever practical.

Persist only when historical traceability is required.

---

# Mutability Rules

Learning requires that some objects remain immutable.

| Object | Mutable |
|----------|----------|
| Goal | Yes |
| Entity | No |
| Event | No |
| Observation | No |
| Signal | No |
| Evidence | No |
| Model | Yes |
| Epistemic State | Yes |
| Prediction | No |
| Feedback | No |
| Evaluation | No |
| Revision | No |
| Recommendation | No |

Immutable objects preserve history.

Mutable objects represent the engine's current understanding.

---

# The Learning Boundary

Learning enters the engine through exactly one path.

```

Reality

↓

Feedback

↓

Evaluation

↓

Revision

↓

Model

```

No other process is permitted to change a Model.

This preserves the Discipline virtue defined in the Constitution.

No evidence.

No revision.

No learning.

---

# Multiple Simultaneous Loops

The engine is not executing a single feedback loop.

Several loops operate simultaneously.

```

Reality
│
├───────────────┐
│               │
▼               ▼
Observation   Surprise
│               │
▼               ▼
Signals     Known Unknowns
│               │
└──────┐   ┌────┘
▼   ▼
Evidence
│
▼
Model
│
├───────────────┐
│               │
▼               ▼
Prediction  Recommendation
│               │
▼               ▼
Reality      Human Action
│               │
└───────────────┘
│
▼
Feedback
│
▼
Evaluation
│
▼
Revision
│
▼
Model

```

The engine therefore regulates itself continuously rather than sequentially.

---

# What Makes Intelligence Different From Memory

Memory stores observations.

An intelligence engine continuously changes its explanatory Models based on new evidence.

The value of the engine is therefore not the quantity of information stored.

The value is the quality of its Model revision over time.

Learning is measured by the engine becoming progressively less wrong.

---

# Guiding Principle

Every new feature should improve at least one of the following:

- Observation
- Evidence quality
- Model quality
- Prediction calibration
- Recommendation quality
- Epistemic State accuracy
- Learning speed

If a feature improves none of these, it does not improve the Intelligence Engine.

---

*"The engine is not intelligent because it stores information.*

*It is intelligent because it continuously reorganizes its understanding of reality in response to feedback."*