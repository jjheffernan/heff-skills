# After-hours morning brief

**Run:** <startedAt ISO> → <stoppedAt ISO>
**Repo:** <owner/name> · **Base:** <baseBranch>
**Stop reason:** <done | blocked | noop | budget> · **Detail:** <empty-queue | maxPrs | guardrail | user-stop | consecutive-blocked | ci-red | preflight | dry-run | …>

## Summary

<!-- If megaPr: lead with MEGA-PR MODE banner — see references/mega-pr.md -->

<2–4 sentences: what ran, what shipped (drafts and/or doc artifacts), what needs a human>

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
