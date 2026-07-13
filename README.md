# heff-skills

Portable Cursor agent skills. Headline skill: **after-hours-loop** — AFK overnight coding that picks agent-ready work, opens draft PRs, and leaves a morning brief.

## 30-second install

```bash
# From a clone of this repo
./scripts/install.sh /path/to/your/project
```

Details, adapters, and uninstall: **[INSTALL.md](./INSTALL.md)**.

When this repo uses a top-level `skills/` layout (skills registry–compatible):

```bash
npx skills add jjheffernan/heff-skills -a cursor
```

## Skills

| Skill | Path | What it does |
|-------|------|--------------|
| **after-hours-loop** | [`skills/after-hours-loop/`](./skills/after-hours-loop/) | Overnight / AFK loop: sources → queue → executors → draft PRs + morning brief |

## Kickoff

Primary:

```text
/after-hours
```

Also supported:

```text
/loop 45m Follow .agents/skills/after-hours-loop/SKILL.md
```

(Optional: paste Sources, `maxPrs`, and priority in the same message.)

## Docs

| Doc | Purpose |
|-----|---------|
| [INSTALL.md](./INSTALL.md) | Cursor-first install paths, project adapter, uninstall |
| [SECURITY.md](./SECURITY.md) | Trust surface: local files only, no telemetry |
| [plan.md](./plan.md) | Living improvement plan and phased roadmap |
| [docs/composition.md](./docs/composition.md) | Where AHL sits vs Matt main flow (AFK phase) |
| [docs/portability.md](./docs/portability.md) | Host support for v1 |

## License

[MIT](./LICENSE) — Copyright (c) 2026 jjheffernan (Heff)
