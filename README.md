# heff-skills

Portable Cursor agent skills. Headline skill: **after-hours-loop** (**alpha**) — a **workflow-agnostic AFK loop**. Point it at any agent-ready tracker, walk away (IDE slash or **Cursor Automation** after office hours); it runs A→Z work, stops safely, and leaves a morning brief.

**Version:** [`VERSION`](./VERSION) = `0.1.0-alpha.2` (**MVP / alpha**). Phased buildout complete — next is dogfood + multi-level backlog in [`plan.md`](./plan.md). No release tag yet.

## 30-second install

```bash
npx skills add jjheffernan/heff-skills -a cursor
```

Alternative from a clone:

```bash
./scripts/install.sh /path/to/your/project
```

Details: **[INSTALL.md](./INSTALL.md)** · [`CHANGELOG.md`](./CHANGELOG.md).

## Skills

| Skill | Path | What it does |
|-------|------|--------------|
| **after-hours-loop** (alpha) | [`skills/after-hours-loop/`](./skills/after-hours-loop/) | AFK orchestrator: any Sources → queue → executors → outcomes + morning brief |
| **after-hours-stop** (opt-in) | [`skills/after-hours-stop/`](./skills/after-hours-stop/) | Kill sentinel / stop phrases / ensure morning brief — install via `--with-companions` |
| **after-hours-handoff** (opt-in) | [`skills/after-hours-handoff/`](./skills/after-hours-handoff/) | Morning-brief handoff after a stop — install via `--with-companions` |

## Kickoff

- Human / IDE: **[docs/first-night.md](./docs/first-night.md)**
- Scheduled (office close): **[docs/automation.md](./docs/automation.md)** + [`templates/automation-instructions.office-hours.close.txt`](./skills/after-hours-loop/templates/automation-instructions.office-hours.close.txt)
- Score runs: **[docs/first-night-scorecard.md](./docs/first-night-scorecard.md)**

Primary:

```text
/after-hours
```

Dry-run:

```text
/after-hours --dry-run
```

Also: `/loop 45m Follow .agents/skills/after-hours-loop/SKILL.md`

Night Sources presets: [`night-Sources.github.txt`](./skills/after-hours-loop/templates/night-Sources.github.txt), [`night-Sources.mixed.txt`](./skills/after-hours-loop/templates/night-Sources.mixed.txt), [`Sources.example.txt`](./skills/after-hours-loop/templates/Sources.example.txt).

## Next improvements

See **[plan.md](./plan.md)** post-MVP levels (not numbered phases). Near-term: dogfood dry-run → scorecard; L3 reopen abstraction when needed.

## Docs

| Doc | Purpose |
|-----|---------|
| [INSTALL.md](./INSTALL.md) | Cursor-first install paths, project adapter, uninstall |
| [docs/first-night.md](./docs/first-night.md) | First overnight checklist (dry-run first) |
| [docs/first-night-scorecard.md](./docs/first-night-scorecard.md) | Solo AFK rubric + continuous-improvement log |
| [docs/automation.md](./docs/automation.md) | Cursor Automations + office-hours-close setup |
| [SECURITY.md](./SECURITY.md) | Trust surface: local files only, no telemetry |
| [plan.md](./plan.md) | Living multi-level backlog (MVP sealed) |
| [docs/composition.md](./docs/composition.md) | AFK loop vs optional peer workflows (incl. Matt) |
| [docs/architecture.md](./docs/architecture.md) | SoT layout, runners, sync rule |
| [docs/portability.md](./docs/portability.md) | Host support for v1 |

## License

[MIT](./LICENSE) — Copyright (c) 2026 jjheffernan (Heff)
