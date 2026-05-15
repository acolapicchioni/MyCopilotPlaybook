# Copilot Instructions — LLM Operational Rules

> Version 2.1 — adds Virtual Environment & Dependencies, Refactoring,
> Secrets Handling, and a structured PLAN.md convention; tightens
> Git, Testing, and File Access rules.
>
> Human-facing rationale, examples, and tooling configs live in
> [`PLAYBOOK.md`](./PLAYBOOK.md). Keep this file under 200 lines and
> directive-only.
>
> Behavioral principles below are adapted from the
> Karpathy-Inspired Claude Code Guidelines by Multica AI
> (https://github.com/multica-ai/andrej-karpathy-skills), which build
> on Andrej Karpathy's observations on common LLM coding pitfalls.

## Behavioral Principles

These principles apply *before* writing code and take precedence when in conflict with the implementation rules below.

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
- Apply single responsibility per file, class, function, and service.

## Code Rules
- Add type hints to all function and method signatures.
- Add Google-style docstrings to all public functions, methods, and classes.
- Represent structured data with Pydantic models instead of raw dictionaries.
- Keep files under 300 lines; split when they exceed this limit.
- Keep functions under 50 lines; extract helpers when needed.
- Keep classes focused and generally under 200 lines.
- Order imports as: standard library, third-party, local modules.
- Never use bare `except:`; catch specific exceptions.
- Log errors with context using `logger.error("…: %s", e, exc_info=True)`, then re-raise or wrap appropriately.
- Prefer keyword arguments when multiple parameters share similar types.
- Avoid duplicated utilities; reuse existing modules.
- Do not add dependencies unless necessary and approved by project conventions.

## Virtual Environment & Dependencies
- Activate the project venv before any development, testing, or execution.
- Install packages only into the active venv; never into system Python.
- Keep abstract dependency constraints in `pyproject.toml`.
- Generate pinned lock files for runtime (`requirements.txt`) and dev/test (`requirements-dev.txt`) via `pip-compile` or `uv pip compile`.
- Never deploy with unpinned dependencies.

## Testing Rules
- Maintain overall test coverage at or above 80%.
- Require 100% coverage on critical paths (authentication, data validation, payments).
- Organize tests under `tests/unit/`, `tests/integration/`, and `tests/e2e/`.
- Add regression tests before refactoring behavior-sensitive code.
- Add or update tests for every new public behavior.
- Prefer fixtures for reusable setup and teardown.
- Use `@pytest.mark.parametrize` for multi-case behavior validation.
- Keep tests deterministic; avoid hidden external dependencies.

## Refactoring
- Before refactoring: commit current state AND run the quality gate to confirm a green baseline.
- Add regression tests before changing behavior-sensitive code.
- After refactoring: the quality gate must still pass before committing.

## Git Rules
- Never commit directly to `main`.
- Use branch prefixes: `feature/`, `fix/`, `refactor/`, `docs/`, `chore/` (e.g. `feat/api-pagination`).
- Use Conventional Commits with types: `feat | fix | refactor | docs | test | chore` (e.g. `feat(api): add pagination`).
- Make atomic commits — one logical change per commit. Never mix refactoring with feature work.
- During AI-assisted sessions, commit at least every 15 minutes.
- Run the quality gate before each commit: `pytest && ruff check && mypy` (or project equivalent).
- Commit before refactoring and after each verified, meaningful step.

## Temporary Files
- Prefix all temporary files with `temp.` or `temp_`.

## File Access Security
- Never read files outside the project directory without explicit user permission.
- Treat the following as protected by default: `~/.ssh`, `~/.aws`, `~/.gcp`, `~/.azure`, `~/.kube`, `~/.config`, `~/.docker`, `~/.credentials`, and any file containing secrets, API keys, or tokens.
- Ask-first protocol: request file path + reason, wait for approval, then access only approved files.
- Reset permission assumptions every session.

## Secrets Handling
- Use environment variables for secrets in local development (e.g. via `.env` files with `python-dotenv`).
- Never commit `.env` files; ensure `.gitignore` excludes `.env*`.
- In production, use a secret manager (AWS Secrets Manager, Azure Key Vault, HashiCorp Vault) rather than bare environment variables.

## PR Reviews
- Request changes for: missing type hints, file >300 lines, function >50 lines, bare except, raw dicts where Pydantic is required, hardcoded secrets, missing tests for new public functions, or diffs containing edits unrelated to the stated task scope.
- Leave warnings for: missing docstrings, low coverage, incorrect import order, or non-conventional commit message patterns.
- Apply extra scrutiny to AI-generated code: verify logic, verify imports are real, detect duplicated utilities, and verify error handling.

## Planning
- `PLAN.md` is the single source of truth for objectives, active work, backlog, and completed items.
- Use the fixed section order: `## Objectives` → `## Active Workstreams` → `## Backlog` → `## Completed`.
- Represent actionable items as Markdown checkboxes (`- [ ] task`); move them to `## Completed` and mark `- [x]` when done.
- Do not create alternate plan documents.
- Update `PLAN.md` before starting work and when status changes.
- Each active item should carry an explicit success criterion (see Goal-Driven Execution).
