# Guardrails & stop severity

Four severity levels. Use the lightest that still keeps overnight safe.

## Severity table

| Severity | Verb | Effect |
|----------|------|--------|
| **Skip item** | `skipped` | Leave item; pick next. No PR. Note in morning brief. |
| **Block item** | `blocked` | Same as skip for queue progress, but `blockReason` required (`needs-info`, `needs-grill`, `tests`, `hitl`, `ci-red`, …). Deferred ledger — must not vanish. |
| **Stop loop** | stop | Kill sentinel / do not re-arm; write morning brief; persist `stopReason`. |
| **Escalate** | stop + alert | Stop loop **and** surface hard safety (auth/secrets/denylist) first in Summary — human must act before next AFK. |

## Condition → severity map

| Condition | Severity | Notes |
|-----------|----------|-------|
| Vague acceptance; inventable scope | **Block item** | `needs-info` or `needs-grill`; never invent |
| HITL / product decision / design-only | **Block item** or **Skip item** | Prefer `blocked` + `hitl` |
| Wayfinder grilling / prototype HITL ticket | **Skip item** | Do not resolve overnight |
| Tests fail after one fix attempt | **Block item** | `tests` |
| Empty queue (no agent-ready work) | **Stop loop** | Unless dry-run noop |
| `prs.length >= maxPrs` | **Stop loop** | Budget hit |
| User: stop after-hours / stop loop | **Stop loop** | Kill sentinel PID |
| Dirty working tree at tick start and `safety.stopOnDirtyTree` | **Stop loop** | Fail-closed; do not start coding |
| Staged/changed path matches `safety.pathDenylist` | **Escalate** | Before commit/push; never open PR |
| Auth / webhook / guard **weakening** and `safety.stopOnAuthWeakening` | **Escalate** | Hard safety |
| `consecutiveBlocked >= maxConsecutiveBlocked` | **Stop loop** | Default threshold `3`; `stopReason: consecutive-blocked` |
| PR checks red after open and `babysitCi: true` | **Block item** | `ci-red`; note in item + brief |
| PR checks red and `stopOnCiRed: true` | **Stop loop** | After block note; `stopReason: ci-red` |
| `gh` auth missing when Sources need GitHub | **Stop loop** | Preflight fail-closed |
| Preflight fail (base branch, state unwritable, empty Sources without allow) | **Stop loop** | `stopReason: preflight` |

## Dirty tree (fail-closed)

If `safety.stopOnDirtyTree` is true (default in example config):

1. At **tick start**, before claim/coding: `git status --porcelain`.
2. Non-empty → **Stop loop** immediately; do not stash, commit residual, or pick work.
3. Morning brief: residual risk = unclean tree; human must clean before next AFK.

No exceptions overnight. Fail closed.

## Auth

- Require `gh auth status` success when any source uses GitHub.
- Never embed tokens in state, brief, or PR bodies.
- Auth failure mid-run → **Stop loop** (escalate if token exposure suspected).

## Path denylist (before commit / push / PR)

Respect `safety.pathDenylist` (globs). Enforcement is **before** `git commit`, `git push`, or `gh pr create`:

1. Collect staged and unstaged changed paths (`git diff --name-only`, `git diff --cached --name-only`, plus untracked if about to add).
2. If **any** path matches a denylist glob → **Escalate**: revert/unstage those paths if safe; **do not commit, push, or open a PR**; stop loop; `stopReason: guardrail` (denylist). Lead morning Summary with the matched paths.
3. Planned edit that would touch denylist → same escalate; do not start that edit path.

Never open a PR that includes denylisted files.

## Consecutive blocked → stop loop

Track `consecutiveBlocked` in state ([state-schema.md](./state-schema.md)).

| Event | Counter |
|-------|---------|
| Item ends `blocked` or `skipped` | Increment by 1 |
| Item ends `done` | Reset to `0` |
| Loop start / bootstrap | Start at `0` |

When `consecutiveBlocked >= maxConsecutiveBlocked` (config; **default 3**):

1. **Stop loop** — kill sentinel; do not pick another item.
2. Persist `stopReason: consecutive-blocked`.
3. Write morning brief (Blocked/Skipped sections must list the streak).

Do not silently re-try the same blocked id forever in one night without new agent-ready evidence.

## CI babysit (optional, after opening a PR)

Defaults: `babysitCi: false`, `stopOnCiRed: false`.

When `babysitCi: true` and a PR was just opened this tick:

1. Poll once: `gh pr checks <pr-number-or-url>` (short wait only; do not sit all night).
2. If checks are **red** / failed:
   - Mark the work item **blocked** (`blockReason: ci-red`); set `notes` with failing check names if known.
   - If `stopOnCiRed: true` → **also Stop loop** (`stopReason: ci-red`) + morning brief.
   - If `stopOnCiRed: false` → continue queue (blocked item stays in deferred ledger).
3. Pending/yellow after one poll → leave item `done` (PR opened); note “checks not green yet” in brief if useful. Do not stop solely for pending.

When `babysitCi: false` (default): do not poll; PR stays as opened; morning human reviews CI.

## Deferred ledger

All `blocked` / `skipped` items must appear in the morning brief Blocked/Skipped sections.
