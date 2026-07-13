# Smoke matrix — Matt artifacts vs Sources

Same orchestrator path in every row: load skill → preflight → Sources → readiness → tick → morning brief. Peer artifacts never invent Sources or require grill→tickets.

| Matt artifacts | Night Sources | Expected |
|----------------|---------------|----------|
| **Absent** (no CONTEXT / ADRs / issue-tracker / map) | Default (`github-issues` and/or `todo-md`) | Bootstrap; queue only named Sources; soft-detect noop |
| **Present** (CONTEXT / ADRs / tracker / map open) | Default (Matt sources **not** named) | Soft-read constraints; **ignore** map for build; no grill / no frontier auto-drain |
| **Present** | Mixed + **opt-in** `wayfinder-afk` and/or `github-tickets` | Same path; only those Sources enqueue AFK-safe / frontier items |
| **Mixed** (some peers installed, Sources omit them) | Default night templates | Identical to “present + default Sources” — opt-in lines stay commented |

**Refuse:** any design that blocks `/after-hours` until grill / to-tickets has run. Ready work from *any* tracker is enough.

Related: [compatibility](../skills/after-hours-loop/references/compatibility.md) · [automation.md](./automation.md) · night templates under `skills/after-hours-loop/templates/`.
