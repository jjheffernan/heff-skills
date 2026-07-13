# State schema (version 1)

Persistent loop state at config `statePath`, default `.cursor/after-hours-loop.state.json`. Gitignore the file.

Optional check: `scripts/validate-state.py <statePath>` (exit 0 = ok).

## Top-level fields

| Field | Type | Required | Meaning |
|-------|------|----------|---------|
| `version` | `1` | yes | Schema version; bump only on breaking change |
| `startedAt` | ISO-8601 | yes | Loop run start |
| `stoppedAt` | ISO-8601 | no | Set on stop |
| `stopReason` | string | no | `empty-queue`, `maxPrs`, `guardrail`, `user-stop`, `consecutive-blocked`, `ci-red`, `preflight`, `dry-run` |
| `sources` | array | yes | Parsed Sources entries `{ type, config }` |
| `queue` | array | yes | Work items (see below) |
| `prs` | object[] | yes | PRs opened this run: `{ "url", "itemId", "branch", "draft" }` (`url` required; others when known). `maxPrs` counts `prs.length`. |
| `maxPrs` | number | yes | Cap from bootstrap / config |
| `tick` | number | yes | Completed tick count (0 after bootstrap before first completion is ok) |
| `priority` | string | yes | `github-first` \| `fifo` \| `todo-first` |
| `baseBranch` | string | yes | Target branch for PRs |
| `dryRun` | boolean | no | If true, this run must not write state (see dry-run) |
| `consecutiveBlocked` | number | no | Successive `blocked`/`skipped` without an intervening `done`; see counter rules below |

## Work item fields

| Field | Type | Notes |
|-------|------|-------|
| `id` | string | `{source}:{stable-key}` e.g. `github:52` |
| `title` | string | Short label |
| `source` | string | `github-issues`, `todo-md`, `feature-spec`, … |
| `executor` | string | `pr-slice`, `feature-build`, … |
| `ref` | string | URL or path |
| `acceptance` | string | Brief excerpt / criteria |
| `granularity` | string | `single-pr` \| `multi-slice` |
| `status` | string | `open` \| `in-progress` \| `done` \| `blocked` \| `skipped` |
| `blockReason` | string | optional: `needs-info`, `needs-grill`, `tests`, `hitl`, … |
| `parentId` | string | optional: umbrella parent for child slices |
| `notes` | string | optional: short residual note |

## `consecutiveBlocked` counter

| When | Action |
|------|--------|
| Bootstrap / new run | Set `consecutiveBlocked` to `0` |
| Item → `blocked` or `skipped` | Increment by 1; write state |
| Item → `done` | Reset to `0`; write state |
| After increment | If `consecutiveBlocked >= maxConsecutiveBlocked` (config; default `3`) → **stop loop**; `stopReason: consecutive-blocked`; morning brief ([guardrails.md](./guardrails.md)) |

Umbrella parents finishing as terminal without a child `done` this streak still count as blocked/skipped for the counter when that parent is marked blocked/skipped.

## Claim / in-progress

1. Claim = set `status` to `in-progress` and **write state** before coding.
2. Only one non-child item `in-progress` at a time (children: one active child).
3. On success: `done`; append `{ url, itemId, branch, draft }` to `prs` if a PR opened; clear claim; **reset `consecutiveBlocked` to `0`**.
4. On fail soft: `blocked` or `skipped` with `blockReason`; clear claim; **increment `consecutiveBlocked`** (then check stop threshold).
5. Never leave the working tree dirty *and* forget to persist status.

## Resume mid-queue

1. On tick start, load state if present and `startedAt` matches this armed run (or Automation continuing same night with same Sources intent).
2. Prefer resume: finish `in-progress` item first, then next `open` by priority.
3. Do not re-queue IDs already `done` / `blocked` / `skipped` this run unless Sources refresh proves the human re-opened agent-ready work **and** id was cleared — default: preserve outcomes.
4. Umbrella `multi-slice` parent stays `open` until all children are terminal (`done` / `blocked` / `skipped`).

## Dry-run does not write state

When `/after-hours --dry-run` or message `dryRun: true`:

- Build and print the queue (and readiness notes).
- Do **not** create or update `statePath`.
- Do **not** open PRs, edit product files, or arm a coding tick.
- Optional: print what `stopReason` would be (`dry-run`).

See [bootstrap.md](./bootstrap.md).
