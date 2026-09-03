# claude-skills

A vendored snapshot of [mattpocock/skills](https://github.com/mattpocock/skills),
stowed into `~/.claude/skills/` so Claude Code picks the skills up. Upstream
installs them to `~/.agents/skills/`, which Claude Code does not read.

Upstream is MIT licensed; see [LICENSE](./LICENSE). These copies are modified:

- every skill is prefixed `mp-` — both its directory name and its frontmatter
  `name:` — so it can't collide with a Claude Code built-in (upstream
  `code-review` vs the built-in `/code-review`) or with the `jl-*` skills in
  the `claude` package;
- in-skill cross-references are rewritten to match, so the routing between
  skills still resolves: `/slash-form` references and `Skill tool with "..."`
  invocations. Prose mentions are untouched.

To refresh, re-pull upstream into `~/.agents/skills` with its installer
(`~/.agents/.skill-lock.json` records the source and per-skill hashes), then
re-copy and re-apply the prefixing above.
