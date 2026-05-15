# MyCopilotPlaybook

> A multi-file playbook for AI-assisted development — behavioral guardrails, engineering standards, and operational rules for Copilot, Claude, Cursor, and friends.

## Why

LLMs code well, but without explicit rules they default to generic patterns and well-known failure modes: silent assumptions on ambiguous requests, bloated abstractions, drive-by refactors of unrelated code, and stopping when the code *looks* done rather than when it is verified.

This repo addresses both layers — a behavioral frame that shapes *how* an assistant approaches a task, and concrete engineering standards for *what* it produces.

## What's in this repo

| File | Audience | Role |
|------|----------|------|
| [`copilot-instructions.md`](./copilot-instructions.md) | LLMs | Terse, directive-only rules — drop into any project |
| [`PLAYBOOK.md`](./PLAYBOOK.md) | Humans | Rationale, lessons learned, tooling configs, workflow |
| `.github/instructions/*.instructions.md` | Copilot | Scoped instruction layers (`applyTo` frontmatter) |
| `docs/adr/*.md` | Both | Architecture decision records |

`scripts/sync-ai-instructions.sh` propagates `copilot-instructions.md` to tool-specific root files (`CLAUDE.md`, `AGENTS.md`, `GEMINI.md`, `.cursor/rules/*.mdc`).

## The four behavioral principles

1. **Think Before Coding** — state assumptions, ask before guessing, push back when warranted.
2. **Simplicity First** — minimum code that solves the stated problem, nothing speculative.
3. **Surgical Changes** — every changed line traces to the request.
4. **Goal-Driven Execution** — define success criteria up front, loop until verified.

These sit on top of the engineering standards (Pydantic, type hints, ≥80% coverage, Conventional Commits, security scanning, modularity, etc.). For the full set — including tooling configs, lessons learned, and Git workflow for AI sessions — see [`PLAYBOOK.md`](./PLAYBOOK.md).

## Quick start

```bash
# Copy the LLM-facing rules into your project
curl -O https://raw.githubusercontent.com/<your-handle>/MyCopilotPlaybook/main/copilot-instructions.md

# Then either rename to your assistant's convention (CLAUDE.md, AGENTS.md, GEMINI.md)
# or run the sync script to propagate to all tool-specific roots.
```

Full setup, project scaffolding, and pre-commit baseline are in [`PLAYBOOK.md`](./PLAYBOOK.md#-new-project-checklist).

## Credits

Behavioral principles adapted from the [Karpathy-Inspired Claude Code Guidelines](https://github.com/multica-ai/andrej-karpathy-skills) by Multica AI, which build on [Andrej Karpathy's observations](https://x.com/karpathy/status/2015883857489522876) on common LLM coding pitfalls.
