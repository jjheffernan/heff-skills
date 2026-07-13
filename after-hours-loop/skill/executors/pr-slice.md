# Executor: `pr-slice`

One ponytail-sized fix → one PR to **`dev`**. Workflow from [ponytail-debug](../../ponytail-debug/SKILL.md).

## Branch

```bash
git fetch origin dev
git checkout dev && git pull --ff-only origin dev
git checkout -b after-hours/<slug>
```

Slug from work item title (kebab-case, max ~40 chars). Optional helper: `node scripts/ponytail-branch.mjs <slug>` then `git branch -m after-hours/<slug>`.

## Implement

1. Read [ponytail](../../ponytail/SKILL.md) — smallest working diff.
2. Scope to item `acceptance` + `ref` only.
3. **Subagent routing** (Task tool):
   - UI / perf / landing → `ponytail-debug-coder`
   - Keystatic / copy → `site-content-coder` (**base `dev`**, not `layout`)
   - Membership / payments → respective coders; auth guard changes → **stop loop**

## Tests

Run smallest row from ponytail-debug matrix:

| Symptom | Command |
|---------|---------|
| Home / landing / nav | `pnpm exec playwright test --config tests/playwright.config.ts tests/e2e/smoke.spec.ts tests/e2e/home-render.spec.ts` |
| JS util | matching `src/**/*.test.ts` + `pnpm test:run` |
| Integration / Keystatic | `pnpm test:integration` |
| Unsure | `pnpm test:all` |

One fix attempt on test failure; then mark item `blocked`.

## PR

```bash
gh pr create --base dev --title "fix(after-hours): <short title>" --body "$(cat <<'EOF'
## Summary
- …

## Work item
- <id> — <ref>

## Test plan
- [ ] …
EOF
)"
```

For `github-issues` items: include `Fixes #N` in body.

## TODO write-back

If item `source` is `todo-md`, follow [todo-md.md](../sources/todo-md.md) auto check-off in same branch before push.

## Outcome

| Result | Item status |
|--------|-------------|
| PR opened + tests pass | `done` |
| Cannot scope / blocked guardrail | `blocked` |
| User skip | `skipped` |

Append `{ "url": "...", "itemId": "...", "branch": "after-hours/..." }` to state `prs`.
