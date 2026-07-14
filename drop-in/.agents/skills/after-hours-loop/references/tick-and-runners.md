# Tick runners (`/after-hours`, `/loop`, Automation)

Loaded from the orchestrator when arming or continuing ticks — keep bash / cadence detail here so [SKILL.md](../SKILL.md) stays thin.

## Iterator model (FOR / WHILE)

Treat the run as two nested loops:

| Loop | Role | Breaks |
|------|------|--------|
| **FOR** (sentinel / cron) | Cadence only — wake the agent. No coding policy. | Stop phrases, OUTER guardrails, empty/budget stops — [guardrails](./guardrails.md) |
| **WHILE** (per wake) | Queue work under guardrails. Default: **one claim per wake**. | Item skip/block, tick budget, **interrupt** (park item; keep FOR) |

```text
bootstrap(); arm_sentinel_once();     # FOR driver

# each wake:
load skill + state
recover_orphan_claims()               # see state-schema
if sentinel dead and not stopped: re-arm once

while guardrails_allow:
  item = next_claimable()
  if none: stop OUTER (empty-queue); break
  try: claim → execute → persist
  except Interrupted: park(item, interrupted); break   # INNER only
  if tick budget done (default 1): break               # back to FOR
```

**Interrupt ≠ user-stop.** IDE abort mid-tick breaks the WHILE body (park item) and leaves the sentinel armed unless an OUTER stop already applies. Stop phrases still kill the PID — [after-hours-stop](../../after-hours-stop/SKILL.md).

## In-session sentinel

After bootstrap + tick 0 (not dry-run):

```bash
while true; do
  sleep 2700
  echo 'AGENT_LOOP_TICK_AFTERHOURS {"prompt":"Continue after-hours tick per .agents/skills/after-hours-loop/SKILL.md"}'
done
```

- Check terminals for an existing matching loop before starting another (**never** arm a duplicate).
- Start background shell with `notify_on_output` on `^AGENT_LOOP_TICK_AFTERHOURS`.
- Track PID for stop (`stop after-hours` / `stop loop`).
- Re-arm only if agent-ready `open` items remain, `maxPrs` not hit, and state is not stopped.
- Default interval **45m** (`2700`). `/after-hours 30m` or `/loop 30m` adjusts sleep.
- **Platform note:** long-idle monitored shells may die before the first tick. Prefer a shorter interval for reliability, smoke-check the PID on every wake, and re-arm once if dead while the run is still live — or use Automation cron ([docs/automation.md](https://github.com/jjheffernan/heff-skills/blob/main/docs/automation.md)).

## Wake protocol (mandatory)

On every `AGENT_LOOP_TICK_AFTERHOURS` (or Automation fire), **before** normal chat:

1. Read this skill (`SKILL.md`) + [state-schema](./state-schema.md) + current `statePath`.
2. Run **orphan-claim recovery** and **dirty-tree** policy ([guardrails](./guardrails.md)).
3. Health-check sentinel PID (in-session). If missing and run not stopped → re-arm once; do not create a second loop if one exists.
4. Continue the WHILE body (next claimable item). Do **not** ask the human whether to continue overnight work unless an OUTER stop already fired.

`disable-model-invocation: true` means the skill is user/automation-armed — wakes still **must** follow this protocol from the sentinel prompt; do not degrade to idle agent chat.

## Interrupt recovery (INNER)

When the agent turn is aborted mid-item (IDE interrupt / tool abort), on the **next** wake or as soon as the agent can write state:

1. Find the `in-progress` claim (orphan).
2. Set `status: blocked`, `blockReason: interrupted`; note residual risk (dirty paths / branch) in `notes`.
3. **Increment** `consecutiveBlocked` (same as other blocks).
4. **Do not** auto-commit, stash-as-success, or invent scope to “finish” the slice.
5. **Do not** kill the sentinel (FOR continues).
6. Apply [dirty-tree split](./guardrails.md#dirty-tree-split-interrupted-vs-unknown): try to return to a safe tree for the next item; only OUTER-stop if the tree remains dirty and unrecoverable.

## Each tick (summary)

1. Soft-detect peers ([compatibility.md](./compatibility.md)). Orphan recovery + dirty-tree policy ([guardrails.md](./guardrails.md)).
2. Refresh sources that support it.
3. Prefer finishing a recoverable claimed item only when the tree is clean **and** the claim was not just parked as `interrupted` this wake; else pick next `open` agent-ready item; claim ([readiness.md](./readiness.md), [state-schema.md](./state-schema.md)).
4. Run executor module (denylist before commit/push/publish). Prefer checkout of `baseBranch` unless continuing that item’s branch.
5. Run [outcome adapter](./outcomes.md) for `outcomeKind` (if `megaPr`, use bundled draft-pr path in [mega-pr.md](./mega-pr.md) — only for `draft-pr`; leave `branch-only` / `report-only` / `doc-artifact` / `external-ticket-update` on their own adapters); record status; append to `prs` if `draft-pr`; else record in item `notes` ([state-schema.md](./state-schema.md)). Update `consecutiveBlocked` (increment on blocked/skipped; reset on `done`). **Idempotency:** if a covering draft PR / outcome already exists for the item, do not open a second.
6. If `runsPath` set, write run evidence ([run-artifacts.md](./run-artifacts.md)).
7. End of tick: if `babysitCi: true` and a PR opened, poll `gh pr checks` once ([guardrails.md](./guardrails.md) CI babysit). On red → block item; if `stopOnCiRed` → stop loop.
8. Stop if `consecutiveBlocked >= maxConsecutiveBlocked` or other [guardrails](./guardrails.md); persist coarse `stopReason` + `stopDetail`; on stop write [morning-brief.md](./morning-brief.md).

## Cursor Automation

Cursor Automations (cloud scheduled agents) are a **first-class** runner — same skill + Sources bootstrap as `/after-hours`. Prefer this when office hours close and the IDE is offline. Full guide: [docs/automation.md](https://github.com/jjheffernan/heff-skills/blob/main/docs/automation.md). Paste-ready Instructions: [templates/automation-instructions.office-hours.close.txt](../templates/automation-instructions.office-hours.close.txt).

### Setup (minimal)

1. Commit skill + `.cursor/after-hours-loop.config.json` on the **target** repo (config is required in cloud; gitignored local-only config will not load).
2. Create Automation: **cron** weekdays after office close (example `0 18 * * 1-5` — confirm display time in the editor).
3. Repo / branch = project `baseBranch`.
4. Paste Instructions template; set Sources + `maxPrs` (prefer **1–2** per fire overnight).

### Behavior

- One cron fire = one agent session. No in-session `sleep` sentinel — the next fire is the next FOR iteration.
- Checkout `baseBranch` before work. Prefer Sources that **re-query** (`github-issues`).
- **Persistence:** gitignored `.cursor/after-hours-loop.state.json` is usually **missing** on the next cloud fire. Do not assume local state across nights. Idempotency: skip items that already have an open covering draft PR; when config `cloudLedgerPath` is set, also read/write the tracked ledger ([cloud-ledger.md](./cloud-ledger.md)). Record outcomes in the run’s morning-brief message (and PR links).
- Cloud: `github-issues` may refresh via `gh`; static Sources stay bootstrap-only unless files are in the checkout.
- Soft-detect peers; never grill / HITL overnight; fail closed on preflight / unrecovered dirty tree / denylist. Same interrupt/orphan rules when a cloud session is aborted mid-fire (next fire recovers).

### In-session vs Automation

| | `/after-hours` + sentinel | Automation cron |
|--|---------------------------|-----------------|
| Tick advance | Local shell `AGENT_LOOP_TICK_AFTERHOURS` | Next scheduled fire |
| State file | Durable for that machine night | Not durable across fires if gitignored |
| Cloud ledger (`cloudLedgerPath`) | Optional | Opt-in tracked JSON — see [cloud-ledger.md](./cloud-ledger.md) |
| Best for | Watching / tuning in IDE | Unattended after office hours / long-idle reliability |
