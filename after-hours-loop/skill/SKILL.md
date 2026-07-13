---
name: after-hours-loop
description: >
  Modular overnight loop — pluggable work sources (GitHub issues, TODO.md,
  feature specs) and executors (PR slice, feature build). Use with /loop or
  Cursor Automation; PRs target dev. Trigger: after-hours-loop, /loop after-hours.
license: MIT
---

# after-hours-loop (orchestrator)

Repeatable late-session work: bootstrap **sources** → normalize **work items** → route to **executors** → PR to **`dev`**.

Glossary + examples: [docs/agents/after-hours-loop.md](../../../docs/agents/after-hours-loop.md).

## Module layout

| Layer | Path |
|-------|------|
| Sources | `sources/github-issues.md`, `sources/todo-md.md`, `sources/feature-spec.md` |
| Executors | `executors/pr-slice.md`, `executors/feature-build.md` |

Load the module named on each work item — do not duplicate their logic here.

## Runners

| Runner | Setup |
|--------|--------|
| **In-session `/loop`** | Bootstrap + tick 0 now; arm sentinel (see below) |
| **Cursor Automation** | Cron + repo `dev`; user edits source list in Instructions nightly |

## Bootstrap (once per loop run)

Parse user **Sources** block (one or more):

```text
Sources:
  - github-issues: label ready-for-agent limit 5
  - todo-md: section "Now"
  - feature-spec: docs/commerce/currency-support-plan.md phase 1
maxPrs: 3
priority: github-first
```

1. For each source line, read the matching `sources/*.md` and collect work items.
2. Merge into one queue; sort by **priority** (default **`github-first`**: all `github-issues` by number, then `todo-md`, then `feature-spec`). Override: `fifo` or `todo-first`.
3. Write [`.cursor/after-hours-loop.state.json`](../../../.cursor/after-hours-loop.state.json):

```json
{
  "startedAt": "ISO-8601",
  "sources": [{ "type": "github-issues", "config": { "label": "ready-for-agent", "limit": 5 } }],
  "queue": [],
  "prs": [],
  "maxPrs": 3,
  "tick": 0,
  "priority": "github-first"
}
```

4. Run **tick 0** immediately after bootstrap (do not wait for first sentinel sleep).

Per-item overrides at bootstrap: `feature:currency-phase1 executor:feature-build`.

## Each tick

1. **Refresh** sources that support it (`github-issues` on cloud Automation; skip refresh for completed IDs in-session unless source doc says otherwise).
2. Pick next `open` item per priority.
3. Read `executors/<name>.md` for that item's `executor` field → run.
4. Record outcome on item; append PR URL to `prs` if opened; increment `tick`.
5. **Stop** when no `open` items, `prs.length >= maxPrs`, or guardrail (below).

### Umbrella features

Parent item with `granularity: multi-slice` stays `open` until all child items (appended by `feature-build` executor) are `done` or `blocked`.

## Guardrails

| Condition | Action |
|-----------|--------|
| Product decision / B3 CDN / design phase gate ([TODO.md](../../../TODO.md) blockers) | `blocked`, skip item |
| Tests fail after one fix attempt | `blocked`, skip item |
| Auth/webhook guard weakening | **Stop loop** — escalate user |
| Empty queue | **Stop loop** — print summary |
| User: "stop loop" | Kill sentinel PID; do not re-arm |

## In-session `/loop` wiring

After bootstrap + tick 0:

```bash
while true; do
  sleep 2700
  echo 'AGENT_LOOP_TICK_AFTERHOURS {"prompt":"Continue after-hours-loop tick per .agents/skills/after-hours-loop/SKILL.md"}'
done
```

- Check terminals for an existing matching loop before starting another.
- Start background shell with `notify_on_output` on `^AGENT_LOOP_TICK_AFTERHOURS`.
- Track PID for stop.
- Re-arm only if open items remain and `maxPrs` not hit.

Interval: **45m** default (`2700` seconds). User may pass `/loop 30m` etc.

## Cursor Automation

- Repo: `jjheffernan/cosmic-themes-starter`, checkout **`dev`**.
- **Source list not hard-coded** — user edits Instructions before each night (same bootstrap syntax as above).
- One tick per cron fire unless `maxPrs` allows more in one run (default 1–2 for unattended).
- Cloud: `github-issues` refreshes via `gh`; `todo-md` / `feature-spec` use committed repo paths.

## Mandatory reads (every tick)

1. This file (orchestrator)
2. Active source + executor modules for current item
3. [ponytail](../../../.agents/skills/ponytail/SKILL.md) — minimal diff
4. [dev-server rule](../../../.cursor/rules/dev-server.mdc) — `pnpm dev` sandbox-safe

## Output (end of tick or stop)

- Items: done / blocked / skipped
- PR URLs opened this run
- Next open item (if continuing)
- Residual risk / manual checks (Safari, dark mode, i18n)
