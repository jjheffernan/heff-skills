# Executor: `research-only`

Produce a **research writeup** for an AFK ticket — **do not** implement the product destination.

Use when the work item’s `executor` is `research-only` (typically from [wayfinder-afk](../sources/wayfinder-afk.md)).

## Soft tools

- **If a `/research` subagent** (or project research skill) is present → prefer it for exploration; summarize its findings into the deliverable.
- Soft-read `CONTEXT.md` / `docs/adr/*` if present — do not rewrite them overnight.
- Soft-read [ponytail](https://github.com/DietrichGebert/ponytail) only if edits drift into code; default is docs/notes only.

## Deliverable (prefer draft PR)

1. Branch from configured `baseBranch` (default `main`), e.g. `after-hours/research-<slug>`.
2. Write findings to a linked path from the ticket Notes, or a sensible docs path such as `docs/research/<slug>.md` / `.scratch/research/<slug>.md` if the ticket does not specify.
3. Prefer opening a **draft PR** whose diff is the research markdown (and only incidental index links if needed).
4. Fallback: if a coding harness / draft PR is unavailable, **`gh issue comment`** on the ticket with the research notes (or attach a gist link). Prefer draft PR when `gh` + git work.

PR / comment must make clear: research only — no product feature shipped.

```bash
BASE="${baseBranch:-main}"
DRAFT_FLAG="--draft"   # when draftPrs true (default)

gh pr create --base "$BASE" $DRAFT_FLAG \
  --title "docs(research): <short title>" \
  --body "$(cat <<'EOF'
## Summary
- Research notes only — no product feature implementation.

## Work item
- <id> — <ref>

## Follow-ups
- [ ] Human / grill / to-tickets as needed
EOF
)"
```

For GitHub-backed items: link the issue; use `Refs #N` (not `Fixes`) unless Notes say the research ticket should close on writeup merge policy.

## Out of scope

- Implementing the product change described by the ticket
- Opening a feature/fix PR “while you’re here”
- Answering HITL grilling or building prototypes
- Touching secrets / auth-weakening paths (same [safety](../references/guardrails.md) as other executors — **stop loop** if violated)

If Notes explicitly authorize a tiny product change **and** Sources/bootstrap allow it, hand off to `pr-slice` / `feature-build` instead — this executor stays research-only.

## Tests

No product test suite required. If docs tooling / link check exists and is cheap, optional; failure → note residual risk, do not block solely for missing apps tests.

## Safety checklist

1. Match `draftPrs` (research PRs are draft by default).
2. Denylist check on changed paths before commit/push/PR — match → **stop loop** ([guardrails](../references/guardrails.md)).
3. Do not implement product destination code; research notes only.
4. Never force-push; never target opening the PR against the wrong base.

## Outcome

| Result | Item status |
|--------|-------------|
| Draft research PR opened, or research comment attached | `done` |
| Missing acceptance; needs human product / HITL; cannot place writeup | `blocked` |
| User skip | `skipped` |

Append `{ "url", "itemId", "branch", "draft": true }` to state `prs` when a PR was opened.

**After open:** if `draftPrs: true`, confirm `gh pr view <url> --json isDraft -q .isDraft` is `true`; else convert to draft or **stop loop**.
