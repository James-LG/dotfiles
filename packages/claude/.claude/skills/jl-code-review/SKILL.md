---
name: jl-code-review
description: Senior developer code review for git diffs. Use when the user asks to review code changes, critique a PR/MR, review a diff, or asks for feedback on code written by themselves or others. Triggers on phrases like "review this code", "review my changes", "code review", "critique this", "what's wrong with this code", or when a git diff is provided.
---

# Code Review Skill

Review code changes as a senior staff developer mentoring a junior. Provide
thorough, constructive feedback on correctness, design, style, and
maintainability.

## Getting the Diff

**If diff is provided:** Use the pasted/uploaded diff directly.

**If running in Claude Code with repo access:**
```bash
# Unstaged changes
git diff

# Staged changes
git diff --cached

# Compare branches (use origin/ to compare against the latest fetched
# remote tip, in case the local main/master is behind)
git fetch
git diff origin/main..HEAD  # or origin/master..HEAD

# Recent commits
git diff HEAD~3..HEAD
```

Ask the user which changes to review if unclear.

## Gather Context

Before reviewing, understand the codebase style:

1. **Check for style guides** (in order of precedence):
   - `CONTRIBUTING.md`, `STYLE_GUIDE.md`, `CODE_STYLE.md`
   - `.editorconfig`, `.prettierrc`, `.eslintrc`, `biome.json`, `rustfmt.toml`,
     `.clang-format`
   - `pyproject.toml` (ruff/black sections), `setup.cfg`, `.flake8`

2. **If no explicit guides:** Examine surrounding code in modified files to
   infer patterns for naming, formatting, error handling, and structure.

3. **Note the language/framework** to apply idiomatic practices.

## Deepen Context When the Diff Is Not Enough

A diff alone can be misleading. Before making a suggestion, verify you have
enough context to be confident it is correct. If you are unsure, read more of
the repo first. Common situations that require additional context:

- **Caller/callee relationships** — A function signature change may look wrong
  until you see how it is called. Search for usages before flagging.
- **Shared types and interfaces** — New or modified types may conform to a
  pattern defined elsewhere. Read the type definitions and related files.
- **Project conventions** — Naming, error handling, or architectural patterns
  may differ from common defaults. Check neighboring files and modules for
  precedent.
- **Deleted or moved code** — Code that appears missing from the diff may have
  been relocated. Search the repo before reporting dead code or missing logic.
- **Configuration and environment** — Behavior may depend on config files,
  environment variables, or feature flags not visible in the diff.

**Rule:** Do not suggest a change based on assumptions the diff cannot confirm.
Read the surrounding code first, and when a finding rests on a fact — a count,
"nothing calls this", "this doesn't compile", "the other copy differs" — run
the command that establishes it instead of asserting it. Cite the grep, not the
impression. A wrong suggestion is worse than no suggestion.

## The Sibling-Site Sweep (mandatory)

The most common defect in review-escaped code is not a wrong line — it is a
**right line in the wrong number of places**: one rule implemented two to five
times with the copies drifted, or a fix applied only at the site the bug report
named while its siblings keep the bug.

Stated up front because it is mandatory; it runs late. Work the checklist
below, then sweep, then write anything up — without exception when the diff is
a bug fix. Shapes #1 and #2 in `references/recurring-defects.md` carry the
procedure, the grep patterns, and what a positive result looks like. In short:
name the rule rather than the line, grep its shape across the whole repo rather
than the changed files, and account for every hit outside the diff. "Not
user-visible today" is not a pass.

If the sweep finds unfixed siblings, report them with `file:line` and an
explicit call: fold in, or file a follow-up before merge. Leaving it implicit
is how the same bug gets filed three more times.

## Review Checklist

Evaluate each category. Skip categories not applicable to the change.

Then run the targeted second pass in `references/recurring-defects.md` — 15
defect shapes that repeatedly survive review, each with the diff trigger that
should make you look and the probe to run. The highest-yield ones, if you read
nothing else:

| § Look for | When |
|---|---|
| §1 A rule implemented more than once, copies drifted | any block that encodes a domain rule |
| §2 A fix applied only at the reported site | any bug fix |
| §3 A test that stays green when the code breaks | any test change, any new guard |
| §4 A total derived from unrounded operands | any derived money/quantity value |
| §5 A failure path returning a valid-looking zero | any new catch / `?? 0` / `err != nil` branch |
| §6 Invalidation narrower than what the endpoint writes | any mutation or cache key |
| §7 A type mapping that isn't total over both enums | any cross-boundary translation |
| §8 A second write path missing the primary writer's checks | any importer, bulk endpoint, backfill, or scheduled job |
| §9 An owner check in a preamble instead of the query | any endpoint taking an id from the request |

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

A finding that covers several sites — including unfixed siblings turned up by
the sweep — lists them all under **Location** and names the call in
**Suggestion**: fold into this change, or file a follow-up before merge. Its
severity is that of the underlying defect; being found indirectly doesn't make
it lesser.

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
