---
name: dev-workflow
description: Full development lifecycle orchestrator for Claude Code. Guides changes from planning through implementation, code review, and validation. Use when a developer wants to plan and implement code changes with a structured workflow that includes review and testing. This skill is triggered manually — it does not auto-trigger on any phrases.
---

# Dev Workflow

Orchestrate a complete development cycle: plan → approve → implement → review → validate.

## Phase 1: Plan

1. Enter plan mode (`!plan` or start Claude Code with `--plan`).
2. Read the repo to understand the codebase:
   - `README.md`, project structure, build/run/test instructions
   - Languages, frameworks, key dependencies
   - Existing patterns, conventions, architecture
3. Determine if the project is greenfield:
   - **Greenfield indicators:** empty src dirs, no existing business logic, fresh scaffold, README says "new project" or similar
   - **If not clearly greenfield:** treat all public APIs, config formats, database schemas, and CLI interfaces as stable — avoid breaking changes unless the user explicitly approves them
4. If the user's request is unclear or ambiguous, ask focused guiding questions. Limit to 2–3 questions per message. Cover:
   - Scope — what exactly should change?
   - Constraints — performance, backward compatibility, specific libraries?
   - Acceptance criteria — how will we know it works?
5. Produce a structured implementation plan:

```
## Implementation Plan

**Goal:** [one sentence]

**Files to modify/create:**
- `path/to/file` — [what changes and why]

**Approach:**
1. [Step with rationale]
2. [Step with rationale]

**Risks / trade-offs:**
- [Anything worth noting]

**Breaking changes:** None | [list with justification]
```

## Phase 2: Approve

Present the plan and wait for explicit user approval before proceeding. If the user requests changes, revise the plan and re-present. Do not begin implementation until the user confirms.

## Phase 3: Implement

Exit plan mode and implement the approved plan. Commit to the approach agreed upon — do not deviate without informing the user. Write clean, idiomatic code that follows existing project conventions.

## Phase 4: Review

Check if the `code-review` skill is available. If installed, trigger it against the implementation diff:

```bash
git diff HEAD~1  # or appropriate range covering the changes
```

If `code-review` is not installed, skip to Phase 6.

## Phase 5: Respond to Review

Check if the `code-review-response` skill is available. If installed, trigger it with the diff and the review output from Phase 4. For each suggestion:

- **ACCEPT** — implement the fix immediately
- **REJECT** — leave as-is, note the reasoning
- **DISCUSS** — present to the user for a decision

If `code-review-response` is not installed, review the Phase 4 output directly: implement clear improvements (bugs, security, correctness) and skip stylistic nits.

## Phase 6: Validate

Check if the `code-change-validator` skill is available. If installed, trigger it against the final diff (including any review fixes). Let it run the full validation workflow: existing tests, exploratory testing, and regression test writing.

If `code-change-validator` is not installed, perform basic validation:

1. Run the project's existing test suite
2. Verify the changed behavior works as intended
3. Report results to the user

## Notes

- Always prefer the project's existing patterns over "better" alternatives — consistency wins.
- If any phase surfaces a problem that invalidates the plan, stop and re-plan with the user rather than improvising.
- Keep the user informed between phases with brief status updates.
