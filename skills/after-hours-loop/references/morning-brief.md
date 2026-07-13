# Morning brief

Durable handoff for the human after a stop. Write **on every stop** (`noop` / `budget` / `blocked` / `done` — any stop path).

## Path

| Source | Path |
|--------|------|
| Config `morningBriefPath` | Use that value |
| Default | `.cursor/after-hours-morning-brief.md` |

Copyable body: [templates/morning-brief.md](../templates/morning-brief.md).

## Template

```markdown
# After-hours morning brief

**Run:** <startedAt ISO> → <stoppedAt ISO>
**Repo:** <owner/name> · **Base:** <baseBranch>
**Stop reason:** <done | blocked | noop | budget> · **Detail:** <empty-queue | maxPrs | guardrail | user-stop | consecutive-blocked | ci-red | preflight | dry-run | …>

## Summary

<2–4 sentences: what ran, what shipped (drafts and/or doc artifacts), what needs a human>

<!-- If state.megaPr: lead with: **MEGA-PR MODE** — human opted in this run via CONFIRM_MEGA_PR. Bundled draft — review carefully. -->

## PRs opened

- <title> — <url> (draft)
- … or _None_

## Doc / non-PR outcomes

- `<id>` — `doc-artifact:` <path>
- `<id>` — `branch-only:` `after-hours/…`
- `<id>` — `report-only:` <one-line findings>
- `<id>` — `external-ticket-update:` <comment url or id>
- … or _None_

## Done

- `<id>` — <one-line outcome>
- … or _None_

## Blocked

- `<id>` — **why:** <needs-info | needs-grill | tests | …> · **human must:** <concrete next step>
- … or _None_

## Skipped

- `<id>` — <why>
- … or _None_

## Residual risk

- <manual checks, flaky tests, partial migrations, review focus>
- … or _None known_

## Suggested next

- Grill / wayfinder: <what alignment to do tomorrow, if any>
- Ready queue: <what to label / brief before next AFK>
- Review: <which PR or digest to look at first>

## Artifacts

- State: `.cursor/after-hours-loop.state.json` (or configured `statePath`)
- Config: `.cursor/after-hours-loop.config.json` (if used)
```

## Writing rules

1. **Pointers > dumps** — PR URLs, issue links, file paths, item IDs. No pasted secret material, `.env` bodies, tokens, or full logs.
2. **Redact** — replace credentials with `<redacted>`; mention path only if relevant to residual risk.
3. **Every stop** — overwrite or update the brief file even if no PRs opened (empty night / doc-only night still useful).
4. **Blocked must be actionable** — each blocked row needs *why* + *what the human must do*.
5. **Suggested next** — prefer daytime: grill, wayfinder, Agent Brief, label `ready-for-agent`. Do not pretend AFK will fix fog.
6. Keep Summary short; put detail in Done / Blocked / Residual risk.
7. **Stop line** — show coarse `stopReason`; include `stopDetail` when set ([state-schema.md](./state-schema.md)).
8. **Mega-PR** — if state `megaPr: true`, lead Summary with the MEGA-PR MODE banner ([mega-pr.md](./mega-pr.md)) and list every bundled item.