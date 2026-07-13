# Work source: `feature-spec`

Feature build-out from plan docs (PRD, wayfinder output, `docs/**/*-plan.md`).

## Bootstrap config

```text
feature-spec: docs/commerce/currency-support-plan.md
feature-spec: docs/commerce/currency-support-plan.md phase 1
feature-spec: path/to/plan.md slice "formatMoney helper"
```

| Field | Meaning |
|-------|---------|
| path | Repo-relative plan doc |
| phase / slice | Optional scope filter within doc |

## Materialize (hybrid)

Read plan doc. Then:

### A. Explicit vertical slices in doc

If plan lists named slices, phases with checklists, or vertical-slice sections → **pre-split** one work item per slice:

```json
{
  "id": "feature:currency-formatMoney",
  "title": "formatMoney helper",
  "source": "feature-spec",
  "executor": "feature-build",
  "ref": "docs/commerce/currency-support-plan.md",
  "acceptance": "slice acceptance from plan",
  "granularity": "single-pr",
  "status": "open",
  "sliceHint": "formatMoney"
}
```

### B. Phase-level only

If plan says "Phase 1" without slice breakdown → one **umbrella** item:

```json
{
  "id": "feature:currency-phase1",
  "title": "Currency support Phase 1",
  "source": "feature-spec",
  "executor": "feature-build",
  "ref": "docs/commerce/currency-support-plan.md",
  "granularity": "multi-slice",
  "status": "open",
  "children": []
}
```

`feature-build` executor decomposes on first tick and appends child items to state queue. Children use IDs like `feature:currency-phase1:1-formatMoney`.

Parent → `done` only when all children `done` or `blocked`.

## Default executor

Always `feature-build` unless bootstrap override.

## Blocked

Mark `blocked` when plan requires:

- B3 CDN decision
- Design phase entry criteria not met ([TODO.md](../../../TODO.md))
- 6-locale sweep without EN-only scope in bootstrap

## Refresh

Static at bootstrap. Children appended at runtime by executor only.
