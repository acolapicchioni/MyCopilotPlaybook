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
```

**Rationale**: Clear naming prevents temporary files from polluting the repository and makes cleanup obvious.

---

## 📐 Code Quality Standards

### Core Principles
- **Write clean, readable code**: Prioritize clarity over cleverness. Code is read far more often than it's written.
- **Follow SOLID principles**: Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion.
- **DRY (Don't Repeat Yourself)**: Extract common logic into reusable functions, classes, or modules.
- **KISS (Keep It Simple, Stupid)**: Avoid unnecessary complexity. Simple solutions are easier to maintain and debug.
- **YAGNI (You Aren't Gonna Need It)**: Don't implement features or abstractions until they're actually needed.

### Type Safety
- **Use type hints everywhere**: Functions, methods, class attributes, variables.
- **Leverage type checkers**: Run mypy, pyright, or equivalent for your language.
- **Define data models**: Use Pydantic, dataclasses, or similar for structured data.
- **Avoid `Any` type**: Be explicit about types; `Any` defeats the purpose of type checking.

### Naming Conventions
- **Use meaningful names**: Variables, functions, and classes should clearly indicate their purpose.
- **Be consistent**: Follow the naming conventions of your language and framework.
- **Avoid abbreviations**: Use full words unless the abbreviation is universally understood (e.g., `id`, `url`).
- **Use verbs for functions**: Functions do things—name them accordingly (`calculateTotal`, `sendEmail`).

---

## 🔒 Security Best Practices

### Never Commit Secrets
- **No credentials in code**: No API keys, passwords, tokens, or sensitive data in version control.
- **Use environment variables**: Store secrets in `.env` files (excluded from git) or secret management systems.
- **Scan for leaked secrets**: Use tools like git-secrets, truffleHog, or GitHub's secret scanning.
- **Rotate compromised credentials**: If secrets are accidentally committed, rotate them immediately.

### Input Validation
- **Validate all inputs**: Assume all external input is malicious until proven otherwise.
- **Use parameterized queries**: Prevent SQL injection by using prepared statements or ORMs.
- **Sanitize user input**: Escape or validate data before rendering in HTML, executing commands, etc.
- **Implement rate limiting**: Protect APIs and endpoints from abuse and DoS attacks.

### Dependency Security
- **Keep dependencies updated**: Regularly update libraries and frameworks to patch security vulnerabilities.
- **Audit dependencies**: Use tools like `npm audit`, `pip-audit`, or Snyk to detect known vulnerabilities.
- **Follow least privilege principle**: Grant minimum necessary permissions to users, services, and processes.
- **Review dependency licenses**: Ensure compatibility with your project's license and organizational policies.

---

## 🧪 Testing Philosophy

### Testing Pyramid
- **Unit tests (base)**: Test individual functions, methods, and classes in isolation. Should be fast and numerous.
- **Integration tests (middle)**: Test interactions between components and modules. Moderate quantity and speed.
- **E2E/UI tests (top)**: Test complete user workflows through the application. Fewer tests, slower execution.

### Test-Driven Development (TDD)
- **Red-Green-Refactor**: Write failing test → Make it pass → Improve the code.
- **Test behavior, not implementation**: Focus on what the code does, not how it does it.
- **Keep tests independent**: Each test should run in isolation without depending on others.
- **Tests as documentation**: Well-written tests explain how code should be used.

### Test Quality
- **Arrange-Act-Assert (AAA)**: Structure tests clearly with setup, execution, and verification phases.
- **Use descriptive test names**: Test names should explain what's being tested and the expected outcome.
- **Test edge cases**: Don't just test the happy path; test error conditions, boundaries, and invalid inputs.
- **Maintain test code quality**: Tests are code too—keep them clean, readable, and maintainable.
- **Mock external dependencies**: Use mocks/stubs to isolate the code under test from external systems.

### Coverage Goals
- **Aim for ≥80% coverage**: High coverage doesn't guarantee quality, but it's a strong indicator.
- **Prioritize critical paths**: Ensure business-critical code has thorough test coverage.
- **Don't game the metrics**: Write tests that add value, not just to increase coverage numbers.
- **Regression tests before refactoring**: Add tests for existing behavior before changing code.

---

## 🌳 Git & Version Control Workflow

### Branching Strategy
- **Use descriptive branch names**: Format: `feature/short-description`, `bugfix/issue-number`, `hotfix/critical-issue`
- **Keep branches short-lived**: Merge frequently to reduce integration conflicts.
- **One concern per branch**: Each branch should address a single feature, bug, or refactoring.
- **Delete merged branches**: Clean up branches after merging to keep the repository tidy.

### Commit Best Practices
- **Write meaningful commit messages**: 
  - First line: Brief summary (50 chars or less)
  - Blank line
  - Detailed explanation (if needed): What changed and why
- **Commit atomic changes**: Each commit should be a logical, self-contained unit of work.
- **Commit frequently**: Small, frequent commits are easier to review and revert if needed.
- **Use conventional commits**: Consider formats like `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`

### Pull Request Guidelines
- **Keep PRs focused and small**: Easier to review, test, and merge. Aim for <400 lines of changes.
- **Provide context in PR description**: Explain what, why, and how. Link to related issues or tickets.
- **Self-review before requesting review**: Check your own changes first to catch obvious issues.
- **Address review feedback promptly**: Respond to comments and make requested changes quickly.
- **Squash commits when appropriate**: Keep main branch history clean with meaningful commits.

---

## 📚 Documentation Standards

### When to Document
- **Public APIs and interfaces**: Always document public methods, classes, and modules.
- **Complex logic**: Explain non-obvious algorithms, business rules, or workarounds.
- **Configuration and setup**: Document environment variables, configuration files, and setup steps.
- **Decisions and trade-offs**: Use comments to explain why a particular approach was chosen.

### Documentation Style
- **Use clear, concise language**: Avoid jargon and overly technical terms when simpler words work.
- **Keep documentation close to code**: Inline comments, docstrings, and README files near the code they describe.
- **Update docs with code changes**: Outdated documentation is worse than no documentation.
- **Include examples**: Show how to use functions, classes, or APIs with practical examples.

### Comments
- **Explain why, not what**: The code shows what it does; comments should explain why it does it.
- **Avoid obvious comments**: Don't comment on self-explanatory code.
- **Update comments with code**: When code changes, update the comments to match.
- **Use TODO/FIXME sparingly**: Track technical debt in an issue tracker (or `PLAN.md`), not scattered in comments.

### README Requirements
Every project should have a README.md with:
- **Project overview**: What the project does and why it exists.
- **Prerequisites**: Required software, tools, and versions.
- **Installation instructions**: Step-by-step setup guide.
- **Usage examples**: How to run, build, test, and deploy.
- **Project structure**: Brief explanation of directory organization.
- **Contributing guidelines**: How others can contribute (if applicable).
- **License information**: Clearly state the project's license.

---

## 🤖 AI-Assisted Development Best Practices

### Working with AI Coding Assistants
- **Provide clear context**: Give AI tools enough information about the project, constraints, and requirements.
- **Review all AI-generated code**: Never blindly accept suggestions—understand what the code does.
- **Refine iteratively**: Use AI suggestions as a starting point, then refine and improve.
- **Be specific in prompts**: Detailed, specific requests yield better results than vague ones.
- **Leverage AI for boilerplate**: Let AI generate repetitive code, tests, and documentation templates.

### Code Review for AI Suggestions
- **Check for security issues**: Verify that AI-generated code doesn't introduce vulnerabilities.
- **Verify best practices**: Ensure code follows project conventions and industry standards.
- **Test thoroughly**: AI-generated code needs the same testing rigor as human-written code.
- **Look for edge cases**: AI might miss unusual scenarios or boundary conditions.
- **Validate type safety**: Ensure AI-generated code includes proper type hints and passes type checks.

### Effective AI Collaboration
- **Use for brainstorming**: Ask AI for multiple approaches to a problem, then choose the best.
- **Learn from suggestions**: When AI suggests something unfamiliar, research and understand it.
- **Combine AI with human expertise**: Use AI to augment, not replace, your development skills.
- **Iterate on AI output**: Start with AI suggestions, then refactor to match your quality standards.

---

## 👥 Code Review Guidelines

### As a Reviewer
- **Be constructive and respectful**: Focus on the code, not the person. Suggest improvements, don't demand them.
- **Explain your reasoning**: Help the author understand why a change might be beneficial.
- **Distinguish between must-fix and nice-to-have**: Be clear about what's required vs. optional.
- **Praise good work**: Acknowledge clever solutions and improvements.
- **Review promptly**: Don't let PRs sit idle—timely feedback keeps the team moving.
- **Check for test coverage**: Ensure new code has appropriate tests.

### As an Author
- **Don't take feedback personally**: Reviews improve code quality and are a learning opportunity.
- **Ask questions**: If feedback is unclear, ask for clarification or examples.
- **Be open to learning**: Consider suggestions even if your approach works.
- **Explain your decisions**: If you disagree with feedback, explain your reasoning respectfully.
- **Respond to all comments**: Acknowledge every review comment, even if just with "Done" or "Fixed".

---

## ⚡ Performance & Scalability

### Performance Awareness
- **Measure before optimizing**: Use profiling tools to identify actual bottlenecks, not assumed ones.
- **Consider Big O complexity**: Be aware of algorithmic complexity, especially in loops and recursive functions.
- **Lazy load when appropriate**: Load resources only when needed to improve startup time and memory usage.
- **Cache strategically**: Cache expensive operations, but be mindful of cache invalidation.

### Design for Scale
- **Stateless when possible**: Stateless services are easier to scale horizontally.
- **Asynchronous processing**: Use queues and background jobs for long-running tasks.
- **Database optimization**: Index properly, avoid N+1 queries, use connection pooling.
- **Batch operations**: Process multiple items together instead of one-at-a-time when possible.

### Monitoring & Observability
- **Instrument your code**: Add metrics, traces, and logs to understand system behavior.
- **Monitor key metrics**: Response time, error rate, throughput, resource usage.
- **Set up alerts**: Get notified when metrics exceed thresholds or errors spike.
- **Structured logging**: Use JSON logs for easier parsing and analysis.

---

## 🛠️ Error Handling & Logging

### Error Handling
- **Fail fast and loudly**: Don't hide errors—let them surface quickly to catch issues early.
- **Handle errors at the right level**: Catch exceptions where you can meaningfully handle them.
- **Provide useful error messages**: Include context to help diagnose the problem.
- **Don't swallow exceptions**: Catching and ignoring errors makes debugging nearly impossible.
- **Use custom exception types**: Create domain-specific exceptions for better error handling.

### Logging Best Practices
- **Use appropriate log levels**: DEBUG, INFO, WARN, ERROR, FATAL—use them correctly.
- **Log meaningful information**: Include context, parameters, and state that helps debugging.
- **Avoid logging sensitive data**: Never log passwords, tokens, personal information, or secrets.
- **Structure logs for parsing**: Use structured logging (JSON) for easier analysis and monitoring.
- **Include correlation IDs**: Track requests across services with unique identifiers.

---

## 📦 Dependency Management

### Choosing Dependencies
- **Evaluate before adding**: Consider maintenance status, security, license, and community size.
- **Prefer established libraries**: Well-maintained, popular libraries are usually safer bets.
- **Avoid dependency bloat**: Each dependency adds maintenance burden and potential security risks.
- **Check licenses**: Ensure dependency licenses are compatible with your project's license.
- **Assess the need**: Can you implement it yourself in <100 lines? Maybe skip the dependency.

### Keeping Dependencies Updated
- **Regular updates**: Update dependencies regularly to get security patches and bug fixes.
- **Use automated tools**: Tools like Dependabot, Renovate, or Snyk can automate update PRs.
- **Test after updates**: Always run tests after updating dependencies to catch breaking changes.
- **Pin versions**: Use lock files (package-lock.json, Gemfile.lock, etc.) for reproducible builds.
- **Review changelogs**: Read release notes before updating to understand breaking changes.

---

## 🏗️ Code Organization

### Directory Structure
- **Group by feature**: Organize files and modules by feature or domain, not by type (MVC pattern exceptions apply).
- **Keep related code together**: Files that change together should live together.
- **Limit nesting depth**: Avoid deeply nested directory structures (3-4 levels max).
- **Use consistent naming**: Apply naming conventions consistently across the project.

### File and Function Size
- **Limit file size**: If a file exceeds ~500 lines, consider splitting it.
- **Limit function size**: Functions should do one thing. If >50 lines, consider refactoring.
- **Single responsibility**: Each module, class, and function should have one reason to change.
- **Extract configuration**: Move config, constants, and magic numbers to separate files.

### Separation of Concerns
- **Separate business logic**: Keep business rules separate from infrastructure (DB, HTTP, etc.).
- **Layered architecture**: Clear separation between presentation, application, domain, and infrastructure layers.
- **Dependency inversion**: High-level modules shouldn't depend on low-level modules. Use abstractions.
- **Interface segregation**: Prefer many small interfaces over one large interface.

---

## 🌍 Collaboration & Communication

### Team Communication
- **Communicate early and often**: Share progress, blockers, and decisions with the team.
- **Document decisions**: Use ADRs (Architecture Decision Records) for significant choices.
- **Ask for help**: If you're stuck for more than 30 minutes, reach out to the team.
- **Share knowledge**: Conduct code reviews, pair programming, and knowledge-sharing sessions.
- **Update PLAN.md**: Keep the single source of truth current with your progress.

### Remote Work Best Practices
- **Over-communicate**: In remote settings, err on the side of sharing too much information.
- **Use async communication**: Respect different time zones and work schedules.
- **Document everything**: Written documentation helps distributed teams stay aligned.
- **Regular sync-ups**: Have regular team meetings to stay connected and aligned.
- **Use video for complex topics**: Sometimes a quick call is more efficient than async text.

---

## ♿ Accessibility & Inclusivity

### Accessibility (a11y)
- **Design for all users**: Consider users with disabilities in your design and implementation.
- **Use semantic HTML**: Proper HTML structure improves screen reader compatibility.
- **Provide text alternatives**: Alt text for images, captions for videos, labels for form inputs.
- **Keyboard navigation**: Ensure all functionality is accessible via keyboard.
- **Test with accessibility tools**: Use tools like Lighthouse, axe, or WAVE to catch issues.
- **Follow WCAG guidelines**: Aim for WCAG 2.1 Level AA compliance at minimum.

### Inclusive Language
- **Use gender-neutral terms**: Avoid gendered pronouns in documentation and comments.
- **Avoid ableist language**: Replace terms like "crazy," "insane," "lame" with neutral alternatives.
- **Be culturally aware**: Consider global audiences; avoid idioms and cultural references that don't translate.
- **Use "allowlist/denylist"**: Instead of "whitelist/blacklist" for inclusive terminology.

---

## 📖 Continuous Learning

### Stay Current
- **Read industry blogs and articles**: Stay informed about new technologies and best practices.
- **Experiment with new tools**: Try new languages, frameworks, and tools in side projects.
- **Contribute to open source**: Learn from others and give back to the community.
- **Attend conferences and meetups**: Network and learn from peers in the industry.
- **Follow thought leaders**: Subscribe to newsletters, podcasts, and social media feeds.

### Learning from Mistakes
- **Conduct blameless postmortems**: Focus on what went wrong and how to prevent it, not who to blame.
- **Document lessons learned**: Share insights with the team to prevent repeated mistakes.
- **Iterate and improve**: Use retrospectives to continuously improve processes and practices.
- **Update this document**: Add new lessons learned and best practices as you discover them.

---

## 🎓 Final Notes

This document is a **living guide** and should evolve with your team's needs and lessons learned. Adapt these standards to fit your project's specific requirements while maintaining the core principles of quality, security, and collaboration.

**Remember**: These are guidelines, not rigid rules. Use your judgment and adapt as needed for your specific context. When in doubt, prioritize:
1. **Code clarity** over cleverness
2. **Maintainability** over premature optimization
3. **Security** over convenience
4. **Team collaboration** over individual heroics

**Copy this file** to your new projects and customize the project-specific parts in a separate `.github/PROJECT_INSTRUCTIONS.md` file.
