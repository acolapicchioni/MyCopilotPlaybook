# My Copilot Playbook

> **Purpose**: A reusable, open-source collection of **project-agnostic** development standards, workflows, and lessons learned for AI-assisted development.

## 📖 What is this?

This repository contains a comprehensive `.github/copilot-instructions.md` file that serves as a baseline for AI-assisted development with GitHub Copilot and other AI coding assistants.

The instructions emphasize:
- 🏭 **Industrial-grade development** - Production-ready quality from day one
- 🔒 **Security by default** - Never compromise on security
- 🧪 **Test-driven approach** - ≥80% coverage, regression tests before refactoring
- 📐 **Clean architecture** - Strong typing, low technical debt, modular components
- 🤖 **AI collaboration** - Best practices for working with AI coding assistants

## 🚀 How to Use

### For New Projects

1. **Copy the instructions file** to your project:
   ```bash
   curl -o .github/copilot-instructions.md https://raw.githubusercontent.com/acolapicchioni/MyCopilotPlaybook/main/.github/copilot-instructions.md
   ```

2. **Create project-specific instructions** (optional):
   - Create `.github/PROJECT_INSTRUCTIONS.md` for architecture, patterns, and conventions unique to your codebase
   - The generic instructions file remains project-agnostic and reusable

3. **Start developing** with GitHub Copilot:
   - Copilot will automatically read and follow the instructions in `.github/copilot-instructions.md`
   - AI assistants will help enforce the standards defined in the file

### Key Conventions

#### PLAN.md Convention
Use `PLAN.md` as the single source of truth for project roadmap, backlog, and status:
- `## Objectives` - High-level project goals
- `## Active Workstreams` - Current focus areas (checkbox format)
- `## Backlog` - Prioritized future work
- `## Completed` - Done items with completion notes

#### Temporary Files Convention
Always use `temp.` or `temp_` prefix for throwaway files to prevent repository pollution:
- ✅ `temp.analysis.md`
- ✅ `temp_test_script.py`
- ❌ `analysis.md` (looks permanent)

## 🎯 Who is this for?

- **Developers** starting new projects who want a solid foundation
- **Teams** establishing AI-assisted development workflows
- **AI Coding Assistants** (GitHub Copilot, etc.) that need guidance on standards
- **Open source contributors** looking for best practices

## 📚 What's Included

The `.github/copilot-instructions.md` file covers:

- **Core Development Principles** - SOLID, DRY, KISS, YAGNI
- **Security Best Practices** - Secret management, input validation, dependency security
- **Testing Philosophy** - TDD, testing pyramid, ≥80% coverage goals
- **Git Workflow** - Branching strategy, commit practices, PR guidelines
- **Documentation Standards** - When and how to document code
- **AI-Assisted Development** - How to effectively work with AI coding assistants
- **Code Review Guidelines** - For both reviewers and authors
- **Performance & Scalability** - Design patterns for production-ready code
- **Error Handling & Logging** - Best practices for debugging and monitoring
- **Dependency Management** - Choosing, updating, and securing dependencies
- **Code Organization** - Structure, separation of concerns, architectural patterns
- **Accessibility & Inclusivity** - Building for all users
- **Continuous Learning** - Staying current and learning from mistakes

## 🤝 Contributing

This is a living document that evolves with experience and lessons learned. Contributions are welcome!

1. Fork this repository
2. Make your changes to `.github/copilot-instructions.md`
3. Submit a pull request with your improvements
4. Share the reasoning behind your suggested changes

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## 🌟 Why Open Source?

Sharing these standards helps the entire development community:
- **Raise the bar** for AI-assisted development quality
- **Standardize best practices** across projects and teams
- **Learn from each other** through shared experiences
- **Accelerate onboarding** for new developers and AI tools

## 🔗 Related Resources

- [GitHub Copilot Documentation](https://docs.github.com/en/copilot)
- [GitHub Copilot Best Practices](https://docs.github.com/en/copilot/using-github-copilot/best-practices-for-using-github-copilot)
- [GitHub Copilot Instructions Format](https://docs.github.com/en/copilot/customizing-copilot/adding-custom-instructions-for-github-copilot)

---

**Made with ❤️ for the developer community**
