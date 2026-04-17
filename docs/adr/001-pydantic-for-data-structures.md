# ADR 001: Pydantic for Data Structures

## Status
Accepted

## Context
The project needs validated, explicit, and serializable data structures for internal logic and interfaces.

## Decision
Use Pydantic models for all domain models and structured data exchange.

## Consequences
- Strong validation at boundaries.
- Consistent serialization/deserialization behavior.
- Slight learning curve and additional typing/modeling discipline.
