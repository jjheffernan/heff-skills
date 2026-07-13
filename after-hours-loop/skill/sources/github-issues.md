# Work source: `github-issues`

PR-based issue tracking via `gh`. Triage label: [ready-for-agent](../../../docs/agents/triage-labels.md).

## Bootstrap config

Parse from source line:

```text
github-issues: label ready-for-agent limit 5
github-issues: numbers 52,61,70
```

| Field | Default |
|-------|---------|
| `label` | `ready-for-agent` |
| `limit` | `10` |
| `numbers` | optional comma-separated issue numbers (ignores label query) |

## Materialize work items

```bash
gh issue list --repo jjheffernan/cosmic-themes-starter \
  --label ready-for-agent --state open \
  --json number,title,url,body --limit 10
```

For explicit numbers:

```bash
gh issue view 52 --repo jjheffernan/cosmic-themes-starter --json number,title,url,body
```

Map each issue to:

```json
{
  "id": "github:52",
  "title": "<title>",
  "source": "github-issues",
  "executor": "pr-slice",
  "ref": "<url>",
  "acceptance": "<first acceptance block from body, or body excerpt>",
  "granularity": "single-pr",
  "status": "open"
}
```

Default `executor: pr-slice`. Override at bootstrap if issue body references a plan doc → `feature-build`.

## Refresh

- **Cloud Automation:** re-query each tick; drop issues no longer open; do not re-add `done` IDs from current run's state.
- **In-session:** optional refresh at tick start; preserve in-flight item.

## Completion (executor callback)

After successful PR:

1. PR body includes `Fixes #N` or `Closes #N`.
2. Optional: `gh issue comment N --body "After-hours loop: <PR URL>"`.
3. Do **not** auto-close issue unless PR merge policy does — loop marks work item `done` when PR is opened.

## Blocked

Mark `blocked` without PR when issue:

- Needs product decision or is tagged blocked in body
- References B3 CDN / design phase gates without explicit unblock
- Requires 6-locale content sweep (escalate `site-content-coder` scope)
