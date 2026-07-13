# Executor: `pr-slice`

One focused fix → one **draft** PR to the configured **base branch**.

## Config

From `.cursor/after-hours-loop.config.json` (defaults in brackets):

- `baseBranch` [`main`]
- `draftPrs` [`true`]
- `testCommand` [empty → infer]
- `packageManager` [`auto` → detect from lockfile / `package.json`]
- `safety.pathDenylist` — refuse and **stop loop** if changes would touch matched paths

## Branch

```bash
BASE="${baseBranch:-main}"
git fetch origin "$BASE"
git checkout "$BASE" && git pull --ff-only origin "$BASE"
git checkout -b after-hours/<slug>
```

Slug from work item title (kebab-case, max ~40 chars).

## Implement

1. Soft-read **ponytail** (or similar minimal-diff skill) **if installed** — smallest working change. Else: change only what acceptance requires; **no drive-by files** (no opportunistic refactors, formatting sweeps, or unrelated cleanup).
2. Scope to item `acceptance` + `ref` only. If acceptance is vague → `blocked`.
3. Soft-read `CONTEXT.md` / ADRs if present; do not rewrite them.
4. Domain Task subagents: use only if the **project** documents them; otherwise stay in-process.

## Tests

1. If `testCommand` set → run it.
2. Else try package manager test script (`pnpm test` / `npm test` / `yarn test` / `bun test`) or project README’s documented command.
3. One fix attempt on failure; then mark item `blocked`.
4. If no test command exists: set residual risk; mark `blocked` unless `allowSkipTests: true`.

## PR

```bash
BASE="${baseBranch:-main}"
DRAFT_FLAG=""
# when draftPrs true (default):
DRAFT_FLAG="--draft"

gh pr create --base "$BASE" $DRAFT_FLAG \
  --title "fix(after-hours): <short title>" \
  --body "$(cat <<'EOF'
## Summary
- …

## Work item
- <id> — <ref>

## Test plan
- [ ] …
EOF
)"
```

For `github-issues` items: include `Fixes #N` in body. No auto-merge.

## Safety checklist

Before commit / push / `gh pr create`:

- [ ] Draft flag matches `config.draftPrs` (`--draft` when true).
- [ ] Denylist check on staged/changed paths vs `safety.pathDenylist` — any match → **stop loop** escalate; never open PR ([guardrails.md](../references/guardrails.md)).
- [ ] Auth / webhook / guard **weakening** → **stop loop** escalate (not merely block item).
- [ ] Never `--force` push; never push to `main`/`master` as the feature branch — push only `after-hours/…` and PR into `baseBranch`.
- [ ] Diff is self-contained: no drive-by files beyond acceptance (ponytail if present; else same minimal-diff rule).

## TODO write-back

If item `source` is `todo-md`, follow [todo-md.md](../sources/todo-md.md) auto check-off in same branch before push.

## Outcome

| Result | Item status |
|--------|-------------|
| PR opened + tests pass (or skip allowed) | `done` |
| Cannot scope / blocked guardrail | `blocked` |
| User skip | `skipped` |

Append `{ "url": "...", "itemId": "...", "branch": "after-hours/...", "draft": true }` to state `prs`.

**After open:** if `draftPrs: true`, confirm draft with `gh pr view <url> --json isDraft -q .isDraft` (must be `true`). If not draft → convert to draft or **stop loop** (`stopReason: guardrail`) — never leave an overnight PR merge-ready by mistake.
