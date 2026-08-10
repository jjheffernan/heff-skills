---
name: after-hours-prep
description: >
  Daytime HITL companion for after-hours-loop: grill-style questions to thicken
  an agent-ready overnight queue and paste-ready Sources before arming.
  Trigger when the user runs /after-hours-prep, asks to prep overnight work,
  build a night queue, or fill fog before AFK — never overnight / Automation.
disable-model-invocation: true
license: MIT
---

# after-hours-prep (companion)

Daytime **queue builder** for **after-hours-loop**. Ask questions until the night has enough agent-ready work. **Never** arm the sentinel or start coding ticks.

## When to use

- User: `/after-hours-prep`, “prep overnight”, “thicken the after-hours queue”, “grill the night plan”
- After `/after-hours` preflight fails on thin ready depth (`minReadyItems`)
- Before first `/after-hours --dry-run` on a new target

## Path notes

| Layout | Base |
|--------|------|
| Repo SoT (sibling) | `../after-hours-loop/` |
| Installed project | `.agents/skills/after-hours-loop/` (or `.agents/skills/after-hours/`) |

Readiness / Sources vocabulary: `references/readiness.md`, `references/bootstrap.md`, `templates/Sources.example.txt`.

## Procedure

1. **Scan** — Load config if present; detect trackers (TODO Now, GH `ready-for-agent`, feature specs). Soft-detect Matt peers (`CONTEXT.md`, ADRs, wayfinder maps, tickets) when present — prefer them as inputs; **do not** require grill→tickets.
2. **Classify** — Split work into:
   - **Agent-ready** — clear acceptance / verification
   - **Fog** — inventable scope, missing criteria, product decisions
   - **Blocked / HITL** — needs-grill, prototype, human-only
3. **Grill rounds (HITL)** — Build a small design/queue tree. Each round:
   - Ask the whole **frontier** (every open decision whose prerequisites are settled)
   - Number questions; give a **recommended answer** for each
   - **Wait** for the human — do not answer your own questions
   - Facts → tools/subagents; product decisions → always the user
4. **Stop grilling when** — Frontier empty **and** user confirms shared understanding. Do not invent acceptance.
5. **Materialize** — With user approval: update TODO Now / suggest GH labels / write acceptance lines; print a **paste-ready Sources block** + suggested `maxPrs` (and `minReadyItems` if useful).
6. **Exit** — Report ready count, blocked leftovers, and: “next: `/after-hours --dry-run`” then human-armed `/after-hours`. **Do not** start `/after-hours` yourself.

## Question format (per round)

```text
Frontier (round N):
1. ❓ <decision>
   → Recommended: <answer>
2. ❓ <decision>
   → Recommended: <answer>
```

Wait for replies before the next round.

## Refuse

- Automation / overnight / sentinel arm
- Inventing tickets or acceptance without user confirm
- Resolving wayfinder `grilling` / `prototype` for an absent human
- Mid-run edits to after-hours skill source “to keep going”

## Out of scope

- Killing sentinels (**after-hours-stop**) or morning briefs (**after-hours-handoff**)
- Always-on hooks — user-invoked only (`disable-model-invocation: true`)
