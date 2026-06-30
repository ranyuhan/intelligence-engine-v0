# Open Questions

Open questions are unresolved design, scientific, or architectural questions.

They are not assumptions yet.

An open question should become one of three things:

1. An assumption we temporarily accept.
2. An experiment we design.
3. A discarded concern because implementation shows it is irrelevant.

---

## Current Open Questions

### 1. Signal-to-Model Assignment

How should the engine handle a Signal that supports multiple Models simultaneously?

Possible approaches:

- Link one Signal to multiple Models with different evidence weights.
- Create a higher-level shared Model.
- Treat the Signal as contextual evidence until more evidence arrives.

Status: Open

---

### 2. Prediction Readiness Threshold

What minimum combination of Confidence and Observable Coverage is required before the engine is allowed to generate a Prediction?

Possible approaches:

- Fixed threshold.
- Domain-specific threshold.
- Model-type-specific threshold.
- Learned threshold from prediction outcomes.

Status: Open

---

### 3. Observable Coverage Calculation

How should Observable Coverage be calculated?

Possible approaches:

- Number of relevant events observed.
- Coverage across required signal types.
- Recency-weighted coverage.
- Domain-defined coverage checklist.

Status: Open

---

### 4. Surprise Classification

How should the engine distinguish between a low-probability event, a data gap, a weak Model, or a true Black Swan?

Status: Open

---

### 5. Model Quality

What makes one Model better than another?

Possible dimensions:

- Predictive power
- Explanatory power
- Simplicity
- Evidence coverage
- Revision stability
- Adaptability after surprise

Status: Open

---

### 6. Evidence Weighting

How should Evidence weight be calculated?

Possible inputs:

- Source reliability
- Recency
- Specificity
- Directness
- Consistency with other Signals
- Historical predictive value

Status: Open
