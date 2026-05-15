# AI Development Standards — LLM Instructions

## Behavioral Principles

These principles apply *before* writing code. They take precedence when in
conflict with implementation rules below (e.g. simplicity beats premature
abstraction).

### Think Before Coding
- State assumptions explicitly; ask instead of guessing when uncertain.
- Present multiple interpretations when a request is ambiguous; do not pick one silently.
- Push back when a simpler approach exists or when the request conflicts with these standards.
- Stop and ask when confused; name what is unclear rather than working around it.

### Simplicity First
- Write the minimum code that solves the stated problem.
- Do not add features, options, or configurability beyond what was asked.
- Do not introduce abstractions for single-use code.
- Do not handle errors that cannot occur.
- If the solution feels overcomplicated, rewrite it shorter before submitting.

### Surgical Changes
- Every changed line must trace to the requested task.
- Do not modify adjacent code, comments, formatting, or imports outside the task scope.
- Do not refactor code that is not broken.
- Match the existing style even when a different style would be preferable.
- Remove only the imports, variables, or functions that your own changes made unused.
- Flag unrelated dead code or smells; do not delete or fix them without approval.

### Goal-Driven Execution
- Define success criteria before starting (typically a failing test that must pass).
- For multi-step work, state a short numbered plan with a verification check per step:
  ```
  1. <step> → verify: <check>
  2. <step> → verify: <check>
  ```
- Loop until criteria are verified, not until the code looks done.
- For trivial tasks (typo fixes, obvious one-liners), use judgment; full rigor is not required.

## Architecture Decisions
- Use Pydantic models for all domain and data-transfer structures.
- Use the Repository pattern for data access boundaries.
- Use environment variables for runtime configuration and secrets.
- Use Click for CLI command interfaces.
- Keep architecture modular with clear separation of concerns.

## Code Rules
- Add type hints to all function and method signatures.
- Add Google-style docstrings to all public functions, methods, and classes.
- Represent structured data with Pydantic models instead of raw dictionaries.
- Keep files under 300 lines; split when they exceed this limit.
- Keep functions under 50 lines; extract helpers when needed.
- Keep classes focused and generally under 200 lines.
- Order imports as: standard library, third-party, local modules.
- Never use bare `except:`; catch specific exceptions.
- Log errors with context and re-raise or wrap appropriately.
- Prefer keyword arguments when multiple parameters share similar types.
- Avoid duplicated utilities; reuse existing modules.
- Do not add dependencies unless necessary and approved by project conventions.

## Testing Rules
- Maintain test coverage at or above 80%.
- Put tests under `tests/` with clear unit/integration structure.
- Add regression tests before refactoring behavior-sensitive code.
- Add or update tests for every new public behavior.
- Prefer fixtures for reusable setup and teardown.
- Use `@pytest.mark.parametrize` for multi-case behavior validation.
- Keep tests deterministic; avoid hidden external dependencies.

## Git Rules
- Never commit directly to `main`.
- Use feature/fix/chore branches (e.g., `feat/<scope>-<summary>`).
- Use Conventional Commits (e.g., `feat(api): add pagination`).
- During AI-assisted sessions, commit at least every 15 minutes.
- Run quality checks before each commit (`pytest`, `ruff check`, `mypy`, or project equivalent).
- Commit before refactoring and after each verified, meaningful step.

## Temporary Files
- Prefix all temporary files with `temp.` or `temp_`.

## File Access Security
- Never read files outside the project directory without explicit user permission.
- Treat credential and config directories as protected by default.
- Ask-first protocol: request file path + reason, wait for approval, then access only approved files.
- Reset permission assumptions every session.

## When Reviewing Code (PR Reviews)
- Request changes for: missing type hints, file >300 lines, function >50 lines, bare except, raw dicts where Pydantic is required, hardcoded secrets, or missing tests for new public functions.
- Request changes for diffs containing edits unrelated to the stated task scope.
- Leave warnings for: missing docstrings, low coverage, incorrect import order, or non-conventional commit message patterns.
- Apply extra scrutiny to AI-generated code: verify logic, verify imports are real, detect duplicated utilities, and verify error handling.

## Planning
- `PLAN.md` is the single source of truth for objectives, active work, backlog, and completed items.
- Update `PLAN.md` before starting work and when status changes.
- Each active item should carry an explicit success criterion (see Goal-Driven Execution).
