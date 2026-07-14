# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Per-item `verification[]` + `risk`; `/after-hours doctor`; morning Built / Needs daylight / Verify-failed triad; optional `runsPath` evidence ([run-artifacts.md](./skills/after-hours-loop/references/run-artifacts.md))
- Expanded validate-state fixtures (valid-stopped / valid-todo-first; invalid priority / version / missing baseBranch); CI loops all `valid*` / `invalid*`
- `validate-state.py` enforces `priority` enum (`github-first` \| `fifo` \| `todo-first`)

### Changed

- Post-MVP operating mode in [plan.md](./plan.md): stop numbered phases; multi-level backlog; Phase 5 abstraction seal noted as temporary
- Documented **parallel ship pattern** (levels × vertical slices × swarm/audit/janitor × fixtures) in plan §7 + AGENTS.md
- [docs/first-night.md](./docs/first-night.md) — dry-run called out as MVP checkpoint
- Adapted structural ideas from peer loop-factory (verification / doctor / evidence) into after-hours — no copied skill text
- Removed interim loop-factory audit doc after patterns were incorporated

Phase 5 abstraction + Phase 6 outcomes depth / harness / companions.

### Added

- [`references/outcomes.md`](./skills/after-hours-loop/references/outcomes.md) — outcome adapters: live `draft-pr`, `doc-artifact`, `branch-only`, `report-only`, `external-ticket-update`
- [`executors/docs-digest.md`](./skills/after-hours-loop/executors/docs-digest.md) — non-code digest → `doc-artifact`
- [`executors/ops-checklist.md`](./skills/after-hours-loop/executors/ops-checklist.md) — triage/ops beyond-code → default `report-only`
- Domain-agnostic `stopReason` / `stopDetail` on state (plus morning-brief stop line)
- [`references/cloud-ledger.md`](./skills/after-hours-loop/references/cloud-ledger.md) — optional durable Automation ledger (`cloudLedgerPath`)
- [`docs/smoke-matrix.md`](./docs/smoke-matrix.md) — Matt present / absent / mixed Sources smoke rows
- Validate-state fixtures: invalid `status`, `stopReason`, `megaPr` (+ CI coverage)
- [`references/mega-pr.md`](./skills/after-hours-loop/references/mega-pr.md) — **unsafe** bundled mega-PR; dual-token every arm (never sticky via config)
- Opt-in companions: [`after-hours-stop`](./skills/after-hours-stop/), [`after-hours-handoff`](./skills/after-hours-handoff/) — `./scripts/install.sh --with-companions` (out of drop-in)

### Changed

- Architecture / automation docs aligned with outcome adapters (not PR-only A→Z)
- `install.sh` accepts `--with-companions` for sibling stop/handoff skills
- `VERSION` → `0.1.0-alpha.2`

## [0.1.0-alpha.1] — 2026-07-13

First **alpha** packaging of **heff-skills** / **after-hours-loop**. Not a release — dogfood before tagging `v0.1.0`.

### Changed

- Mark skill + docs as **alpha** (`VERSION` = `0.1.0-alpha.1`)
- Positioning: workflow-agnostic AFK (any tracker → A→Z); Matt skills are optional peers ([plan.md](./plan.md) Phase 5, [docs/composition.md](./docs/composition.md))

### Added

- CI smoke: valid/invalid `validate-state` fixtures (`.github/workflows/ci.yml`)
- Mature root `.gitignore`; target [`templates/gitignore.snippet`](./skills/after-hours-loop/templates/gitignore.snippet)
- [docs/first-night-scorecard.md](./docs/first-night-scorecard.md) for continuous improvement
- [docs/automation.md](./docs/automation.md) + [`automation-instructions.office-hours.close.txt`](./skills/after-hours-loop/templates/automation-instructions.office-hours.close.txt) for Cursor Automations after office hours
- Cloud Automation persistence / idempotency notes in tick-and-runners + state-schema

### Packaging (phases 1–4 carried in)

- Cursor-first layout: `skills/after-hours-loop/`, generated `drop-in/`, install scripts
- References, sources (incl. opt-in wayfinder-afk / github-tickets), executors, validate-state, first-night guides

[Unreleased]: https://github.com/jjheffernan/heff-skills/compare/HEAD...HEAD
[0.1.0-alpha.2]: https://github.com/jjheffernan/heff-skills/blob/main/VERSION
[0.1.0-alpha.1]: https://github.com/jjheffernan/heff-skills/blob/main/VERSION

<!-- No git tag for alpha by default — tag only if you want a callable marker; stable release remains future `v0.1.0`. -->
