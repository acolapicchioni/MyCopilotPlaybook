---
applyTo: "**"
---

When reviewing code, apply the following standards.

## Hard failures (request changes)
- Missing type hints on function/method signatures
- Any file longer than 300 lines
- Any function longer than 50 lines
- Bare `except:` usage
- Raw dictionaries used where Pydantic models should be used
- Hardcoded secrets or credentials
- Missing tests for new public functions

## Warnings (comment)
- Missing docstring on public API surface
- Coverage below project target
- Incorrect import ordering
- Commit message not following Conventional Commits

## AI-generated code scrutiny
- Verify logic and behavior, not only style
- Check for hallucinated imports or APIs
- Check for duplicated utility implementations
- Verify robust and specific error handling
