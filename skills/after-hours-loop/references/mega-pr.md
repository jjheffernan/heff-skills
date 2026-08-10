# Mega-PR mode (unsafe throughput — **explicit every run**)

For operators who want **maximum throughput**: many queue items land on **one shared draft PR** instead of nicely sliced PRs.

**Default is OFF.** Sliced `draft-pr` per item/slice remains the only safe default.

## Activation (flag + accept — every arm)

Mega-PR turns on when the **current kickoff** includes **both**:

1. `--mega-pr`
2. Accept: `-accept`

Example:

```text
/after-hours --mega-pr -accept
/after-hours 45m --mega-pr -accept
```

| Source | Allowed to enable? |
|--------|-------------------|
| Current chat / Automation Instructions | **Yes** — `--mega-pr` **and** `-accept` |
| `.cursor/after-hours-loop.config.json` | **Never** — ignore `megaPr` if set; warn in brief |
| Prior `state.json` from an earlier run | **Never** — do not inherit sticky mega mode across arms |
| Always-on Cursor rules | **Never** |

Missing either piece → stay **sliced**. Present only one → **Stop** preflight (`blocked` / `preflight`) with a message to add both or remove both.

Dry-run may print “would enable mega-PR” only when both are present; never write mega sticky flags into config.

## What changes when enabled

| Default (sliced) | Mega-PR |
|------------------|---------|
| One draft PR per item / feature slice | **One** shared draft PR for the run |
| Branch `after-hours/<item-slug>` | Branch `after-hours/mega-<startedAt-date>` (reuse for the run) |
| `maxPrs` = max draft PRs | Treat as **max items** folded into the mega PR (`prs.length` stays `0` or `1`) |
| Umbrella → child PRs | Umbrella children commit onto the **same** mega branch/PR |

Still required: readiness, denylist, draft-only (`draftPrs: true` unless human overrides — prefer force-draft even in mega), no merge, no force-push, no inventing scope, fail-closed preflight.

## Executor notes

1. First mega item: create branch from `baseBranch`, open **one** draft PR titled e.g. `after-hours mega: <date> (explicit opt-in)`.
2. Later items: checkout same branch; commit; push; **update** the same PR body with a checklist of item ids.
3. Record a single `prs[]` entry; list item ids in `notes` / PR body. Do not open per-item PRs while mega is active.
4. `docs-digest` / `doc-artifact` / `ops-checklist` items stay path- or brief-based unless `outcomeKind: draft-pr` — mega applies to **PR bundling**, not forcing digests/ops into the PR (optional append if human’s Sources say so). Same for `branch-only`, `report-only`, and `external-ticket-update` — do **not** invent a mega PR for those adapters.

## Morning brief

Lead Summary with:

> **MEGA-PR MODE** — human opted in this run via `--mega-pr -accept`. Bundled draft PR — review carefully.

List every item folded into the mega PR.

## Automation

Do **not** put `--mega-pr -accept` in the default office-hours Instructions template. If an unsafe operator wants it, they paste **both** flags into that night’s Instructions **each scheduled fire** — cron must not “remember” mega from last night.

## Refuse accidental enablement

- Soft-detect never implies mega.
- Peer skills never imply mega.
- `maxPrs: 99` alone is **not** mega — still one-PR-per-item until `--mega-pr` **and** `-accept` appear.
- `megaPr: true` in a Sources block is **not** enough — use the slash flags.
