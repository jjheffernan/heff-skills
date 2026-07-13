# after-hours / after-hours-loop

AFK overnight coding loop for Cursor: pluggable **work sources** + **executors** → **draft PRs**.

Part of [heff-skills](https://github.com/jjheffernan/heff-skills).

## Triggers

| Command | Role |
|---------|------|
| `/after-hours` | Primary — bootstrap, tick 0, arm sentinel |
| `/after-hours 30m` | Same with custom interval |
| `/loop …` + this skill | Equivalent when pointed here |
| Cursor Automation | Unattended cron ticks |

Stop: `stop after-hours` / `stop loop`.

## Install

From the heff-skills repo:

```bash
./scripts/install.sh /path/to/your/project --with-gitignore
```

Or see [INSTALL.md](https://github.com/jjheffernan/heff-skills/blob/main/INSTALL.md) in the heff-skills repo. Then copy and edit:

```bash
cp skills/after-hours-loop/templates/config.example.json \
  /path/to/your/project/.cursor/after-hours-loop.config.json
```

## Kickoff

```text
/after-hours 45m
Sources:
  - github-issues: label ready-for-agent limit 5
  - todo-md: section "Now"
maxPrs: 3
priority: github-first
```

Dry-run (queue only, no coding):

```text
/after-hours --dry-run
Sources:
  - github-issues: label ready-for-agent limit 5
```

## Layout (source of truth)

| Path | Use |
|------|-----|
| `SKILL.md` | Thin orchestrator |
| `references/` | Bootstrap, readiness, compatibility, guardrails, state, morning brief |
| `sources/` | Work source modules (incl. opt-in `wayfinder-afk`) |
| `executors/` | `pr-slice`, `feature-build`, `research-only` |
| `templates/` | Config, Sources, morning-brief, drop-in pointer |

Generated install tree: repo-root `drop-in/` (`./scripts/sync-drop-in.sh`).


## Optional peers

- [ponytail](https://github.com/DietrichGebert/ponytail) — minimal-diff discipline (soft)
- [mattpocock/skills](https://github.com/mattpocock/skills) — grill / wayfinder / triage for **agent-ready** work before AFK (soft)

Not bundled. Loop degrades cleanly without them.

## Not included

- Target-repo `TODO.md` / domain subagents
- Live session state (gitignored under `.cursor/`)

## Uninstall / residual state

1. Stop any armed sentinel (`stop after-hours` / kill matching loop PID).
2. Remove the skill: `rm -rf .agents/skills/after-hours-loop`
3. Optionally delete session artifacts: `.cursor/after-hours-loop.state.json`, `.cursor/after-hours-morning-brief.md`, and config if unused.
4. Drop gitignore lines added solely for those files.

Full matrix: [INSTALL.md](https://github.com/jjheffernan/heff-skills/blob/main/INSTALL.md).
