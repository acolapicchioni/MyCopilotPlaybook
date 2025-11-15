# AI Development Standards - Generic Best Practices

> **Purpose**: This file contains **project-agnostic** development standards, workflows, and lessons learned.
>
> **Reusability**: Copy this file to any new project as a baseline for AI-assisted development.
>
> **Audience**: Developers, AI coding assistants (GitHub Copilot, etc.), team members learning our methodology.
>
> **Project-specific instructions** are in a separate file (e.g., `.github/PROJECT_INSTRUCTIONS.md`) - that file contains architecture, patterns, and conventions unique to this codebase.

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

# 5. COMMIT with descriptive message
git commit -m "feat(module): description of change"
```

**Commit message format** (Conventional Commits):

  - `feat(scope): description` - New feature
  - `fix(scope): description` - Bug fix
  - `refactor(scope): description` - Code change without behavior change
  - `docs(scope): description` - Documentation only
  - `test(scope): description` - Test changes
  - `chore(scope): description` - Build/config changes

-----

### Code Quality Standards

**Non-negotiable requirements:**

  - ✅ **Type hints required** - All function signatures must have type annotations
  - ✅ **Pydantic models** - Use for all data structures (validation + serialization)
  - ✅ **Docstrings required** - Google/NumPy style for all public functions
  - ✅ **Test coverage ≥80%** - No exceptions (use coverage tools)
  - ✅ **No linting errors** - Fix immediately, don't accumulate
  - ✅ **Temporary files** - Always use `temp.` or `temp_` prefix

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

## 🔄 Git Workflow

### Branch Naming

  - `feature/description` - New features
  - `fix/description` - Bug fixes
  - `refactor/description` - Code improvements
  - `docs/description` - Documentation
  - `chore/description` - Build/config

### Commit Hygiene

  - ✅ Atomic commits (one logical change)
  - ✅ Descriptive messages (why, not just what)
  - ✅ Reference issues if applicable (`fixes #123`)
  - ❌ Don't commit broken code
  - ❌ Don't mix refactoring with features

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

*Last updated: 2025-11-15*
*Version: 1.1 (Generic)*
*Maintainers: Development Team*
```
