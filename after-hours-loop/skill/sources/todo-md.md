# Work source: `todo-md`

Internal backlog from [TODO.md](../../../TODO.md).

## Bootstrap config

```text
todo-md: section "Now"
todo-md: section "§3b" rows 1-3
todo-md: anchor pause dead-class audit
```

| Field | Meaning |
|-------|---------|
| `section` | Heading match (`Now`, `§3b`, sprint detail `### 1.`, etc.) |
| `rows` | Optional `1-3` slice of table rows under section (1-based) |
| `anchor` | Match row by slug or first-column text substring |

## Parse rules

1. Read `TODO.md` from repo root.
2. Under matched heading, collect:
   - Markdown table rows (skip header/separator); first column = task title
   - `- [ ]` checklist items
3. **Stable key:** slugify heading + first column / checklist text → e.g. `todo:3b-pause-audit`, `todo:now-commerce-currency`.
4. Skip rows already `- [x]` in file.

## Blockers table

Before materializing, read **Blockers → later design phase** table. If row text or linked doc matches a blocker (B3 CDN, Kenney design phase, etc.) without explicit unblock in bootstrap → materialize as `status: open` but executor should mark `blocked` on tick unless user overrode.

## Work item shape

```json
{
  "id": "todo:3b-pause-audit",
  "title": "pause dead-class audit",
  "source": "todo-md",
  "executor": "pr-slice",
  "ref": "TODO.md#3b-css--tailwind-consolidation",
  "acceptance": "row notes column if present",
  "granularity": "single-pr",
  "status": "open",
  "todoMatch": "pause dead-class audit"
}
```

**Executor routing:**

| Row type | Default executor |
|----------|------------------|
| Small engineering task | `pr-slice` |
| Row links to plan doc (`docs/...-plan.md`) or multi-step objective | `feature-build` |

Set `ref` to plan path when routing to `feature-build`.

## Refresh

Static — parsed at bootstrap only. Do not re-parse mid-run unless user re-bootstraps.

## Completion (auto check-off)

On successful PR in the same branch:

1. Find `- [ ]` line in `TODO.md` matching `todoMatch` (substring on row text or table first column).
2. Replace with `- [x]` on that line only.
3. If no checklist line exists (table-only row), append under section:

```markdown
- [x] <title> (after-hours loop)
```

4. If match ambiguous or not found, log in state `todoWriteback: failed` — still mark work item `done` if PR opened.

Include TODO check-off in the same commit as the fix when possible.
