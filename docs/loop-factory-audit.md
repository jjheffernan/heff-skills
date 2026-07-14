# Loop-factory audit (post-MVP)

Audited [JuliusBrussee/skills `loop-factory`](https://github.com/JuliusBrussee/skills/tree/main/skills/loop-factory) (+ [autonomous.md](https://github.com/JuliusBrussee/skills/blob/main/skills/loop-factory/references/autonomous.md)) against **after-hours-loop**. Structure only — do not copy skill text.

**Date:** 2026-07-13 · **Context:** Phase 2 noted this sibling and deferred; MVP is sealed — this is a living improvement input, not a new phase gate.

## Already strong on our side

| Loop-factory idea | After-hours coverage |
|-------------------|----------------------|
| Ready-only; never invent product | `readiness.md`, `guardrails.md` |
| Empty / unready → clean noop | `noop` / `empty-queue`, `allowEmptyQueue` |
| Batch / budget caps | `maxPrs`, source limits, `maxConsecutiveBlocked` |
| Local interval + cloud schedule | `/after-hours` + Automation (`tick-and-runners.md`) |
| Automate build, not decisions | No overnight grill; morning brief |
| Human still accepts “done” | Draft PRs / outcome adapters |
| Always report | Morning brief every stop |
| Preflight health | Bootstrap fail-closed |

Our Sources → state JSON → executors → outcomes spine is **better for AFK** than folder-as-state (`inbox`/`active`/`archive`).

## Steal structure (not content)

| Gap | Why it matters overnight |
|-----|--------------------------|
| Per-item `verification[]` | Repo-wide `testCommand` is weak; item-level prove-done |
| Per-tick run / evidence artifacts | Weak audit of what commands ran |
| Pass-report triad | Built / needs-daylight / verify-failed as first-class brief shape |
| Named `doctor` mode | Scan readiness without arming coding |
| Portable `risk` + anti–green-wash | Never weaken acceptance to force `done` |

## Do not steal

- Mid-loop human archive / `--accepted` as completion (we ship **draft** outcomes; morning = review)
- CLI-first `factory/` directories as SoT
- Interactive grill gate overnight
- Prompt-only dispatch without execute
- Autonomous backprop into living specs (use brief “Suggested next”)
- System crontab as primary (prefer Cursor Automation)

## Top tickets (multi-level backlog)

1. **Per-item verification** — `state-schema.md`, readiness, executors, github-issues / feature-spec sources  
2. **Run evidence** — optional `runsPath`, tick-and-runners, morning-brief Artifacts  
3. **Pass-report triad** — morning-brief template + `blockReason` mapping  
4. **`/after-hours doctor`** — SKILL + bootstrap (no state write, no coding)  
5. **`risk` + anti–green-wash** — state-schema + guardrails + executors  

Related: [plan.md](../plan.md) § Post-MVP · reopen abstraction later (Phase 5 seal was temporary).
