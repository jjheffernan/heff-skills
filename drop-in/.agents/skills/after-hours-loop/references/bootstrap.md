# Bootstrap & preflight

Once per loop run: load config → parse Sources → preflight → write state (unless dry-run) → tick 0 (unless dry-run) → arm sentinel when in-session.

## Preflight checklist (fail-closed)

All must pass unless noted:

| Check | Pass criteria | On fail |
|-------|---------------|---------|
| Config loaded | Read `.cursor/after-hours-loop.config.json` if present; else defaults from SKILL | Continue with defaults; note in brief |
| `gh` auth | `gh auth status` OK when Sources include GitHub | **Stop** — `preflight` |
| Clean tree | If `safety.stopOnDirtyTree`: working tree clean | **Stop** — `preflight` |
| Base branch exists | Local or remote `baseBranch` resolvable | **Stop** — `preflight` |
| Sources non-empty | Parsed Sources yield ≥1 candidate **or** `allowEmptyQueue: true` / explicit allow in message | **Stop** — empty without allow |
| State dir writable | Parent of `statePath` exists and is writable | **Stop** — `preflight` |
| Agent-ready filter | Candidates pass [readiness.md](./readiness.md) into queue or all blocked noted | Empty executable queue → **Stop** (after writing brief on stop path) |

Do not start tick 0 coding if preflight fails.

## Sources parse

User (or Automation Instructions) supplies:

```text
Sources:
  - github-issues: label ready-for-agent limit 5
  - todo-md: section "Now"
  - feature-spec: docs/plans/example-plan.md phase 1
maxPrs: 3
priority: github-first
```

Full copyable example: [templates/Sources.example.txt](../templates/Sources.example.txt).

1. For each line, load matching `sources/*.md` and materialize items.
2. Merge; sort by `priority` (`github-first` default).
3. Apply readiness; non-ready → queue as `blocked` or omit (prefer materialize + `blocked` with reason so the brief can list them).
4. Write state (unless dry-run) — see [state-schema.md](./state-schema.md).

Optional overrides: `feature:example-phase1 executor:feature-build`.

## Dry-run mode

Triggers (any):

- `/after-hours --dry-run`
- `/after-hours` message includes `dryRun: true`
- Automation / prompt clearly says dry-run only

Behavior:

1. Run preflight + Sources parse + readiness classify.
2. **Print** the would-be queue (ids, titles, executor, ready vs blocked reasons).
3. **Stop** — no tick 0 coding, no PRs, **do not write** `statePath`, do not arm coding sentinel (optional: say what interval would have been).
4. Optional one-shot dry-run note to stdout / chat; morning brief optional (prefer chat print only unless user asked to write a dry-run brief).

## After successful bootstrap (non–dry-run)

1. Persist state with `version: 1`, `queue`, `maxPrs`, `tick: 0`, etc.
2. Run **tick 0** immediately.
3. In-session: arm sentinel per SKILL (`AGENT_LOOP_TICK_AFTERHOURS`); Automation: next cron fire is next tick.

## Soft context after preflight

Per [compatibility.md](./compatibility.md): soft-read CONTEXT/ADRs/issue-tracker when present; never block bootstrap solely because Matt skills are missing.
