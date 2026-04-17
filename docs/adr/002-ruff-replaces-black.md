# ADR 002: Ruff Replaces Black

## Status
Accepted

## Context
Black and Ruff overlap in formatter responsibilities, which duplicates tooling in the quality pipeline.

## Decision
Use `ruff format` as the project formatter and drop Black as a separate formatter.

## Consequences
- One fewer tool to configure and maintain.
- Faster formatting and simpler pre-commit setup.
- Equivalent formatting outcomes for project workflows.
