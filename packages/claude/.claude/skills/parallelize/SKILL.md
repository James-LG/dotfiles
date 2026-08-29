---
name: parallelize
description: Find independent work in the current task list or plan, do any foundational work that unlocks it, fan the rest out to concurrent subagents, then merge the results back. Use when there is an active todo list, plan, or multi-item task and the user wants it done in parallel. Triggers on phrases like "parallelize this", "fan this out", "run these in parallel", "split this work across agents", "what here can be done in parallel".
---

# Parallelize the Current Work

Take the work already on the table, figure out which parts are genuinely
independent, run those concurrently as subagents, and reassemble the result.

This skill does **not** invent new work. It only reorganizes the tasks that
already exist.

**Serial is a valid answer.** Being asked to parallelize is not evidence that
parallel work exists. If the tasks are genuinely dependent, say so and do them
in order — a manufactured fan-out costs more than it saves and corrupts the
tree. Never split work just to have something to split.

## 1. Establish the task list

Find the work, in this order of preference:

1. The active todo list (TodoWrite state) for this session.
2. A plan agreed earlier in the conversation.
3. A plan file the user points at (`PLAN.md`, an issue, a checklist).
4. If none exists, ask the user for the list. Do not guess.

Restate the tasks as a numbered list before analyzing. Drop anything already
completed.

## 2. Build the dependency graph

For each task, determine:

- **Files/dirs it will touch.** Read enough of the repo to answer this
  concretely — a guess here is what causes clobbering later. Use `grep`/`find`
  to locate the real files rather than assuming names.
- **What it consumes.** Does it need a type, function, migration, config key,
  or API that another task creates?
- **What it produces.** Anything a later task will consume.

Then group tasks into **waves**. A wave is a set of tasks that can run at the
same time. Wave N+1 may depend on wave N; tasks *within* a wave must not depend
on each other.

### Safe to parallelize

- Disjoint file sets with no shared symbols.
- Independent modules, packages, or services.
- Per-file mechanical work: renames across many files, adding tests for
  separate modules, migrating call sites one directory at a time.
- Pure research or investigation tasks (read-only — always safe).
- Documentation alongside code, when the docs describe already-settled
  behavior.

### Keep serial

- One task defines an interface another task implements or calls.
- Tasks that edit the same file, even in different regions — two agents
  writing the same file is a lost update, not a merge conflict.
- Anything touching shared, high-traffic files: lockfiles, `package.json`,
  DI/registry/barrel files, migration sequences, generated code.
- Schema or data migrations (ordering matters).
- Refactors whose shape is not yet decided — decide first, in one place,
  then fan out the application of that decision.
- Anything the user flagged as risky or exploratory.

**Bias toward fewer, larger parallel units.** Three agents doing coherent
chunks beats ten agents doing fragments; coordination cost and merge risk both
grow faster than the speedup.

### When there is nothing to parallelize

Reaching this conclusion is a success, not a failure of the skill. Report it
directly — do not hedge, do not fan out a token agent or two to look
productive, and do not shrink task boundaries until they technically stop
overlapping.

Say which tasks depend on which, and why the chain cannot be broken:

```
No parallel work available.

  1 → 2 → 3: each consumes the interface the previous one defines.
  4 edits the same file as 2.

Doing these serially.
```

Then just do the work in order, as you normally would. Do not stop and wait for
permission to proceed serially.

The honest partial cases matter too, and get the same treatment:

- **Only two of six tasks are independent** — say the speedup is marginal and
  recommend serial, rather than fanning out two agents for show.
- **Wave 0 is most of the work** — say so; the remainder may not be worth
  splitting.
- **The split depends on an assumption you could not verify** — say what you
  could not confirm and default to serial.

## 3. Pick an isolation strategy

Default to a **shared working tree with file ownership**: each agent gets an
explicit, disjoint list of files it owns and is told not to touch anything
else. No merge step, no conflicts, no worktree overhead.

Escalate to **git worktrees** (`isolation: "worktree"` on the Agent tool) only
when one of these is true:

- Two tasks genuinely need to edit the same file and cannot be serialized.
- An agent must run a build, test suite, dev server, or codegen step whose
  output would collide with another agent's.
- A task is speculative and you want to be able to throw its result away.

Worktrees buy safety at the cost of a real merge step in §7. Do not reach for
them by reflex.

## 4. Do the foundational work first

Parallel work often has a prerequisite that unlocks it: the shared type or
interface every agent will code against, the new module skeleton, the config
key, the dependency added to the lockfile, the decision about how the refactor
should look.

**Do that yourself, serially, before launching anything.** It is almost always
small, and doing it up front converts tasks that looked serial into tasks that
are safely parallel — each agent then codes against something that already
exists instead of guessing at it or racing to create it.

Look for foundational work whenever the graph in §2 shows:

- Several tasks all consuming the same not-yet-existing thing.
- Multiple tasks that would each need to edit the same shared file — hoist that
  edit into the foundation and the conflict disappears.
- A design question that every task would otherwise have to answer for itself,
  and answer differently.

Call this **wave 0**. Land it, verify it compiles, and only then fan out. If
wave 0 turns out to be most of the work, say so — parallelizing the remainder
may not be worth it.

## 5. Show the plan

Before launching, print:

```
Waves:
  Wave 0 (foundation, serial, done by me first):
    0. <shared interface / skeleton / dependency the rest needs>
  Wave 1 (parallel, 3 agents):
    A. <task>  — owns: src/auth/**
    B. <task>  — owns: src/billing/**
    C. <task>  — read-only research
  Wave 2 (serial, after wave 1):
    D. <task>  — depends on A's new interface

Isolation: shared tree, disjoint ownership
```

Then launch, unless something in the analysis is genuinely uncertain — in that
case ask first. Do not wait for approval on a clean, obviously-disjoint split.

If the analysis produced no parallel waves, print the dependency chain instead
and proceed serially — see §2.

## 6. Fan out

Launch every agent in a wave **in a single message with multiple Agent tool
calls** so they run concurrently. Sequential calls defeat the entire point.

Each agent prompt must contain:

- **The task**, self-contained. The subagent does not share your conversation
  context; restate the goal, the relevant decisions already made, and any
  interface it must conform to.
- **Owned paths**, explicitly: "You own `src/auth/**`. Do not create, edit, or
  delete any file outside it."
- **Shared-file rule**: "If you need a change in a file you do not own (e.g.
  `package.json`, a barrel export), do not make it — report it in your summary
  as a required follow-up."
- **Conventions**: point at the neighboring code and any project `CLAUDE.md`
  rules rather than restating style.
- **No commits, no pushes.** Merging and committing happen here, once.
- **Required output format:**
  ```
  STATUS: complete | partial | blocked
  FILES CHANGED: <paths>
  SUMMARY: <what was done, 2-5 sentences>
  SHARED-FILE REQUESTS: <edits needed outside owned paths, or none>
  ASSUMPTIONS: <anything guessed, or none>
  ```

Also decide the agent type per task: `Explore` for read-only investigation,
`general-purpose` (or the default) for implementation.

Do not run the same work yourself while an agent is doing it, and do not
fabricate an agent's result before its notification arrives.

## 7. Merge back

**Shared tree:** nothing to merge — the edits are already in place. Go to §8.

**Worktrees:** merge one branch at a time, in dependency order, resolving
conflicts as you go. After each merge, sanity-check that the tree still
builds before merging the next. Never merge all branches at once.

Then, in both cases:

1. **Apply the shared-file requests** yourself, in one pass. This is the step
   that exists precisely because agents were forbidden from doing it — imports,
   barrel exports, dependency additions, registry entries, config keys.
2. **Reconcile duplicated work.** Two agents may have independently added the
   same helper or type. Collapse the duplicates.
3. **Check the seams.** Read the boundaries where one agent's output meets
   another's: does the caller match the new signature? Do the names agree?

## 8. Verify once, at the end

Run the project's build, typecheck, lint, and tests **once** on the merged
tree — not per agent. Individually-green agents routinely produce a red merge;
this step is where that surfaces.

Fix failures yourself rather than dispatching another agent, unless the fix is
large and cleanly separable.

## 9. Report

Give the user:

- What each agent did, one line each.
- What you merged and fixed at the seams.
- Verification result, with real output if anything failed.
- Anything **not** done: tasks that stayed serial and are still pending, agents
  that came back `partial` or `blocked`, assumptions an agent flagged.

Then run the next wave, or hand back.

## Failure handling

- **An agent returns `blocked`:** do not re-launch it blindly. Read the reason;
  usually the task was mis-scoped, or it had a dependency that belonged in
  wave 0. Fold it into
  the next wave or do it yourself.
- **An agent edited outside its lane:** `git diff` will show it. Revert the
  out-of-lane hunks and apply the intended change yourself.
- **An agent dies or returns nothing:** treat its task as untouched and do it
  in the merge pass.
- **The merge is a mess:** it means the dependency analysis in §2 was wrong.
  Say so, back out to a clean state (`git checkout` / drop the worktree
  branches), and redo the work serially rather than patching over it.
