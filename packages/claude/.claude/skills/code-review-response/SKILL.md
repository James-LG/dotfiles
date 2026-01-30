---
name: code-review-response
description: Evaluate code review feedback on your changes. Use when you have a git diff of changes you authored and a list of reviewer suggestions, and need to determine which suggestions to accept, reject, or discuss. Helps assess validity of style, architecture, performance, correctness, and refactoring feedback by analyzing the surrounding codebase for conventions.
---

# Code Review Response Evaluator

Evaluate reviewer suggestions against your changes and codebase conventions to produce a structured verdict for each.

## Inputs Required

1. **Git diff** of your changes
2. **List of reviewer suggestions** (numbered or bulleted)
3. **Codebase access** (if in claude-code) or relevant context files

## Workflow

1. **Parse the diff** — Identify files changed, additions, deletions, and the intent behind changes
2. **Gather context** — If codebase access available, read related files to understand:
   - Existing patterns and conventions
   - Similar implementations elsewhere
   - Project structure and architecture
3. **Evaluate each suggestion** against:
   - Author's apparent intent
   - Codebase conventions
   - Technical merit
   - Practical tradeoffs
4. **Produce verdicts** with reasoning

## Evaluation Criteria

For each suggestion, consider:

| Category | Questions to Ask |
|----------|------------------|
| **Style** | Does surrounding code follow this convention? Is it project-wide or localized? |
| **Architecture** | Does the suggestion align with existing patterns? What's the refactor cost? |
| **Performance** | Is the concern measurable? Does it matter in this context? |
| **Correctness** | Is there a real bug? Edge case? Or is it overly defensive? |
| **Refactoring** | Does it improve clarity? Is it scope creep for this change? |

## Output Format

For each suggestion, output:

```
## Suggestion N: "[Brief quote or summary]"

**Verdict:** ACCEPT | REJECT | DISCUSS

**Reasoning:** [2-4 sentences explaining why, referencing codebase patterns or technical tradeoffs]

**Alternative (if applicable):** [If rejecting but a middle ground exists, propose it]
```

## Verdict Guidelines

- **ACCEPT** — Suggestion is valid, improves the code, and aligns with codebase style
- **REJECT** — Suggestion conflicts with codebase conventions, author intent, or introduces unnecessary complexity
- **DISCUSS** — Suggestion has merit but tradeoffs exist; needs conversation with reviewer

Default to **DISCUSS** when:
- Both approaches are defensible
- Suggestion is valid but scope/timing is questionable
- Codebase has inconsistent patterns in this area

## Context Gathering

When codebase access is available, examine:

1. **Same file** — Patterns above/below the change
2. **Related files** — Similar implementations, shared utilities
3. **Config files** — Linters, formatters, style guides (`.eslintrc`, `rustfmt.toml`, etc.)
4. **Tests** — How similar code is tested elsewhere

When context is provided as text, work with what's given and note if more context would change the verdict.

## Example

**Diff excerpt:**
```diff
+ const userData = await fetchUser(id);
+ if (!userData) return null;
+ return processUser(userData);
```

**Suggestion:** "Use early return pattern and add explicit type annotation"

**Evaluation:**

```
## Suggestion 1: "Use early return pattern and add explicit type annotation"

**Verdict:** ACCEPT (partial)

**Reasoning:** Early return is already used here. Type annotation aligns with 
other functions in this file which use explicit return types. The early return 
comment may indicate reviewer missed the existing pattern.

**Alternative:** Accept the type annotation, clarify that early return is 
already implemented.
```
