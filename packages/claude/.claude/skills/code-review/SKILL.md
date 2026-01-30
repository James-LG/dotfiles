---
name: code-review
description: Senior developer code review for git diffs. Use when the user asks to review code changes, critique a PR/MR, review a diff, or asks for feedback on code written by themselves or others. Triggers on phrases like "review this code", "review my changes", "code review", "critique this", "what's wrong with this code", or when a git diff is provided.
---

# Code Review Skill

Review code changes as a senior staff developer mentoring a junior. Provide thorough, constructive feedback on correctness, design, style, and maintainability.

## Getting the Diff

**If diff is provided:** Use the pasted/uploaded diff directly.

**If running in Claude Code with repo access:**
```bash
# Unstaged changes
git diff

# Staged changes
git diff --cached

# Compare branches
git diff main..HEAD

# Recent commits
git diff HEAD~3..HEAD
```

Ask the user which changes to review if unclear.

## Gather Context

Before reviewing, understand the codebase style:

1. **Check for style guides** (in order of precedence):
   - `CONTRIBUTING.md`, `STYLE_GUIDE.md`, `CODE_STYLE.md`
   - `.editorconfig`, `.prettierrc`, `.eslintrc`, `biome.json`, `rustfmt.toml`, `.clang-format`
   - `pyproject.toml` (ruff/black sections), `setup.cfg`, `.flake8`

2. **If no explicit guides:** Examine surrounding code in modified files to infer patterns for naming, formatting, error handling, and structure.

3. **Note the language/framework** to apply idiomatic practices.

## Review Checklist

Evaluate each category. Skip categories not applicable to the change.

### Critical (Bugs & Security)
- Logic errors, off-by-one, null/undefined access, race conditions
- Unhandled errors or exceptions
- Security: injection, auth bypass, secrets in code, unsafe deserialization
- Data loss or corruption risks
- Breaking changes to public APIs

### Design & Architecture
- Single Responsibility violations
- Tight coupling, poor separation of concerns
- Missing abstractions or over-abstraction
- Inconsistent patterns vs. rest of codebase
- Poor API design (confusing signatures, leaky abstractions)

### Code Quality
- Duplicated code (DRY violations)
- Dead code or unreachable branches
- Overly complex logic (high cyclomatic complexity)
- Magic numbers/strings without constants
- Poor naming (unclear, misleading, inconsistent)

### Style & Consistency
- Deviations from project style guide
- Inconsistent formatting, indentation, spacing
- Inconsistent naming conventions
- Import organization

### Performance
- Unnecessary allocations or copies
- N+1 queries, missing indexes
- Inefficient algorithms for data size
- Missing caching opportunities
- Blocking operations in async contexts

### Testing
- Missing tests for new functionality
- Untested edge cases
- Brittle tests (implementation-coupled)
- Missing error case coverage

### Documentation
- Missing/outdated doc comments on public APIs
- Complex logic without explanatory comments
- Misleading comments

## Output Format

Return a numbered list prioritized by severity. For each issue:

```
### N. [SEVERITY] Category: Brief Title

**Location:** `file.ts:42` or `file.ts:42-50`

**Issue:** Clear description of the problem.

**Why it matters:** Impact on correctness, maintainability, security, or performance.

**Suggestion:**
- For small fixes, provide the replacement code in a fenced block
- For larger refactors, describe the change clearly enough to prompt another AI

[Code block if applicable]
```

Number suggestions sequentially starting from 1 across all severity groups.

**Severity levels:**
- 🔴 **CRITICAL** — Bugs, security issues, data loss risks. Must fix.
- 🟠 **MAJOR** — Design flaws, significant maintainability issues. Should fix.
- 🟡 **MINOR** — Style inconsistencies, small improvements. Nice to fix.
- 🔵 **NIT** — Pedantic suggestions, personal preference. Optional.

## Example Output

See `references/example-review.md` for a complete example review.

## Tone Guidelines

- Be direct but constructive — critique the code, not the person
- Explain *why*, not just *what* — teach, don't just correct
- Acknowledge good patterns when you see them
- Differentiate strong recommendations from style preferences
- If the code is solid, say so briefly rather than inventing issues
