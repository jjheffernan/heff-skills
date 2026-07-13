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

- Checkout `baseBranch`.
- Sources from Instructions (same bootstrap syntax).
- Prefer **1–2 ticks** per cron fire overnight unless Instructions raise `maxPrs` / multi-item.
- Cloud: `github-issues` may refresh via `gh`; static sources stay bootstrap-only.
