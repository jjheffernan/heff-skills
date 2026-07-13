# Agent-ready checklist

Before coding an item, decide: **agent-ready** or not. Overnight must not invent product scope.

## Agent-ready (ANY one is enough)

| Gate | How to detect |
|------|----------------|
| **(a) Label** | Issue (or tracker row) has `ready-for-agent` (or config-equivalent label). |
| **(b) Agent Brief** | Issue comment or attached brief titled/marked **Agent Brief** with do / don't / acceptance. Prefer Brief over raw body. |
| **(c) Explicit acceptance** | TODO checkbox or feature-spec section lists testable acceptance criteria. |
| **(d) Frontier ticket** | Item comes from a to-tickets / GitHub-deps frontier **and** open blockers on that ticket are closed. |

If none apply → do **not** execute.

## Not ready → `blocked`

| Field | Value |
|-------|--------|
| `status` | `blocked` |
| `blockReason` | `needs-info` or `needs-grill` |

- **`needs-info`** — missing acceptance, unclear files/API, env/secret unknown, conflict with CONTEXT/ADRs.
- **`needs-grill`** — alignment unfinished; product choices still open; brief is foggy.

Record reason on the item and in the morning brief. **Never invent requirements overnight.**

## HITL-shaped work — skip / block

Treat as not AFK-safe (mark `blocked` or `skipped`; do not start a product PR):

- Explicit product / design decision for a human
- Design-only or exploratory UI without acceptance
- Ambiguous one-liner brief with no criteria
- Wayfinder grilling / prototype HITL tickets (see [compatibility.md](./compatibility.md))
- Labels like `ready-for-human`, `needs-info`, `blocked` (unless the human already resolved them and left agent-ready evidence)

## Claim semantics

1. Before coding, set the item `status` to **`in-progress`** in state JSON (`statePath`).
2. Persist claim before branch creation or file edits.
3. One claimed item at a time per loop run (unless umbrella parent with children — parent stays `open`; only the active child is `in-progress`).
4. On stop mid-item: leave `in-progress` (resume next tick) or demote to `open` if you cannot safely continue — note residual risk in the morning brief.

See [state-schema.md](./state-schema.md).
