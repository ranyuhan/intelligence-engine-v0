# Intelligence Engine v0

Welcome.

This repository is a research project investigating whether a universal intelligence engine can continuously build, evaluate, and revise evidence-backed explanatory models of reality through feedback.

The objective is not simply to build software.

The objective is to discover, through implementation and experimentation, whether this architecture accurately describes how adaptive intelligence should work.

---

##Orientation

Read these documents in order.

### 1. Constitution

**`docs/constitution/ENGINE_CONSTITUTION.md`**

Defines the laws, virtues, and first principles that govern the Intelligence Engine.

This answers:

> **Why does the engine behave this way?**

---

### 2. Prototype Plan

**`docs/prototype/ONE_MONTH_PROTOTYPE_PLAN.md`**

Defines the current experiment.

This answers:

> **What are we trying to prove?**

---

### 3. Learning Loop

**`docs/architecture/LEARNING_DYNAMICS.md`**

Defines how intelligence emerges through interacting feedback loops.

This answers:

> **How does the engine learn?**

---

### 4. Object Model

**`docs/architecture/OBJECT_MODEL.md`**

Defines the engine's core objects and their relationships.

This answers:

> **What does the engine know?**

---

### 5. Research Notes

**`docs/research/`**

Contains:

- RESEARCH_LOG
- ASSUMPTIONS
- OPEN_QUESTIONS
- EXPERIMENTS
- FAILED_IDEAS

These documents record how reality has changed our understanding over time.

---

## Repository Philosophy

The repository separates three concerns.

```
Intelligence Engine
        ↓
Domain Ontology
        ↓
Application
```

The Intelligence Engine contains only universal concepts.

Domain Packages teach the engine what exists in a specific domain.

Applications expose the engine for a particular use case.

These boundaries should remain independent.

---

## Development Philosophy

The engine is developed through iterative feedback rather than comprehensive upfront design.

Each implementation cycle follows the same process:

```
Observe
    ↓
Model
    ↓
Implement
    ↓
Evaluate
    ↓
Revise
```

The codebase should evolve in the same way the engine itself is designed to learn.

---

## Guiding Question

Every architectural decision, pull request, and feature should help answer one question:

> **Can a universal intelligence engine continuously build, evaluate, revise, and appropriately limit evidence-backed explanatory models of reality through feedback?**

If a change does not improve our ability to answer that question, it probably does not belong in the prototype.