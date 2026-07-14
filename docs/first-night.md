# First overnight checklist

Ship one unattended run with agent-ready work already queued. Daytime alignment (whatever workflow you use) happens while you are present — not overnight.

**Refuse:** you do **not** need Matt grill / to-tickets (or any peer chain) before `/after-hours` can start. Opt-in Sources `wayfinder-afk` / `github-tickets` stay off unless you uncomment them — see [smoke-matrix.md](./smoke-matrix.md).

**MVP / alpha:** packaging and loop surface are dry-run ready. Score every run; phased rollout is over — feed gaps into [plan.md](../plan.md) post-MVP levels.

After the run, score it with **[first-night-scorecard.md](./first-night-scorecard.md)** and promote every partial/fail into the multi-level backlog in [plan.md](../plan.md).

For unattended **office-hours-close** scheduling (no IDE open), use **[automation.md](./automation.md)** instead of (or in addition to) arming `/after-hours` manually.

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

## 3. Dry-run (do this first)

**MVP checkpoint:** treat a successful dry-run as the gate before overnight or Automation.

Optional health scan (no Sources required): `/after-hours doctor`

Queue only — no state write, no coding:

```text
/after-hours --dry-run
Sources:
  - github-issues: label ready-for-agent limit 5
```

Confirm the printed queue matches intent (ready vs blocked reasons). If empty or wrong Sources, fix labels / acceptance before arming.

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

## 7. Score + improve

Fill [first-night-scorecard.md](./first-night-scorecard.md) in the morning. Minimal win: install → dry-run → one A→Z outcome → useful brief → clean stop.
