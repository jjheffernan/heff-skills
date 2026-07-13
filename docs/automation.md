# Automations — after-hours when office hours close

**after-hours** is meant to run unattended via **Cursor Automations** (scheduled agents), not only `/after-hours` or `/loop` in an open IDE session.

Status: **alpha** — get several real nights under this path before cutting a release tag.

## What “office hours close” means

Use a **cron** trigger on weekdays after your workday ends (example: `0 18 * * 1-5` for 18:00 weekdays). Pick the hour that matches how Automations displays time in your UI; confirm once in the editor.

One cron fire = one agent run. Prefer **1–2 work items** (`maxPrs: 1` or `2`) per fire unless you intentionally raise the budget.

## Prerequisites (target repo)

| Need | Why |
|------|-----|
| Skill installed under `.agents/skills/after-hours-loop/` | Cloud agent loads the same path as local |
| **Committed** `.cursor/after-hours-loop.config.json` (from `templates/config.example.json`) | Cloud checkouts do not see local-only config |
| `repo`, `baseBranch`, `testCommand`, `draftPrs: true` set | Preflight fail-closed otherwise |
| GitHub auth available to Cloud Agents / `gh` | Issues + outcome adapters that need `gh` (e.g. `draft-pr`) |

| Cursor Cloud Agents enabled for the account/repo | Dashboard: Cloud Agents |
| Sources that re-query (prefer `github-issues`) | Fresh queue every night without local chat |

Session state defaults (`.cursor/after-hours-loop.state.json`, morning brief) stay **gitignored**. Do not rely on them across cloud fires — see persistence below. Optional **durable ledger** via config `cloudLedgerPath` (default `null`) — see [cloud-ledger.md](../skills/after-hours-loop/references/cloud-ledger.md).

## Persistence model (critical)

| Runner | State file | Cross-tick memory |
|--------|------------|-------------------|
| `/after-hours` + in-session sentinel | Local `.cursor/…state.json` | Works for one night in one machine session |
| **Cursor Automation (cloud)** | Fresh checkout each cron | Gitignored state is **not** durable |

For Automations, treat each fire as **stateless bootstrap** unless `cloudLedgerPath` is set:

1. Re-read Sources (e.g. `github-issues: label ready-for-agent`).
2. **Skip** items already completed for this fire’s outcome: open after-hours draft PR for `draft-pr` (branch / PR title convention: prefer `after-hours/<id>-…` or PR body containing `itemId`); existing digest path / notes for `doc-artifact`.
3. If `cloudLedgerPath` is set: read/upsert the tracked JSON ledger across fires ([cloud-ledger.md](../skills/after-hours-loop/references/cloud-ledger.md)). Otherwise use outcome-adapter idempotency (PR for `draft-pr`; path/ledger for others).
4. Claim at most `maxPrs` items; run executor → **outcome adapter** (`draft-pr`, `doc-artifact`, …); write morning brief **into the agent run output** (and optionally a PR comment when a PR exists). Do not expect tomorrow’s cron to load last night’s gitignored `statePath`.

Default night Sources stay `github-issues` (see template). Keep `wayfinder-afk` / `github-tickets` opt-in only — [smoke-matrix.md](./smoke-matrix.md).

## Create the automation (manual)

In Cursor → Automations → new automation:

| Field | Value |
|-------|--------|
| **Name** | e.g. `after-hours — office close` |
| **Trigger** | Schedule → weekdays at end of office hours (custom cron) |
| **Repo / branch** | Target project; checkout **`baseBranch`** from config |
| **Tools** | Whatever the executor needs (`gh` / GitHub); Slack “fire started / morning summary” **deferred** (optional later) |
| **Instructions** | Paste [automation-instructions.office-hours.close.txt](../skills/after-hours-loop/templates/automation-instructions.office-hours.close.txt) and edit Sources |

Do **not** enable always-on project rules for overnight. Invocation must be this Automation (or an explicit slash).

Paste-ready Instructions live in the skill package so they ship with `npx skills add` / `install.sh`.

## Alpha trial checklist

Before relying on unattended nights:

1. [ ] One dry-run in IDE (`/after-hours --dry-run`) with the same Sources as Instructions.
2. [ ] One **manual** Automation run (or short cron) while you watch Cloud Agent output.
3. [ ] Confirm outcome adapter shipped as intended (`draft-pr` stays draft / no merge; `doc-artifact` path recorded); secrets not committed.
4. [ ] Confirm next day: same item not double-worked (idempotency via existing PR / digest path / ledger / labels).
5. [ ] Score in [first-night-scorecard.md](./first-night-scorecard.md); note Automation-specific fails in plan.md.

## Related

- [tick-and-runners.md](../skills/after-hours-loop/references/tick-and-runners.md) — cadences
- [cloud-ledger.md](../skills/after-hours-loop/references/cloud-ledger.md) — optional durable ledger
- [smoke-matrix.md](./smoke-matrix.md) — Matt present/absent/mixed
- [portability.md](./portability.md) — Cursor-only mechanisms
- [first-night.md](./first-night.md) — human-armed overnight
