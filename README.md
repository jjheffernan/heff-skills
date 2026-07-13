# heff-skills

Portable Cursor agent skills. Headline skill: **after-hours-loop** — a **workflow-agnostic AFK loop**. Point it at any agent-ready tracker, walk away; it runs A→Z work (code draft PRs today; more domains next), stops safely, and leaves a morning brief.

## 30-second install

Primary (skills registry / published package once available, including after tag `v0.1.0`):

```bash
npx skills add jjheffernan/heff-skills -a cursor
```

Alternative from a clone of this repo:

```bash
./scripts/install.sh /path/to/your/project
```

Details, adapters, and uninstall: **[INSTALL.md](./INSTALL.md)**. Version: [`VERSION`](./VERSION) · [`CHANGELOG.md`](./CHANGELOG.md).

## Skills

| Skill | Path | What it does |
|-------|------|--------------|
| **after-hours-loop** | [`skills/after-hours-loop/`](./skills/after-hours-loop/) | AFK orchestrator: any Sources → queue → executors → outcomes + morning brief |

## Kickoff

First overnight: **[docs/first-night.md](./docs/first-night.md)** (install → config → dry-run → arm → morning brief).

Primary:

```text
/after-hours
```

Dry-run (queue only):

```text
/after-hours --dry-run
```

Also supported:

```text
/loop 45m Follow .agents/skills/after-hours-loop/SKILL.md
```

Paste Sources / `maxPrs` / priority in the same message when needed. Night presets:

- [`templates/night-Sources.github.txt`](./skills/after-hours-loop/templates/night-Sources.github.txt)
- [`templates/night-Sources.mixed.txt`](./skills/after-hours-loop/templates/night-Sources.mixed.txt)
- Canonical: [`templates/Sources.example.txt`](./skills/after-hours-loop/templates/Sources.example.txt)

## Next improvements

See living **[plan.md](./plan.md)** (Phase 5). Short list:

1. **Workflow-agnostic core** — queue/outcome contracts not tied to grill→tickets or PRs.
2. **Matt as optional peer** — detect/consume when present; never require that chain to start.
3. **Beyond code** — first non-PR executor (e.g. research/docs digest) while keeping the same AFK shell.
4. **Release** — tag `v0.1.0` once smoke CI is green on remote; expand fixtures.

## Docs

| Doc | Purpose |
|-----|---------|
| [INSTALL.md](./INSTALL.md) | Cursor-first install paths, project adapter, uninstall |
| [docs/first-night.md](./docs/first-night.md) | First overnight checklist |
| [SECURITY.md](./SECURITY.md) | Trust surface: local files only, no telemetry |
| [plan.md](./plan.md) | Living improvement plan and phased roadmap |
| [docs/composition.md](./docs/composition.md) | AFK loop vs optional peer workflows (incl. Matt) |
| [docs/architecture.md](./docs/architecture.md) | SoT layout, runners, sync rule |
| [docs/portability.md](./docs/portability.md) | Host support for v1 |

## License

[MIT](./LICENSE) — Copyright (c) 2026 jjheffernan (Heff)
