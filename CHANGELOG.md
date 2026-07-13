# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Positioning: after-hours is workflow-agnostic AFK (any tracker → A→Z); Matt skills are optional peers, not a parent grill→ticket flow ([plan.md](./plan.md) Phase 5, [docs/composition.md](./docs/composition.md))

### Added

- CI smoke: valid/invalid `validate-state` fixtures (`.github/workflows/ci.yml`)

## [0.1.0] — 2026-07-13

First packaged release of **heff-skills** with **after-hours-loop** as the headline skill.

### Packaging (Phase 1)

- Cursor-first repo layout: canonical skill under `skills/after-hours-loop/`, generated `drop-in/`
- Root `LICENSE` (MIT), `README.md`, `INSTALL.md`, `SECURITY.md`, `docs/portability.md`
- `scripts/install.sh` (copy + optional gitignore) and `scripts/sync-drop-in.sh`
- Portable `templates/config.example.json`; stripped absolute paths and mandatory peer-skill reads
- Frontmatter: `disable-model-invocation: true`; primary slash `/after-hours`

### Compatibility & startup (Phase 2)

- `references/` for readiness, compatibility (Matt / wayfinder / grill), bootstrap, guardrails, state schema, morning brief
- Preflight + dry-run (`/after-hours --dry-run`); morning brief always written on stop
- Soft deps; `sources/wayfinder-afk.md`, `executors/research-only.md`
- `docs/composition.md`; drop-in sync CI (`check-drop-in-sync.sh`)

### AFK loop completeness (Phase 3)

- Stop policy: consecutive-blocked, dirty-tree, CI-red cascade; post-open draft (`isDraft`) verification
- Self-contained executor safety checklists; resume mid-queue docs
- `scripts/validate-state.py` (schema v1; also skill-local copy)
- Runner notes for Automation vs `/loop` in `tick-and-runners.md`

### Polish & distribute (Phase 4)

- `docs/first-night.md`, night Sources templates, `docs/architecture.md`
- Opt-in `sources/github-tickets.md`; optional Cursor rule template (`cursor-rule.after-hours-loop.mdc.example`)
- Validate-state fixtures under `skills/after-hours-loop/fixtures/`
- Primary install documented as `npx skills add jjheffernan/heff-skills -a cursor`; `VERSION` / `CHANGELOG` for `0.1.0`
- Git tag `v0.1.0` cut at publish time (not auto-created in-repo)

[Unreleased]: https://github.com/jjheffernan/heff-skills/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/jjheffernan/heff-skills/releases/tag/v0.1.0
