# Recurring Defect Patterns

Fifteen defect shapes that repeatedly survive review — each one, in practice,
having already passed at least one human or AI reviewer before it was filed.

Use this as a targeted second pass *after* the generic checklist in `SKILL.md`.
Each entry gives the **trigger** (what in the diff should make you look), the
**probe** (what to actually run or read), and the **tell** (what a positive
result looks like). Tier order is priority order: Tier 1 shapes are both the
most common and the most expensive to miss.

**The examples are illustrations of each shape, not findings about the code in
front of you.** Match the shape, then run the probe against this repo. Don't
report a pattern you haven't probed — a wrong suggestion is worse than no
suggestion.

---

## Tier 1 — highest yield

### 1. Duplicated rule, copies diverged

The single most common shape.

One domain rule — "what is this record worth", "is this input valid", "may this
user do this", "which caches does this write dirty" — has two to five
implementations. They start identical and drift, and the bug is always *in the
copy nobody was looking at*. Sub-forms:

- Two copies, one got a later bug fix and the other didn't — **and the fix
  landed on the copy that needed it less**, so the path that actually exercises
  the edge case still has the bug.
- Three copies carrying three different threshold constants, the divergence
  itself being the evidence.
- A shared helper *exists and is correct*, and the buggy site simply doesn't
  import it — it has one filter clause fewer, so it double-counts.

**Trigger:** the diff adds a block of ≥10 lines that encodes a rule, computes a
derived business value, or orchestrates a multi-step protocol.

**Probe:** take two or three distinctive tokens *from the block in front of
you* — a constant, a field name, an error string, an unusual filter predicate —
and grep the repo for each. Also grep for the name the codebase would give the
helper you'd expect to exist for this rule; consistent naming makes it
guessable.

**Tell:** a second site matches on two of your three tokens but not the third.
That missing third token is the bug — in one of the two copies.

**Report it as:** not "this is duplicated" (a style nit the author will
decline) but "these two copies disagree *here*, and one of them is wrong" —
name which, and why.

---

### 2. The partial fix — only the site the report named

A bug is reported at one location. The fix is applied there. The same rule in
two to four sibling locations is untouched, so the identical bug is refiled
weeks later — costing a whole extra issue, PR, and review cycle each time. Left
alone, one defect produces a chain of three or four repeat reports. The worst
version is user-visible immediately: the same value rendered two ways on two
screens, because only one of the two readers was fixed.

**Trigger:** the diff is a bug fix — especially a one-to-three-line one, and
especially if the PR description or commit message cites an issue number.

**Probe:** this is mandatory, not optional.
1. Characterise the *rule* that was wrong, not the line that changed
   ("skip zero-quantity rows when totalling" — not "line 78").
2. `grep -rn` the repo for that rule's shape: the predicate, the constant, the
   field pair.
3. For each hit, decide *out loud* whether it needs the same fix.

**Tell:** any hit outside the diff. "The other site isn't user-visible today"
is not a pass — today's internal-only path is next quarter's endpoint.

**Report it as:** a list of the unfixed sibling sites with file:line, and an
explicit recommendation: fold in, or file a follow-up before merge. Never leave
it implicit.

---

### 3. Tests that are green for the wrong reason

The most dangerous shape, because it disarms every other check.

- **Timing or ratio assertions.** A test asserting `slowPath > 2 × fastPath` to
  prove a constant-time property, where the suite configures the slow primitive
  at its cheapest setting — so the ratio measures scheduler noise, flakes on
  unrelated PRs, and gets blamed on whichever branch is unlucky.
- **Hand-mirrored schema.** A test that `CREATE TABLE`s another module's schema
  inline instead of running that module's migrations. Rename a column upstream
  and the suite stays green forever while the shipped binary is already broken.
- **Tested artifact ≠ shipped artifact.** CI resolves one dependency set and
  the container build produces another, so the tree under test and the tree in
  production differ — including in libraries that carry security weight.
- **The suite never runs.** A large pinned case set wired to no CI job; it
  executes only when a human types the command by hand.
- **Infra-absent skip that still reports success.** Nearly every test skipped
  because a database or broker wasn't reachable, and the run still exits 0.
- **A guard test that passes with the guard deleted** — it asserts an exit code
  and a log substring that the surrounding code emits anyway.

**Trigger:** the diff adds or changes a test; or adds a guard, refusal, or
security property and a test for it.

**Probe:** ask "what is the smallest edit to the *production* code that should
turn this test red?" Then check the test would actually catch it. For timing
tests, check the constant the threshold assumes is the constant the suite
configures. For a test that builds its own fixtures or DDL, check whether the
real schema is the source.

**Tell:** the answer is "nothing" or "I'm not sure".

---

## Tier 2 — cheap, specific, high hit rate

### 4. Round-then-derive: displayed values that don't add up

A total is derived from **unrounded** operands, then each operand *and* the
total is rounded independently at render. The displayed parts then fail to sum
to the displayed total by one unit in the last place. Two variants:

- *Row shape:* `remaining = total − used` computed unrounded, all three
  rendered at 2dp → `33.34 + 66.67` displayed against a total of `100.01`.
- *Envelope shape:* the summary card shows `round(Σ x)` while the column
  beneath it shows `Σ round(x)`.

Any conversion step — currency, unit, tax, percentage split — makes sub-unit
precision routine, so this is reachable, not theoretical.

**Trigger:** the diff computes a derived money or quantity value from two or
more others, **and** the API or UI emits more than one of them together.

**Probe:** is the rounding applied before or after the arithmetic? Does any
single screen or single response object carry the operands *and* the result?

**Fix to suggest:** round the operands first, derive the total from the rounded
pair. The invariant to assert is `displayed parts == displayed total` — check
whether *any* existing test asserts it. Usually none does, which is why this
shape survives several rounds of review.

### 5. Failure degrades to a valid-looking zero

The error path returns the type's zero value, which is indistinguishable
downstream from a legitimately-computed zero.

- A rate or price resolver that caches zero on a transport failure, where a
  downstream consumer reads non-positive as "fall back to the default" — so one
  network blip silently changes the meaning of every later result.
- A coercion helper mapping `undefined → 0`, feeding a view whose error state is
  wired to a *different* query, so a failed load paints a confident `0`.
- A lenient numeric parse that accepts `10abc` with no non-positive guard, where
  sibling call sites use a strict parse plus a guard.
- A missing optional secret yielding an empty string, with the process still
  reporting healthy.

**Trigger:** the diff adds a `catch` / `if err != nil` / `?? 0` / `|| 0` /
`ok == false` branch that produces a value rather than propagating.

**Probe:** can the caller distinguish this result from a real one? What does the
*next* layer do with a zero or empty here?

**Tell:** it can't, and the next layer has a meaningful behaviour change at
zero. Suggest failing closed, or a sentinel the caller is forced to handle.

### 6. Cache key or invalidation under-covers what the write touches

- A mutation invalidates the obvious resource but not the others its endpoint
  writes — creating a parent row also writes a child row, so every
  child-derived query stays stale.
- Updating a setting that re-bases a value used app-wide invalidates nothing,
  because none of the affected query keys mention that setting.
- Two different hooks share one cache key with two different fetchers.
- A refresh path that can't clear its own negative cache, so "refresh" is a
  no-op until the TTL expires.

**Trigger:** the diff adds a mutation hook, a cache write, or a new query key.

**Probe:** read the *server handler* the mutation calls and list every table it
writes. Compare that against the invalidation set. Separately, grep the new
query key string — is there already another fetcher registered under it?

**Tell:** the handler writes a table whose queries aren't in the set. Also flag
any hand-rolled key list living next to a shared one in the same file.

### 7. Enum or vocabulary mapping isn't total across a boundary

Two services, or a database and a wire format, have overlapping-but-unequal
enums, and the translation function rewrites the one value someone thought
about and passes the rest through — so a value the destination never declared
crosses the boundary unchallenged.

The mirror image is a *collapse*: an adapter folding two source values into one
destination value, so no record reaching the consumer ever carries the
distinction the consumer branches on. That one degrades silently and can run
for months, because nothing errors and every individual screen looks plausible.

**Trigger:** the diff contains a mapping function between two systems' type,
status, or kind vocabularies — especially one shaped
`if x == A { return B }; return x`.

**Probe:** find both enum definitions — an OpenAPI `enum:`, a DB `CHECK`
constraint, a TS union, a Go const block — and set-difference them in **both**
directions.

**Tell:** the passthrough branch can emit a value the destination doesn't
declare, or the collapse branch destroys a distinction the destination branches
on. Ask for a total mapping with an explicit default that errors.

### 8. A sibling write path skips an invariant the main one enforces

The primary writer validates; a second path to the same table doesn't.

- An import path accepting a nesting depth every API writer rejects, via a bare
  `UPDATE ... SET parent_id` with no depth check.
- A validator that reimplements the writer's shape rules faithfully but omits
  one — typically the cross-row consistency check, because it's the one that
  needs more than the single row in hand.
- A background or scheduled path using a parse helper with no magnitude cap,
  where the interactive path uses one with.

**Trigger:** the diff adds any second door to an existing table — an importer, a
bulk endpoint, a migration backfill, a scheduled job, an admin tool.

**Probe:** find the primary writer for that table and enumerate its checks. Walk
them against the new path one by one.

**Tell:** any check present there and absent here. Prefer suggesting the new
path route *through* the existing validator over re-listing the rules.

### 9. Ownership or authorization asserted in a preamble, not in the query

A handler parses the caller's identity and then **discards it**, reading the
target from a path parameter — `DELETE /resources/{id}` gated by auth
middleware alone, letting any authenticated user act on another's data. That is
a straightforward IDOR. The systemic form is dozens of hand-rolled auth
preambles, each an independent opportunity to forget the one that matters.

**Trigger:** any new endpoint, or any query, that takes a resource id from the
request.

**Probe:** does the SQL carry `AND owner_id = $caller`? If the check sits in
application code above the query rather than in the query itself, say so — that
is the shape that fails.

**Tell:** caller identity is parsed but unused — a discarded binding such as
`if _, ok := callerID(...)` is a literal smell — or the `WHERE` clause has no
owner predicate.

### 10. Multi-step write outside a transaction; side effect after commit

Two dependent statements issued on a raw pool rather than inside a transaction:
a failure between them leaves the "latest" table advanced with no history row.
And the ordering variant — a flow minting a session or token *after* its
transaction commits, so the credential can outlive a record that rolled back.

**Trigger:** the diff issues two or more dependent writes, or performs an
external effect (token mint, event publish, email, webhook) near a commit
boundary.

**Probe:** is there a transaction wrapper? Is the effect inside it or after it?
Does a correct, atomic version of this operation already exist elsewhere in the
codebase to copy?

---

## Tier 3 — sweeps, worth one grep each

### 11. Date-only values through a timestamp constructor

`new Date("2026-09-05")` parses as **UTC** midnight; rendering it with a local
formatter rolls the label back a day for every user west of UTC — every point
on the chart, not an edge case. The companion shape is several implementations
of "what period is this" disagreeing on timezone.

**Probe:** grep the diff for `new Date(` / `Date.parse` / `time.Parse` applied
to a `YYYY-MM-DD` value, and for a date-only helper already in the repo. When
one exists, its docstring often names this failure verbatim and the new call
site simply isn't using it.

### 12. A new peer added to a set that's enumerated in several places

A new service, database, queue, or port exists in some enumerations and not
others: a backup job's hardcoded database loop under `set -e`, dying on a
removed entry and silently skipping every entry after it; a clone or seed task
that never learned about a service added months earlier, leaving cross-database
references dangling; a CI workflow binding a service to one port while the
proxy config it copies routes that service to another — turning the default
branch red and stopping every build and promotion.

**Probe:** grep for a *peer* of the thing being added — an existing service
name, an existing database name, the old port — and check every hit was
updated. Config, CI, task runners, and deploy manifests are where this hides;
it is almost never in application code.

### 13. Contract changed, but its teachers survive

The largest *cleanup* cluster. A method, table, error, or flag is removed or
changed and everything that describes it is left behind: a spec mandating
client methods that no longer exist; a spec still recording as "an open gap"
something that shipped; a dead status-code mapping plus the comments teaching
it; a one-shot migration binary reading tables a later migration dropped; a
stale `KEEP IN SYNC` pointer; a compatibility shim compensating for a schema
`required:` list that could simply be fixed.

**Probe:** for every identifier the diff *deletes* or renames, grep the repo
including `docs/`, `*.md`, API schemas, spec and proposal directories, and
comments.

**Caveat:** "zero live callers" is not proof a surface is dead in a
multi-commit refactor — a later commit may intend to restore it. Check the
branch's remaining commits before recommending deletion.

### 14. A quantity separated from its unit

Money is the common case, but this is any unit-carrying quantity: currency,
timezone, measurement system, tick size, locale, precision.

- Values summed across units without conversion, or a column storing an amount
  with no unit column beside it.
- A hardcoded default standing in for the user's configured unit.
- A rule stated too broadly. "Skip these rows, the summary column already
  counts them" may hold only for the default unit; applied blanket, it drops
  every non-default row out of the total entirely.
- Two surfaces converting at different bases — current rate vs as-of-date rate
  — so the same record is worth two different amounts on two screens.

**Probe:** for any new arithmetic on a unit-carrying quantity, ask what unit
each operand is in and whether anything actually guarantees they agree.

### 15. Dead flexibility

Low severity, but cheap to spot: single-implementation interfaces (which cost
their test suites a pile of stub methods), a wrapper with one caller, a struct
field with zero production writers, a code-generator option producing an
accessor nothing calls, a dozen copy-pasted fetch wrappers, hundreds of lines
of hand-drawn SVG replaceable by one icon per item.

Report these last. Drop them entirely if the user says a dedicated
over-engineering review is also being run on this diff.

---

## Anti-pattern: reviewing from the diff alone

Worth restating because it invalidates findings rather than producing them: on
a fan-out review where every finding read plausibly in isolation, the majority
carried a materially wrong claim — a transposed count, a reversed test result,
a code path that didn't exist.

Before reporting a finding that rests on a fact — a count, "nothing calls
this", "this doesn't compile", "the other copy differs" — run the command that
establishes it. Cite the grep, not the impression.
