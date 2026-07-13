# Matt skill composition

after-hours-loop is the **downstream AFK build** step. Upstream alignment (wayfinder → grill → to-spec → to-tickets / triage) stays human/agent-interactive. We **detect and consume** their artifacts; we do not re-run grilling overnight.

## Soft vs hard deps (ADR-0001 style)

| Kind | Artifacts | Rule |
|------|-----------|------|
| **Soft** | `CONTEXT.md`, `docs/adr/*`, `docs/agents/issue-tracker.md`, ponytail / implement / tdd / code-review if installed | If present: soft-read or use. If absent: continue. Never rewrite CONTEXT/ADRs overnight. |
| **Hard** | Agent-ready work items in the queue | No agent-ready work → **stop** after preflight / empty-queue path. Do not invent tickets. |

Soft deps are context and discipline. Hard dep is a non-empty executable queue (unless `allowEmptyQueue` for dry-run/noop — see [bootstrap.md](./bootstrap.md)).

## Detect order (every bootstrap / refresh)

Run in order; later steps do not override earlier hard exclusions.

1. **`docs/agents/issue-tracker.md`** — if present, follow its claim / label / comment ops instead of inventing a second dialect.
2. **`ready-for-agent` + Agent Brief** — primary GitHub (or tracker) queue; prefer Brief over issue body.
3. **to-tickets frontier** — only when Sources enable a tickets / frontier source; consume ready frontier items with blockers closed ([readiness.md](./readiness.md) gate d).
4. **`wayfinder:map`** — only if Sources include **`wayfinder-afk`**. Then: research / AFK-typed map work only. Never open product PRs from grilling or prototype HITL map nodes.
5. **`CONTEXT.md` / `docs/adr/`** — soft-read; treat as constraints on implementable items.
6. **Native Sources** — `todo-md`, `feature-spec`, labeled `github-issues` as configured.

## Overnight bans

| Action | Allowed? |
|--------|----------|
| Re-grill / start grill-me / grill-with-docs | **No** |
| Resolve wayfinder grilling or prototype HITL tickets | **No** |
| Invent product decisions or new acceptance | **No** |
| Soft-read CONTEXT/ADRs; implement agent-ready tickets | **Yes** |
| Opt-in `wayfinder-afk` research-only work | **Yes** (no product PR unless executor allows) |

Mention blocked upstream fog in the [morning brief](./morning-brief.md) under Suggested next (grill / wayfinder tomorrow).

## Fallback when Matt skills absent

1. Queue only what Sources explicitly name (labels, TODO sections, spec paths).
2. Apply [readiness.md](./readiness.md): vague → `blocked` (`needs-info` / `needs-grill`), never invent scope.
3. Soft deps (ponytail etc.): skip; use executor-local steps in `executors/*.md`.
4. Morning brief still writes: “no grill artifacts detected” is fine; point humans at daytime alignment.
