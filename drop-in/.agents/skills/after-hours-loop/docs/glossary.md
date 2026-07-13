# After-hours loop — glossary & bootstrap

Modular overnight / late-session agent work. Orchestrator: `.agents/skills/after-hours-loop/SKILL.md` (see heff-skills SoT `skills/after-hours-loop/SKILL.md`).

## Ubiquitous language

| Term | Meaning |
|------|---------|
| **Loop run** | One armed session from bootstrap until stop |
| **Tick** | One orchestrator iteration: pick item → execute → record outcome |
| **Work item** | Normalized unit the loop consumes |
| **Work source** | Adapter that materializes or refreshes work items |
| **Executor** | Strategy that completes one work item (or one slice) |
| **Outcome** | `done`, `blocked`, or `skipped` on an item |
| **Slice** | Smallest shippable unit for an executor (usually one PR) |
| **Agent-ready** | Work with clear acceptance (e.g. `ready-for-agent` + brief); AFK must not invent scope |

## Layers

| Layer | Modules (v1) |
|-------|----------------|
| Work source | `github-issues`, `todo-md`, `feature-spec`, `wayfinder-afk` (opt-in) |
| Executor | `pr-slice`, `feature-build`, `research-only` |
| Orchestrator | `after-hours` skill + `/after-hours`, `/loop`, or Cursor Automation |
| References | readiness, compatibility, bootstrap, guardrails, state, morning-brief |

## Resolved defaults

| Decision | Choice |
|----------|--------|
| Feature granularity | **Hybrid** — pre-split when plan lists slices; else umbrella + runtime child items |
| Queue priority | **GitHub-first** — drain issues before TODO / feature items |
| TODO write-back | **Auto check-off** — same PR branch flips `- [ ]` → `- [x]` |
| PRs | **Draft by default** overnight (`draftPrs: true`) |
| Base branch | **Configurable** (`baseBranch`, default `main`) |
| Automation | **Prompt per run** — edit Sources in Automations UI each night (template optional) |

## Canonical work item

```json
{
  "id": "github:52",
  "title": "Example issue title",
  "source": "github-issues",
  "executor": "pr-slice",
  "ref": "https://github.com/owner/name/issues/52",
  "acceptance": "optional",
  "granularity": "single-pr",
  "status": "open"
}
```

**ID convention:** `{source}:{stable-key}` — e.g. `github:52`, `todo:3b-pause-audit`, `feature:example-phase1`.

## Bootstrap (in-session)

```text
/after-hours 45m
Sources:
  - github-issues: label ready-for-agent limit 5
  - todo-md: section "Now"
  - feature-spec: docs/plans/example-plan.md phase 1
maxPrs: 3
priority: github-first
```

Equivalent: `/loop 45m` followed by “Follow `.agents/skills/after-hours-loop/SKILL.md`” plus the same Sources block.

Run bootstrap immediately (tick 0), then arm sentinel `AGENT_LOOP_TICK_AFTERHOURS`.

## Bootstrap (Cursor Automation)

```text
/after-hours bootstrap:
  - github-issues: label ready-for-agent limit 5
  - todo-md: section "Now"
maxPrs: 2
priority: github-first
```

Checkout configured **`baseBranch`**.

## State & morning brief

| Artifact | Path (default) | Gitignore |
|----------|----------------|-----------|
| State | `.cursor/after-hours-loop.state.json` | Yes |
| Morning brief | `.cursor/after-hours-morning-brief.md` | Yes |
| Config | `.cursor/after-hours-loop.config.json` | Optional (often commit) |

## Stop

- Empty queue
- `maxPrs` reached
- Guardrail trip (auth/secrets / dirty tree per config)
- User: **stop after-hours** / **stop loop** (kill sentinel PID)

On stop, write the morning brief (pointers to PRs and blocked items).
