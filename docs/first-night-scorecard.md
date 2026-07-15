# First-night scorecard (continuous improvement)

Use this after **one** solo overnight (or a short armed AFK window) on a fresh target repo. Score honestly. Feed every fail/partial into [plan.md](../plan.md) Phase 5 / findings — do not only “fix and forget.”

**Target repo:** _______________  
**Date:** _______________  
**Install path:** `npx skills add` / `install.sh` / other  
**Runner:** `/after-hours` · `/loop` · Automation · other  
**Duration armed:** _______________  
**Sources used:** _______________

---

## Rubric (pass / partial / fail)

Score each row: **2** pass · **1** partial · **0** fail. Total **/26**. Recurring soft fails become plan tickets.

| # | Criterion | What “pass” looks like | Score | Notes / evidence |
|---|-----------|------------------------|-------|------------------|
| 1 | **Install friction** | Skill lands under `.agents/skills/after-hours-loop/` **or** `.agents/skills/after-hours/` (CLI name) in ≤5 min; docs match reality | | |
| 2 | **Config clarity** | Copied config; set `repo`, `baseBranch`, `testCommand`; no secret leakage into git | | |
| 3 | **Gitignore hygiene** | State + morning brief ignored (or `--with-gitignore`); nothing sensitive committed | | |
| 4 | **Preflight honesty** | Missing `gh` / dirty tree / bad config → clear stop or warning, not a half-run | | |
| 5 | **Dry-run fidelity** | `--dry-run` builds a sensible queue from Sources only; no code/PR/state writes | | |
| 6 | **Queue quality** | Only agent-ready items; vague/HITL work skipped or `blocked` with reason | | |
| 7 | **A→Z tick** | At least one item runs end-to-end for its executor (slice → verify → outcome) | | |
| 8 | **Safe outcomes** | Draft PRs when `draftPrs: true` (or configured outcome); no surprise merges/force-push | | |
| 9 | **Stop / budget** | `/after-hours Nm` is tick **interval** only; empty/`maxPrs` soft-park (sentinel kept); stop phrases end the night | | |
| 10 | **Morning brief** | Brief exists on stop; lists done / blocked / PRs / next human actions | | |
| 11 | **Resume / re-arm** | Second start does not duplicate `done` work; prior sentinels killed; state readable | | |
| 12 | **Workflow agnostic** | Worked from *your* Sources (issues/TODO/spec) **without** requiring Matt grill→tickets | | |
| 13 | **Interrupt recovery** | Mid-tick abort parks `interrupted`, keeps sentinel when tree recovers; does not drop to idle chat | | |

**Banding**

| Total | Verdict |
|------:|---------|
| 22–26 | Ship-worthy for personal AFK; file only polish notes |
| 15–21 | Usable with babysitting; every 0/1 → plan ticket |
| 0–14 | Not ready for unattended nights; fix blockers first |

---

## Continuous-improvement log (required)

For each **0** or **1**, write one line you will put in `plan.md` (or CHANGELOG Unreleased):

1. __________________________________________________
2. __________________________________________________
3. __________________________________________________

**Keep / kill / invent** (product decisions from the night):

| Signal | Decision |
|--------|----------|
| What felt essential | |
| What felt like noise / ceremony | |
| Missing source or executor | |
| One next experiment | |

---

## Minimal bar for “tonight succeeded”

You can call the night a win if **all** of these are true:

1. Install + config without editing skill source by hand.
2. Dry-run queue matched intent.
3. At least one real A→Z outcome (draft PR **or** intentional research/docs artifact).
4. Morning brief was useful without replaying the chat.
5. Nothing dangerous happened (no accidental publish of secrets, no non-draft merge, loop stopped cleanly).

Everything else is backlog for Phase 5 — capture it on this card.
