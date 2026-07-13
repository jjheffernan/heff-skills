# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
[0.1.0-alpha.1]: https://github.com/jjheffernan/heff-skills/blob/main/VERSION

<!-- No git tag for alpha.1 by default — tag only if you want a callable marker; stable release remains future `v0.1.0`. -->
