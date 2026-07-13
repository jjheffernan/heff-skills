# Bootstrap & preflight

Once per loop run: load config → parse Sources → preflight → write state (unless dry-run) → tick 0 (unless dry-run) → arm sentinel when in-session.

**Sources are the only night-time binding** to a workflow. Peer skills / trackers are optional inputs; **refuse** any gate that requires grill→tickets (or any chain) before bootstrap — the loop starts from Sources alone. See [composition.md](../docs/composition.md), [compatibility.md](./compatibility.md), [smoke-matrix](https://github.com/jjheffernan/heff-skills/blob/main/docs/smoke-matrix.md).

Default night templates activate `github-issues` / `todo-md` only. **`wayfinder-afk` and `github-tickets` stay opt-in** (commented in examples); never enable them by soft-detect.

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

### Mega-PR gate (optional, unsafe)

Default remains **sliced** PRs. To enable bundled mega-PR for **this arm only**, the kickoff must include **both** tokens per [mega-pr.md](./mega-pr.md):

```text
megaPr: true
CONFIRM_MEGA_PR: I_ACCEPT_BUNDLED_PRS
```

(or `/after-hours --mega-pr` plus the same `CONFIRM_MEGA_PR` line).

- Exactly one of the two → **Stop** preflight (`blocked` / `preflight`); do not guess.
- Config file / prior state / rules **cannot** enable mega-PR. If config contains `megaPr`, ignore it and note in the brief.
- Persist `megaPr: true` on **this run’s** state only after both tokens validate; never copy into config; next arm must re-confirm.

1. For each line, load matching `sources/*.md` and materialize items (portable queue fields: `id`, `title`, `acceptance`, `blockerPolicy`, `executorHint`, `outcomeKind` — [state-schema.md](./state-schema.md)).
2. Merge; sort by `priority` (`github-first` default).
3. Apply readiness; non-ready → queue as `blocked` or omit (prefer materialize + `blocked` with reason so the brief can list them).
4. Write state (unless dry-run) — see [state-schema.md](./state-schema.md). Including `megaPr` boolean for this run when gated on.
Optional overrides: `feature:example-phase1 executor:feature-build`, `github:52 executor:docs-digest`, or queue `executorHint: docs-digest`.

When binding: prefer `executorHint` / explicit `executor` over source defaults. `docs-digest` → load `executors/docs-digest.md` and default `outcomeKind: doc-artifact`. Leave `research-only` unchanged when that hint is set.

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
