# Outcome adapters

Executors produce a **completion signal** (`done` / `blocked` / `skipped`) plus a requested **outcome adapter**. They do **not** “must open a PR” — PRs are one adapter among others.

**A→Z** = executor-defined completion for the item (acceptance satisfied) **plus** a successful (or intentional no-op) outcome adapter — not solely “opened a PR.” See [glossary](../docs/glossary.md).

Wire via queue field `outcomeKind` ([state-schema.md](./state-schema.md)). Sources or executor defaults may set it; bootstrap may leave it unset → executor default applies.

## Contract

| Step | Who | Responsibility |
|------|-----|----------------|
| 1. Execute | Executor (`executors/*.md`) | Complete A→Z work for the item; emit completion signal |
| 2. Publish | Outcome adapter (this doc) | Persist the shippable artifact (PR, branch, doc path, report, external update) |
| 3. Record | Orchestrator | Update item `status`; append adapter-specific records (`prs` for `draft-pr`, path in `notes` for `doc-artifact`, …) |

An item is **`done`** when the executor’s acceptance work is complete **and** the requested adapter succeeds (or is intentionally no-op). Adapter failure without a recoverable path → `blocked` with reason, not a silent skip.

## Adapters

| `outcomeKind` | Status | Meaning |
|---------------|--------|---------|
| `draft-pr` | **Live** (default for code) | Open a **draft** PR to `baseBranch` (respect `draftPrs`). Append `{ url, itemId, branch, draft }` to state `prs`. Counts toward `maxPrs`. |
| `doc-artifact` | **Live** (for `docs-digest`) | Write or update a durable in-repo doc/path; **no PR** unless Sources override to `draft-pr`. Record path in item `notes`. |
| `branch-only` | Stub | Push / leave an `after-hours/…` branch with commits; **no** PR. Record branch name in item `notes` (and future ledger). |
| `report-only` | Stub | Emit findings into the morning brief (and optional chat); no git publish. |
| `external-ticket-update` | Stub | Comment / status update on the origin tracker (issue, Linear, …); no PR required. |

### `draft-pr` (today)

Default for `pr-slice` and `feature-build`. Typical for `research-only` when shipping research markdown via PR.

**If state `megaPr: true`** (dual-token arm only — [mega-pr.md](./mega-pr.md)):

1. Use one shared branch `after-hours/mega-<date>` for the whole run.
2. Open **at most one** draft PR for the run; fold later items via commits + PR body checklist.
3. `maxPrs` caps **items bundled**, not separate PR count (`prs.length` is `0` or `1`).
4. Still confirm draft; still denylist / no force-push.

**Else (default sliced):**

1. Branch from `baseBranch` if not already on an after-hours branch.
2. Commit executor output; push remote branch.
3. `gh pr create` with `--draft` when `draftPrs: true` (default).
4. Confirm draft when required; append to `prs`.
5. Idempotency: skip opening a second PR if an open draft already covers the item id.

Safety / denylist / no-force-push rules in [guardrails.md](./guardrails.md) still apply before publish.

### `doc-artifact` (live for `docs-digest`)

Default for [`docs-digest`](../executors/docs-digest.md).

1. Ensure the digest/file exists at the path resolved by the executor (acceptance path or `docs/after-hours/<id>-digest.md`).
2. Prefer committing on the current after-hours branch **only if** the project already expects overnight commits without a PR; otherwise leave the file in the working tree and record the path — do not invent a PR “to be safe.”
3. Set item `notes` to include the artifact path (e.g. `doc-artifact: docs/after-hours/github-52-digest.md`).
4. Do **not** append to `prs`; does **not** count toward `maxPrs`.
5. If Sources set `outcomeKind: draft-pr` instead, publish the same file via `draft-pr` after it exists.

Safety checklist before any commit/push: no secrets in the file; denylist check ([guardrails.md](./guardrails.md)).

### Stubs (later)

Do not invent full harnesses yet. When `outcomeKind` names a stub:

- Prefer fail soft: mark `blocked` with `blockReason` noting unsupported adapter **or** fall back to `draft-pr` only if the executor doc explicitly allows it.
- `research-only` may fall back to issue comment ([research-only.md](../executors/research-only.md)) — treat that as a local `external-ticket-update`-shaped escape hatch until that stub is live.

## Defaults by executor

| Executor | Default `outcomeKind` |
|----------|----------------------|
| `pr-slice` | `draft-pr` |
| `feature-build` | `draft-pr` |
| `research-only` | `draft-pr` (research markdown PR); comment fallback when PR unavailable |
| `docs-digest` | `doc-artifact` (no PR unless Sources override) |

Override per item via Sources / queue materialization when non-default outcomes are intended.

## Orchestration note

**Sources** remain the only night-time binding to a workflow. Outcome adapters extend *how work ships*; they do not fork the tick loop. See [composition.md](../docs/composition.md).
