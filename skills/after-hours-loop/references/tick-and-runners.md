# Tick runners (`/after-hours`, `/loop`, Automation)

Loaded from the orchestrator when arming or continuing ticks — keep bash / cadence detail here so [SKILL.md](../SKILL.md) stays thin.

## In-session sentinel

After bootstrap + tick 0 (not dry-run):

```bash
while true; do
  sleep 2700
  echo 'AGENT_LOOP_TICK_AFTERHOURS {"prompt":"Continue after-hours tick per .agents/skills/after-hours-loop/SKILL.md"}'
done
```

- Check terminals for an existing matching loop before starting another.
- Start background shell with `notify_on_output` on `^AGENT_LOOP_TICK_AFTERHOURS`.
- Track PID for stop (`stop after-hours` / `stop loop`).
- Re-arm only if agent-ready `open` items remain and `maxPrs` not hit.
- Default interval **45m** (`2700`). `/after-hours 30m` or `/loop 30m` adjusts sleep.

## Each tick (summary)

1. Soft-detect peers ([compatibility.md](./compatibility.md)). Dirty-tree fail-closed at tick start ([guardrails.md](./guardrails.md)).
2. Refresh sources that support it.
3. Pick next `open` agent-ready item; claim ([readiness.md](./readiness.md), [state-schema.md](./state-schema.md)).
4. Run executor module (denylist before commit/push/PR).
5. Record outcome; append PR object to `prs` if any ([state-schema.md](./state-schema.md)). Update `consecutiveBlocked` (increment on blocked/skipped; reset on `done`).
6. End of tick: if `babysitCi: true` and a PR opened, poll `gh pr checks` once ([guardrails.md](./guardrails.md) CI babysit). On red → block item; if `stopOnCiRed` → stop loop.
7. Stop if `consecutiveBlocked >= maxConsecutiveBlocked` or other [guardrails](./guardrails.md); on stop write [morning-brief.md](./morning-brief.md).

## Cursor Automation

Cursor Automations (cloud scheduled agents) are a **first-class** runner — same skill + Sources bootstrap as `/after-hours`. Prefer this when office hours close and the IDE is offline. Full guide: [docs/automation.md](https://github.com/jjheffernan/heff-skills/blob/main/docs/automation.md). Paste-ready Instructions: [templates/automation-instructions.office-hours.close.txt](../templates/automation-instructions.office-hours.close.txt).

### Setup (minimal)

1. Commit skill + `.cursor/after-hours-loop.config.json` on the **target** repo (config is required in cloud; gitignored local-only config will not load).
2. Create Automation: **cron** weekdays after office close (example `0 18 * * 1-5` — confirm display time in the editor).
3. Repo / branch = project `baseBranch`.
4. Paste Instructions template; set Sources + `maxPrs` (prefer **1–2** per fire overnight).

### Behavior

- One cron fire = one agent session. No in-session `sleep` sentinel — the next fire is the next tick.
- Checkout `baseBranch` before work. Prefer Sources that **re-query** (`github-issues`).
- **Persistence:** gitignored `.cursor/after-hours-loop.state.json` is usually **missing** on the next cloud fire. Do not assume local state across nights. Idempotency: skip items that already have an open covering draft PR; record outcomes in the run’s morning-brief message (and PR links).
- Cloud: `github-issues` may refresh via `gh`; static Sources stay bootstrap-only unless files are in the checkout.
- Soft-detect peers; never grill / HITL overnight; fail closed on preflight / dirty tree / denylist.

### In-session vs Automation

| | `/after-hours` + sentinel | Automation cron |
|--|---------------------------|-----------------|
| Tick advance | Local shell `AGENT_LOOP_TICK_AFTERHOURS` | Next scheduled fire |
| State file | Durable for that machine night | Not durable across fires if gitignored |
| Best for | Watching / tuning in IDE | Unattended after office hours |