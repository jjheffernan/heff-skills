# First overnight checklist

Ship one unattended run with agent-ready work already labeled. Alignment (grill / wayfinder / tickets) happens while you are present — not overnight.

## 1. Install

Use either path:

- Skills CLI: `npx skills add jjheffernan/heff-skills -a cursor`
- Clone + script: see [INSTALL.md](https://github.com/jjheffernan/heff-skills/blob/main/INSTALL.md)

Skill overview: [after-hours-loop README](https://github.com/jjheffernan/heff-skills/blob/main/skills/after-hours-loop/README.md).

## 2. Config

Copy and edit project config (at least `repo`, `baseBranch`, `testCommand`, `packageManager`):

```bash
cp skills/after-hours-loop/templates/config.example.json \
  TARGET_REPO/.cursor/after-hours-loop.config.json
```

Confirm `gh` auth. Prefer a clean working tree before arming.

## 3. Dry-run

Queue only — no state write, no coding:

```text
/after-hours --dry-run
Sources:
  - github-issues: label ready-for-agent limit 5
```

Night presets (paste-ready):

- [night-Sources.github.txt](https://github.com/jjheffernan/heff-skills/blob/main/skills/after-hours-loop/templates/night-Sources.github.txt) — GitHub-first
- [night-Sources.mixed.txt](https://github.com/jjheffernan/heff-skills/blob/main/skills/after-hours-loop/templates/night-Sources.mixed.txt) — GitHub + TODO (+ optional wayfinder-afk)
- Canonical day example: [Sources.example.txt](https://github.com/jjheffernan/heff-skills/blob/main/skills/after-hours-loop/templates/Sources.example.txt)

## 4. Arm

When the dry-run queue looks right:

```text
/after-hours 45m
```

(Or paste a full Sources block from a night template in the same message / Automation Instructions.)

## 5. Morning brief

Default path: `.cursor/after-hours-morning-brief.md`

Review draft PRs listed there before merge.

## 6. Stop phrases

Any of:

- `stop after-hours`
- `stop loop`
- `/after-hours stop`
