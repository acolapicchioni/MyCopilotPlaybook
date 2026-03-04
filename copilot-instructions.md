# AI Development Standards - Generic Best Practices

> **Purpose**: This file contains **project-agnostic** development standards, workflows, and lessons learned.
>
> **Reusability**: Copy this file to any new project as a baseline for AI-assisted development.
>
> **Audience**: Developers, AI coding assistants, team members learning our methodology.

---

## 🤖 Cross-Tool Compatibility

This file is designed to be consumed by **any AI coding assistant**. To make it discoverable, place it (or a symlink/copy) at the expected location for each tool:

| AI Tool | Expected Location | Notes |
|---|---|---|
| **GitHub Copilot** | `.github/copilot-instructions.md` | Also reads `.copilot/*.md` files |
| **Claude** (Claude Code) | `CLAUDE.md` | Project root. Also supports `.claude/` directory |
| **OpenAI Codex** (CLI) | `AGENTS.md` | Project root |
| **Google Gemini** (CLI / IDE) | `GEMINI.md` | Project root. Also supports `.gemini/` directory |
| **Cursor** | `.cursorrules` | Project root (markdown or plain text) |
| **Windsurf** (Codeium) | `.windsurfrules` | Project root |
| **Aider** | `.aider.conf.yml` | Project root (references other files) |

**Setup** (one canonical source, multiple entry points):

```bash
# Choose one canonical location (e.g., .github/ or project root)
CANONICAL="AI_DEVELOPMENT_STANDARDS.md"

# Symlink for each tool (adjust paths to your structure)
ln -sf "$CANONICAL" CLAUDE.md
ln -sf "$CANONICAL" AGENTS.md
ln -sf "$CANONICAL" GEMINI.md
ln -sf "$CANONICAL" .github/copilot-instructions.md
ln -sf "$CANONICAL" .cursorrules
```

> **Tip**: If a tool ignores symlinks, use a simple copy instead. Keep the canonical file as the single source of truth and copy on changes.

---

## 📁 Recommended Companion Files

**Project-specific instructions** belong in a separate file — that file contains architecture, patterns, and conventions unique to each codebase.

Suggested companion files in `.copilot/`, `.github/`, or project root:
- **Project instructions** — project-specific AI agent instructions (architecture, data flows, domain knowledge)
- **Code quality preferences** — cross-project tooling comparison (when migrating standards between repos)
- **Security rules** — file access policies for AI agents

---

## 🎯 Philosophy: Industrial-Grade Development

Our development approach prioritizes **production-ready quality** even for proof-of-concept code:

- ✅ **Strong typing** - Type hints everywhere, Pydantic models for data structures
- ✅ **Low technical debt** - Continuous monitoring and proactive cleanup
- ✅ **Clean architecture** - Clear separation of concerns, modular components
- ✅ **Test-driven** - Regression tests before refactoring, ≥80% coverage
- ✅ **Elegant structure** - Professional directory organization, no monoliths
- ✅ **Quality gates** - Automated linting, type checking, code review

**Why this matters**: Technical debt compounds exponentially. Maintaining quality from day one is cheaper than refactoring later.

---

## 🚨 Critical Rules (ALWAYS Follow)

### Planning Convention

**Use `PLAN.md` as single source of truth** for roadmap, backlog, and status.

**Structure** (fixed order):
1. `## Objectives` - High-level project goals
2. `## Active Workstreams` - Current focus areas (checkbox format)
3. `## Backlog` - Prioritized future work
4. `## Completed` - Done items with completion notes

**Rules**:
- ✅ Actionable items = Markdown checkboxes (`- [ ] task description`)
- ✅ Move to `Completed` and mark `- [x]` when done
- ✅ Update `PLAN.md` **before** starting new work
- ❌ Don't create alternate plan documents
- ❌ Don't let plans become stale (update weekly minimum)

**Rationale**: One source of truth prevents confusion, enables tracking, and maintains project visibility.

---

### Temporary Files Convention

**ALWAYS use `temp.` or `temp_` prefix** for throwaway files.

**Examples**:
```bash
# ✅ CORRECT - Temporary files with prefix
temp.analysis.md         # Temporary analysis (Markdown syntax preserved)
temp_test_script.py      # Quick test script (Python syntax highlighting)
temp.debug_output.txt    # Debug logs
temp_validation.sh       # One-time validation

# ❌ WRONG - Permanent-looking names
analysis.md
test_script.py
debug_output.txt
````

**Why prefix, not suffix?**

  - ✅ IDEs recognize file type correctly (`.py`, `.md`, `.sh`)
  - ✅ Syntax highlighting works properly
  - ✅ File type associations preserved
  - ✅ Sorts together in file listings
  - ✅ Visual indicator in explorers

**Cleanup** (example script):

```bash
# Safe deletion (only temp prefix)
find . -name 'temp.*' -o -name 'temp_*' | xargs rm

# Or via a script
./scripts/cleanup_temp.sh --dry-run  # Preview
./scripts/cleanup_temp.sh          # Delete
```

**Rationale**: Clear distinction between permanent and temporary artifacts reduces repository clutter and prevents accidental commits.

-----

### Before ANY Refactoring

**Create safety checkpoints and establish baseline:**

```bash
# 1. COMMIT first - safety checkpoint
git add -A
git commit -m "chore: checkpoint before refactoring X"

# 2. RUN all tests - establish baseline
pytest tests/ -v  # or equivalent test runner

# 3. CHECK technical debt - know current state
# (if debt tracking script exists)
python scripts/check_technical_debt.py

# 4. LINT code - verify quality
ruff check .      # or pylint, eslint, etc.
mypy .            # or TypeScript check
```

**Why this matters**: Refactoring without tests is guessing. Checkpoints enable safe rollback.

-----

### After ANY Code Changes

**Verify quality before moving on:**

```bash
# 1. RUN regression tests
pytest tests/ -v

# 2. CHECK linting
ruff check .

# 3. VERIFY typing
mypy .

# 4. Add tests for new code, update tests for changed behavior

# 5. COMMIT with descriptive message (see Git Workflow section for format)
git commit -m "feat(module): description of change"
```

-----

### AI File Access Security Rule

**Before reading ANY file outside the project directory, the AI MUST explicitly ask permission.**

**Protected Directories** (NEVER read without permission):
- `~/.ssh/*`, `~/.aws/*`, `~/.gcp/*`, `~/.azure/*`, `~/.kube/*`
- `~/.config/*`, `~/.docker/*`, `~/.credentials/*`
- Any domain-specific credential directories
- Any file containing secrets, API keys, or private data

**How it works:**
1. AI asks: "May I read [file] to [reason]?"
2. Developer: "Yes" or "No, just tell me the format"
3. AI proceeds only if granted permission
4. Each session resets all permissions

**Why this matters**: AI agents can read files on your behalf. Without this rule, sensitive credentials could be ingested into AI context and potentially leaked through prompts or logs.

-----

### Virtual Environment Convention

**Every project MUST use a virtual environment.** Prefer a shared team/machine-wide venv if one exists; otherwise create a project-local one.

```bash
# Option A: Shared venv (if your team maintains one)
source ~/development/python_3_12_env/bin/activate  # or a shell alias

# Option B: Project-local venv (default for new projects)
python3 -m venv .venv
source .venv/bin/activate

# Then install
pip install -e ".[dev]"
```

**Rules**:
- ✅ Activate the venv before any development, testing, or execution
- ✅ Install packages into the venv (never system Python)
- ✅ Document the venv strategy in the project README
- ✅ If a team alias exists (e.g., `pythonenv`), note it in the project README
- ❌ Don't use `pip install` without the venv active
- ❌ Don't mix system Python and venv packages

-----

### Code Quality Standards

**Non-negotiable requirements:**

  - ✅ **Type hints required** - All function signatures must have type annotations
  - ✅ **Pydantic models** - Use for all data structures (validation + serialization)
  - ✅ **Docstrings required** - Google style for all public functions
  - ✅ **Test coverage ≥80%** - No exceptions (use coverage tools)
  - ✅ **No linting errors** - Fix immediately, don't accumulate
  - ✅ **Temporary files** - Always use `temp.` or `temp_` prefix
  - ✅ **Modularity** - Keep files, classes, and services small and focused (see Modularity lesson below)

**Import Ordering Convention** (enforced by Ruff `I` rule):

```python
# 1. Standard library
import logging
import os
from typing import Optional, List, Dict

# 2. Third-party libraries
import requests
import click
import yaml

# 3. Local project imports
from .config import settings
from .client import get_client
```

**Error Handling Pattern**:

```python
try:
    result = client.operation()
except SpecificError as e:
    logger.error("Descriptive message: %s", e, exc_info=True)
    raise  # or raise wrapping exception
except Exception as e:
    logger.error("Unexpected error: %s", e, exc_info=True)
    raise
```

**Example** (Python):

```python
from typing import List, Dict, Any
from pydantic import BaseModel

class DataRecord(BaseModel):
    """Data record with validation.
    
    Attributes:
        id: Unique identifier
        value: Data value
    """
    id: str
    value: float

def process_records(records: List[DataRecord]) -> Dict[str, Any]:
    """Process a list of data records.
    
    Args:
        records: List of validated data records
        
    Returns:
        Dict with processing results
        
    Raises:
        ValueError: If records list is empty
        
    Example:
        >>> records = [DataRecord(id="1", value=42.0)]
        >>> result = process_records(records)
        >>> print(result["count"])
        1
    """
    if not records:
        raise ValueError("Records list cannot be empty")
        
    return {
        "count": len(records),
        "total": sum(r.value for r in records)
    }
```

-----

## 💡 Lessons Learned (Continuous Improvement)

These patterns emerge from real debugging sessions and production issues. Treat them as **hard-won wisdom**.

### 1\. Logging is Fundamental - Visibility \> Guessing

**Problem**: Without server-side and client-side visibility, debugging is impossible.
**Solution**: Always add comprehensive logging BEFORE attempting complex fixes.

**Pattern**:

```python
import logging

# Configure at app startup
logging.basicConfig(
    level=logging.DEBUG,
    format='🔍 %(asctime)s [%(levelname)s] %(name)s: %(message)s',
    datefmt='%H:%M:%S'
)
logger = logging.getLogger(__name__)

# Use emoji prefixes for readability
logger.info("📥 User input received: %s", user_input)
logger.debug("✅ Tools initialized: %d tools available", len(tools))
logger.error("❌ Tool execution error: %s", error, exc_info=True)
```

**For async code**: Log entry/exit points, intermediate states, error paths.
**For web apps**: Combine server-side logging with browser console logging.

-----

### 2\. Lazy Evaluation - Don't Load What You Don't Need

**Problem**: Accessing object properties can trigger expensive operations (HTTP requests, DB queries).
**Solution**: Check library documentation for "lazy" vs "eager" properties. Filter on cheap properties first.

**Pattern**:

```python
# ❌ BAD - Loads expensive data for all items
for item in all_items:
    if expensive_keyword in item.full_details.description:  # HTTP request!
        matches.append(item)

# ✅ GOOD - Filter cheap first, load expensive only for matches
for item in all_items:
    if keyword in item.title:  # Already loaded, no cost
        try:
            details = item.full_details  # HTTP request only for matches
            matches.append({"title": item.title, "details": details})
        except Exception as e:
            logger.debug("Could not load details: %s", e)
```

**Real example**: A library's `collection.abstract` property might trigger an HTTP GET. Searching only `collection.title` first can provide a **10x speedup**.
**Use**: `hasattr()` checks, try/except for optional expensive properties.

-----

### 3\. Official Documentation & Examples are Precious

**Problem**: Implementing complex solutions when simpler patterns exist.
**Solution**: Before coding, check if vendor-provided notebooks/examples do it simpler.

**Pattern**:

```python
# Reference vendor examples in code comments
# See Vendor notebook 1_1_Discovering_collections.ipynb

# Vendor pattern (from examples)
datastore = vendor_lib.DataStore(token)
for collection in datastore.collections:  # Already has IDs and titles!
    print(f"{collection} - {collection.title}")

# Don't reinvent:
# ❌ Making separate HTTP requests to build collection list
# ✅ Use datastore.collections (already populated)
```

**Keep vendor examples** in `vendor_examples/` directory for quick reference during development.

-----

### 4\. Methodical \> Panic - Slow Down When Stuck

**Problem**: When multiple things break, panic leads to large unfocused changes that make things worse.
**Solution**: STOP, create systematic plan, isolate issues one at a time.

**Pattern**:
When stuck:

1.  Git checkpoint (commit current state)
2.  List all issues (write them down)
3.  Isolate ONE issue
4.  Add logging to understand flow
5.  Fix with minimal change
6.  Test fix
7.  Commit
8.  Move to next issue

**Warning signs of panic mode**:

  - Tempted to make "quick fixes" without understanding root cause
  - Large code changes when debugging (\>100 lines)
  - Multiple simultaneous fixes
  - Skipping tests "to save time"

**Better approach**: Add logging first, understand the flow, then make minimal targeted changes.

-----

### 5\. Parameter Order Bugs are Insidious

**Problem**: Type systems don't catch parameter order when types are compatible.
**Example**:

```python
def render_result(function_name: str, result: Any) -> None:
    ...

# ❌ WRONG - Both strings, type-checks pass, wrong behavior
render_result(result, function_name)

# ✅ CORRECT
render_result(function_name, result)

# ✅ BETTER - Use keyword arguments
render_result(function_name=tool_name, result=tool_result)
```

**Prevention**:

  - Always double-check function signatures when passing similar-typed parameters
  - Use keyword arguments for clarity
  - Consider using Pydantic models or TypedDict to enforce structure vs positional args

-----

### 6\. Modularity Principle - Divide et Impera

**Problem**: One mega-file (1000+ lines), one mega-service, one monolithic class = unmaintainable, complex, difficult to refactor.
**Solution**: Small, focused components with clear interfaces — embrace Unix philosophy ("Do one thing and do it well").

**The Goal**: Each component should be small enough to **rewrite without regrets** — if it takes 1000 hours to build, it's too big.

**Size Guidelines**:
- **Files**: Keep under 300 lines (warning at 500, hard limit 1000)
- **Classes**: Single responsibility, under 200 lines
- **Functions**: Under 50 lines (warning at 75)
- **Services**: One clear purpose, well-defined API boundary
- **Modules**: Cohesive functionality, minimal dependencies

**When to Split**:
- File exceeds 300 lines → Extract cohesive functionality
- Class has multiple responsibilities → Split by concern
- Function does multiple things → Extract helper functions
- Service has unclear boundaries → Define separate microservices

**Benefits**:
  - Easy to understand (read entire file in one screen)
  - Easy to test (focused unit tests)
  - Easy to refactor (small scope, clear boundaries)
  - Easy to replace (low investment, well-defined interface)
  - Easy to reason about (single responsibility)

**Remember**: "The best code is code you can throw away and rewrite in an afternoon."

**How to Apply**:

```python
# ❌ BAD - Monolithic structure
mypackage/
├── server.py              # 1500 lines - everything in one file
#   - Business logic mixed with API definitions
#   - Hard to test individual components
#   - Refactoring one part risks breaking others

# ✅ GOOD - Modular architecture
mypackage/
├── server.py              # 100 lines - API routing only
├── tools/                 # Each tool in a separate file
│   ├── search.py         # 80 lines
│   └── details.py        # 60 lines
├── core/
│   ├── client.py         # 150 lines - external API client
│   └── validation.py     # 50 lines - input validation
└── models/
    ├── requests.py       # 40 lines - request schemas
    └── responses.py      # 40 lines - response schemas
```

**Accept**: Minor performance overhead (extra imports, function calls) is acceptable for maintainability gains.

-----

## 🧪 Testing Strategy

### Test Organization

**Auto-marked by location** (using pytest or similar):

  - `tests/unit/` → Fast, mocked tests
  - `tests/integration/` → Network-dependent, slower tests
  - `tests/e2e/` → End-to-end workflows

**Run selectively**:

```bash
pytest tests/unit/          # Fast tests only
pytest tests/integration/   # Network-dependent
pytest -m "not network"   # Skip network tests
pytest -v --cov=src       # With coverage
```

### Test Coverage Requirements

  - **Minimum 80%** overall coverage
  - **100%** for critical paths (auth, data validation, payment)
  - Use coverage tools: `pytest-cov`, `coverage.py`, `nyc` (JS)

### Testing Patterns

**Test Class Pattern** (group related tests):

```python
class TestFeatureName:
    """Tests for feature_name function."""

    def test_basic_case(self):
        """Test the basic/happy path."""
        ...

    def test_edge_case(self):
        """Test edge case handling."""
        ...

    def test_error_case(self):
        """Test error handling."""
        with pytest.raises(ValueError):
            ...
```

**Fixtures for common setup**:

```python
# tests/conftest.py
import pytest
from unittest.mock import patch

@pytest.fixture
def sample_data():
    """Reusable test data."""
    return {"id": "123", "value": 42.0}

@pytest.fixture
def mock_client():
    """Mock external client."""
    with patch('module.Client') as mock:
        yield mock
```

**Parametrized tests for multiple cases**:

```python
@pytest.mark.parametrize("input,expected", [
    ("hello", "HELLO"),
    ("world", "WORLD"),
    ("", ""),
])
def test_uppercase(input, expected):
    assert uppercase(input) == expected
```

-----

## 🔄 Git Workflow & AI Safety Net

> **Why this section exists**: AI-assisted development makes refactoring dangerously easy. An AI can rewrite 500 lines in seconds — and destroy a working codebase just as fast. Git discipline is your **insurance policy** against hallucinations, regressions, and AI-generated mistakes. Without it, one bad AI session can undo days of work.

### Golden Rules

1. **NEVER work directly on `main`** — `main` is sacred; it must always be deployable
2. **Always develop on feature branches** — one branch per task/feature
3. **Commit early, commit often** — especially during AI-assisted sessions (see cadence below)
4. **Run tests before AND after every AI-assisted change** — AI doesn't know if it broke something
5. **Review AI-generated diffs before committing** — don't blindly accept large changes

### Branch Strategy

```bash
# Start every task on a new branch
git checkout main
git pull origin main
git checkout -b feature/add-export-csv

# ... work, commit, test ...

# When done: merge via PR (or merge locally if solo)
git checkout main
git merge feature/add-export-csv
git push origin main
git branch -d feature/add-export-csv
```

### Branch Naming

  - `feature/description` - New features
  - `fix/description` - Bug fixes
  - `refactor/description` - Code improvements
  - `docs/description` - Documentation
  - `chore/description` - Build/config

### Commit Cadence for AI-Assisted Development

AI sessions are high-velocity, high-risk. **Commit more frequently than you would with manual coding.**

**Recommended cadence during AI sessions:**

| When | What to commit |
|---|---|
| Before starting AI work | `chore: checkpoint before AI-assisted refactoring` |
| After each successful AI-generated change | `feat/fix/refactor: description of what changed` |
| Before asking AI for a large refactor | `chore: checkpoint — working state before major change` |
| When tests pass after AI changes | `test: verify all tests pass after AI changes` |
| End of AI session | `chore: end of AI session — all tests green` |

```bash
# Quick checkpoint alias (add to your shell profile)
alias gitck='git add -A && git commit -m "chore: checkpoint — working state"'
```

**Why so frequent?** If the AI hallucinates or introduces a subtle regression, you can `git diff` to see exactly what changed, or `git revert` / `git reset` to undo it cleanly. Without commits, you're comparing against memory.

### Commit Hygiene

  - ✅ Atomic commits (one logical change)
  - ✅ Descriptive messages (why, not just what)
  - ✅ Reference issues if applicable (`fixes #123`)
  - ❌ Don't commit broken code
  - ❌ Don't mix refactoring with features in one commit
  - ❌ Don't let an AI session run without committing for more than 15 minutes

**Commit message format** (Conventional Commits):

  - `feat(scope): description` - New feature
  - `fix(scope): description` - Bug fix
  - `refactor(scope): description` - Code change without behavior change
  - `docs(scope): description` - Documentation only
  - `test(scope): description` - Test changes
  - `chore(scope): description` - Build/config changes

### Recovery from AI Mistakes

When an AI generates broken or hallucinated code:

```bash
# Option 1: Undo uncommitted changes (if you haven't committed the bad code)
git checkout -- .                    # Discard all working directory changes
git clean -fd                        # Remove untracked files

# Option 2: Undo last commit (if you committed the bad code)
git revert HEAD                      # Safe: creates a new "undo" commit
# OR (solo work only):
git reset --soft HEAD~1              # Undo commit, keep changes staged
git reset --hard HEAD~1              # ⚠️ Nuclear: undo commit AND discard changes

# Option 3: Go back to a known-good checkpoint
git log --oneline -10                # Find the last good checkpoint
git checkout <commit-hash> -- .      # Restore files from that commit

# Option 4: Compare what the AI changed
git diff HEAD~1                      # See what the last commit changed
git diff main                        # See all changes vs main
```

**Prevention is better than recovery:**
- ✅ Commit before asking AI for big changes
- ✅ Review diffs (`git diff`) before staging
- ✅ Run regression tests after every AI change
- ✅ Keep AI changes small and incremental
- ❌ Don't let AI rewrite entire files without a checkpoint
- ❌ Don't accept multi-file refactors without reviewing each file

### Before Pushing

```bash
# Ensure clean state
git status
pytest tests/ -v
ruff check .
mypy .

# Then push
git push origin feature/my-feature
```

-----

## 🔒 Security Scanning

Three complementary security tools are integrated into the development workflow via pre-commit hooks:

| Tool | Purpose | Scope |
|---|---|---|
| [Gitleaks](https://github.com/gitleaks/gitleaks) | Detects secrets, API keys, passwords, tokens in commits | Git history + staged files |
| [Bandit](https://github.com/PyCQA/bandit) | Static security analysis for Python (OWASP-style) | Source code |
| [pip-audit](https://github.com/pypa/pip-audit) | Checks dependencies for known CVEs | `requirements.txt` / installed packages |

### What Each Tool Catches

**Gitleaks**: Hardcoded AWS keys, database passwords, private keys, API tokens, JWT secrets — anything that looks like a credential in your commits.

**Bandit**: SQL injection (`B608`), shell injection (`B602`, `B603`), hardcoded passwords (`B105`, `B106`), insecure deserialization (`B301`, `B302`), weak cryptography (`B303`, `B304`), unsafe YAML loading (`B506`), and more.

**pip-audit**: Known vulnerabilities (CVEs) in your installed Python packages, checked against the PyPI advisory database.

### Configuration

**Gitleaks** — `.gitleaks.toml` in project root:
```toml
title = "Project - Gitleaks Config"

[extend]
useDefault = true

[allowlist]
  description = "Global allowlist"
  paths = [
    '''tests/.*''',
    # Add project-specific paths to ignore here
  ]
```

**Bandit** — `[tool.bandit]` in `pyproject.toml`:
```toml
[tool.bandit]
targets = ["src"]
skips = ["B101"]  # Skip assert checks (used in tests)
```

**Pre-commit hooks** — `.pre-commit-config.yaml`:
```yaml
  # ── Security scanning ────────────────────────────────────
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.18.4
    hooks:
      - id: gitleaks

  - repo: https://github.com/PyCQA/bandit
    rev: 1.7.9
    hooks:
      - id: bandit
        args: ["-c", "pyproject.toml", "-r", "src"]
        additional_dependencies: ["bandit[toml]"]

  - repo: https://github.com/pypa/pip-audit
    rev: v2.7.3
    hooks:
      - id: pip-audit
        args: ["--desc"]
```

### Running Manually

```bash
# Via pre-commit (recommended — runs in isolated environments)
pre-commit run gitleaks --all-files
pre-commit run bandit --all-files
pre-commit run pip-audit --all-files

# Directly (uses venv packages)
python -m bandit -c pyproject.toml -r src/
pip-audit --desc
```

All three run automatically on every `git commit` once `pre-commit install` has been executed.

-----

## 🛠️ Recommended Tooling Stack

These are the vetted, cross-project tool choices. Copy these configs into `pyproject.toml` for any new Python project.

| Category | Tool | Why |
|---|---|---|
| **Formatter** | Black | Deterministic, zero-config |
| **Linter** | Ruff | Fast, supersedes flake8+isort+pyupgrade |
| **Type checker** | mypy | Gradual typing (strict on core, permissive elsewhere) |
| **Tests** | pytest + pytest-cov + pytest-mock | Standard, extensible, branch coverage |
| **Pre-commit** | pre-commit | Automated quality gates on every commit |
| **Security** | Gitleaks + Bandit + pip-audit | Secrets + code + dependency scanning |
| **CLI** | Click | Preferred CLI framework |
| **Config** | YAML + env vars | Shared config pattern |

### Concrete Configs for `pyproject.toml`

```toml
# ── Black ──────────────────────────────────────────────────
[tool.black]
line-length = 100
target-version = ["py312"]

# ── Ruff ───────────────────────────────────────────────────
[tool.ruff]
line-length = 100
target-version = "py312"

[tool.ruff.lint]
select = ["E", "F", "W", "I", "N", "UP", "B", "C4"]
ignore = ["E501"]
# E=pycodestyle, F=Pyflakes, W=warnings, I=isort,
# N=pep8-naming, UP=pyupgrade, B=bugbear, C4=comprehensions

# ── Mypy ───────────────────────────────────────────────────
[tool.mypy]
python_version = "3.12"
warn_return_any = true
warn_unused_configs = true
ignore_missing_imports = true
disallow_untyped_defs = false  # Permissive globally

[[tool.mypy.overrides]]
module = "mypackage.config"
disallow_untyped_defs = true   # Strict on config

[[tool.mypy.overrides]]
module = "mypackage.core_module"
disallow_untyped_defs = true   # Strict on critical modules

# ── Bandit ─────────────────────────────────────────────────
[tool.bandit]
targets = ["src"]
skips = ["B101"]

# ── Pytest ─────────────────────────────────────────────────
[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
python_classes = ["Test*"]
python_functions = ["test_*"]
addopts = ["-v", "--tb=short", "--strict-markers", "--disable-warnings"]

# ── Coverage ───────────────────────────────────────────────
[tool.coverage.run]
source = ["mypackage"]
branch = true

[tool.coverage.report]
exclude_lines = [
    "pragma: no cover",
    "def __repr__",
    "raise NotImplementedError",
    "if __name__ == .__main__.",
]
```

### Pre-commit Baseline (`.pre-commit-config.yaml`)

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.6.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-toml
      - id: check-added-large-files
      - id: debug-statements

  - repo: https://github.com/psf/black
    rev: 24.3.0
    hooks:
      - id: black
        language_version: python3.12

  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.3.4
    hooks:
      - id: ruff
        args: [--fix]

  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.9.0
    hooks:
      - id: mypy
        additional_dependencies: [types-PyYAML]  # add project-specific stubs
        args: [--ignore-missing-imports]

  # ── Security scanning ────────────────────────────────────
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.18.4
    hooks:
      - id: gitleaks

  - repo: https://github.com/PyCQA/bandit
    rev: 1.7.9
    hooks:
      - id: bandit
        args: ["-c", "pyproject.toml", "-r", "src"]
        additional_dependencies: ["bandit[toml]"]

  - repo: https://github.com/pypa/pip-audit
    rev: v2.7.3
    hooks:
      - id: pip-audit
        args: ["--desc"]
```

-----

## 🐳 Docker Best Practices

For containerized CLI tools:

```dockerfile
# Use slim base images (not full OS)
FROM python:3.12-slim-bookworm

# Security: update packages, install only what's needed, clean up
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates && \
    apt-get upgrade -y && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

# Layer ordering: dependencies first (cache-friendly), code second
COPY pyproject.toml ./
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir .

COPY src/ ./src/
COPY config/ ./config/

ENTRYPOINT ["my-tool"]
CMD ["--help"]
```

**Key principles**:
- ✅ Slim base image (`-slim-bookworm`) — smaller attack surface
- ✅ `--no-install-recommends` — minimal packages
- ✅ `--no-cache-dir` — smaller image
- ✅ Dependencies before code — better Docker layer caching
- ✅ `apt-get upgrade` — patch known vulnerabilities
- ✅ Clean up apt lists — reduce image size
- ❌ Don't use `latest` tag in FROM
- ❌ Don't run as root in production (add `USER` directive)

-----

## 📊 Technical Debt Management

### Debt Tracking

If project has debt tracking:

```bash
# Check current state
python scripts/check_technical_debt.py

# Review trends (if .debt_history.json exists)
git log -- .debt_history.json
```

### Debt Categories

  - **Type violations** - Missing type hints, `Any` overuse
  - **Linting errors** - Style violations, complexity warnings
  - **Test gaps** - Uncovered code, missing edge cases
  - **Documentation** - Missing docstrings, outdated README

### Debt Reduction Strategy

1.  **Boy Scout Rule** - Leave code cleaner than you found it
2.  **Weekly cleanup** - Dedicate time to debt reduction
3.  **Block new debt** - Don't merge code that increases debt
4.  **Track trends** - Debt should trend downward over time

-----

## 🎓 Onboarding Checklist

For new developers (or AI assistants) joining the project:

  - [ ] Read this file (generic standards)
  - [ ] Read `.github/PROJECT_INSTRUCTIONS.md` (project-specific)
  - [ ] Review `PLAN.md` (current roadmap)
  - [ ] Set up development environment (see project README)
  - [ ] Run test suite to verify setup
  - [ ] Make a trivial change and verify CI passes
  - [ ] Review recent commits to understand coding style
  - [ ] Identify and fix one small tech debt item (learn codebase)

-----

## 📚 Additional Resources

  - **Conventional Commits**: https://www.conventionalcommits.org/
  - **Google Python Style Guide**: https://google.github.io/styleguide/pyguide.html
  - **Semantic Versioning**: https://semver.org/
  - **Test Pyramid**: https://martinfowler.com/articles/practical-test-pyramid.html

-----

## 🔄 Maintaining This File

**When to update**:

  - New lesson learned from debugging session
  - New workflow pattern adopted
  - Tool/framework change affecting standards
  - Team consensus on new best practice

**What NOT to include here**:

  - Project-specific architecture (→ `PROJECT_INSTRUCTIONS.md`)
  - API endpoints, data models (→ project docs)
  - Deployment instructions (→ project README)
  - Temporary decisions (→ `temp.*.md`)

**Review frequency**: Quarterly, or after major incidents/learnings.

-----

## 📋 New Project Checklist

When starting a new Python project, set up these foundations:

```bash
# 1. Project structure
mkdir -p src/mypackage tests config docs
touch src/mypackage/__init__.py src/mypackage/__main__.py

# 2. Copy baseline configs from this file into:
#    - pyproject.toml (Black, Ruff, Mypy, Pytest, Bandit, Coverage)
#    - .pre-commit-config.yaml (formatting + linting + security)
#    - .gitleaks.toml (secret detection)
#    - .gitignore (include temp.* and temp_* patterns)

# 3. Install and activate
python3 -m venv .venv && source .venv/bin/activate
pip install -e ".[dev]"
pre-commit install

# 4. Verify
pre-commit run --all-files
pytest
```

*Last updated: 2026-03-04*
*Version: 2.0 (Generic — with security scanning, modularity, tooling stack)*
*Maintainers: Development Team*
