# Morning brief

Durable handoff for the human after a stop. Write **on every stop** (empty queue, maxPrs, guardrail, user stop).

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
**Stop reason:** <empty-queue | maxPrs | guardrail | user-stop | consecutive-blocked | ci-red | preflight | dry-run>

## Summary

<2–4 sentences: what ran, what shipped as drafts, what needs a human>

## PRs opened

- <title> — <url> (draft)
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
- Review: <which PR to look at first>

## Artifacts

- State: `.cursor/after-hours-loop.state.json` (or configured `statePath`)
- Config: `.cursor/after-hours-loop.config.json` (if used)
```

## Writing rules

1. **Pointers > dumps** — PR URLs, issue links, file paths, item IDs. No pasted secret material, `.env` bodies, tokens, or full logs.
2. **Redact** — replace credentials with `<redacted>`; mention path only if relevant to residual risk.
3. **Every stop** — overwrite or update the brief file even if no PRs opened (empty night still useful).
4. **Blocked must be actionable** — each blocked row needs *why* + *what the human must do*.
5. **Suggested next** — prefer daytime: grill, wayfinder, Agent Brief, label `ready-for-agent`. Do not pretend AFK will fix fog.
6. Keep Summary short; put detail in Done / Blocked / Residual risk.
