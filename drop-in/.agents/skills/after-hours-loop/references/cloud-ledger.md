# Durable cloud ledger (MVP)

Optional tracked file so **Cursor Automation** fires share memory without relying on gitignored `statePath`.

## Config

| Key | Default | Meaning |
|-----|---------|---------|
| `cloudLedgerPath` | `null` (off) | Repo-relative path to a **committed** JSON ledger. When `null` / unset: do not write a ledger — use PR idempotency only. |

Recommended path when enabling: `.cursor/after-hours-ledger.json` (do **not** gitignore it; commit updates so the next cloud checkout sees them). Alternate prose form `docs/after-hours/ledger.md` is out of scope for this MVP — prefer JSON.

Example config snippet:

```json
"cloudLedgerPath": ".cursor/after-hours-ledger.json"
```

Leave `"cloudLedgerPath": null` in [config.example.json](../templates/config.example.json) unless the target repo opts in.

## When to write

| `cloudLedgerPath` | Behavior |
|-------------------|----------|
| `null` / unset | **PR idempotency only** — skip items already covered by an open after-hours draft PR (branch / title / body references `itemId`). No ledger I/O. |
| set to a path | After each durable outcome (`done`, `blocked`, `skipped` with lasting effect), **upsert** an entry and commit the ledger file on the working branch (or include it in the draft-PR branch) so the next Automation checkout can read it. |

Session `statePath` remains gitignored local memory. Ledger is cross-fire memory for Automations.

## Schema (v1)

Root object:

```json
{
  "version": 1,
  "entries": [
    {
      "itemId": "github:42",
      "status": "done",
      "prUrl": "https://github.com/owner/repo/pull/123",
      "at": "2026-07-13T22:15:00Z"
    }
  ]
}
```

| Field | Required | Notes |
|-------|----------|-------|
| `version` | yes | `1` |
| `entries` | yes | Array of entry objects |
| `itemId` | yes | Same id as queue / Sources (`github:N`, …) |
| `status` | yes | `done` \| `blocked` \| `skipped` \| `in-progress` |
| `prUrl` | no | When a draft PR exists |
| `at` | yes | ISO-8601 timestamp of last write for this item |

Upsert by `itemId` (replace prior entry). Do not delete history unless the human clears the file.

## Bootstrap / idempotency order (Automation)

1. Parse Sources; apply readiness.
2. If ledger path set and file exists: treat `done` / in-flight `in-progress` / recently covered `skipped` as already handled — **do not re-implement**.
3. Else (or in addition): skip items with an open covering draft PR.
4. Claim ≤ `maxPrs`; execute; outcome adapter; update ledger when configured; morning brief.

## Non-goals (MVP)

- Issue-label ledger (`after-hours-done`) — later adapter
- Slack notifications — deferred (plan §7.4)
- Replacing local `statePath` for in-session `/after-hours`

See also: [tick-and-runners.md](./tick-and-runners.md), repo [docs/automation.md](https://github.com/jjheffernan/heff-skills/blob/main/docs/automation.md).
