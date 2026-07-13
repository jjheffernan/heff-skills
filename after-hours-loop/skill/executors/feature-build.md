# Executor: `feature-build`

Build from plan doc → one PR per **slice** to **`dev`**. Skills chain: [implement](../../implement/SKILL.md) → [tdd](../../tdd/SKILL.md) → [code-review](../../code-review/SKILL.md).

## Branch

```bash
git fetch origin dev
git checkout dev && git pull --ff-only origin dev
git checkout -b after-hours/feature-<slug>
```

Slug from work item id or `sliceHint`.

## Umbrella decomposition (first tick only)

If item `granularity` is `multi-slice` and queue has no children yet:

1. Read plan at `ref`.
2. Propose 2–5 vertical slices (each one PR).
3. Append child work items to state `queue` (inherit `source: feature-spec`, `executor: feature-build`, `granularity: single-pr`, `parentId: <umbrella id>`).
4. Do **not** mark umbrella `done` — process first child on same or next tick.

## Implement slice

1. Read [CONTEXT-MAP.md](../../../CONTEXT-MAP.md) — load relevant `CONTEXT.md` for touched context.
2. Read plan doc + item `acceptance` / `sliceHint`.
3. [implement](../../implement/SKILL.md) — TDD at pre-agreed seams.
4. Typecheck + targeted tests during work; full suite once at end of slice.
5. [code-review](../../code-review/SKILL.md) on diff before PR.

## Escalate (mark `blocked`, do not hack)

| Scope | Action |
|-------|--------|
| 6-locale content sweep | `blocked` |
| Membership schema migration | `payments-membership-coder` / `supabase-membership-coder` — or `blocked` if unattended |
| Large refactor | `refactor-worktree-coder` — not in after-hours slice |

## Tests

Same matrix as [pr-slice.md](./pr-slice.md). Feature slices should add/adjust tests at plan seams.

## PR

```bash
gh pr create --base dev --title "feat(after-hours): <slice title>" --body "$(cat <<'EOF'
## Summary
- …

## Plan
- <ref>
- Slice: <sliceHint>

## Test plan
- [ ] …
EOF
)"
```

Link GitHub issue in body if parent item originated from `github-issues`.

## TODO write-back

If item or parent linked `todo-md`, run check-off per [todo-md.md](../sources/todo-md.md).

## Outcome

| Result | Item status |
|--------|-------------|
| PR opened for slice | child `done`; umbrella `done` when all children terminal |
| Cannot decompose umbrella | umbrella `blocked` |
| Tests fail after one fix | slice `blocked` |

Append PR to state `prs`.
