# After-hours loop — glossary & bootstrap

Modular overnight / late-session agent work for this repo. Full orchestrator: [`.agents/skills/after-hours-loop/SKILL.md`](../../.agents/skills/after-hours-loop/SKILL.md).

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

## Layers

| Layer | Modules (v1) |
|-------|----------------|
| Work source | `github-issues`, `todo-md`, `feature-spec` |
| Executor | `pr-slice`, `feature-build` |
| Orchestrator | `after-hours-loop` skill + `/loop` or Cursor Automation |

## Resolved defaults (2026-07-13 grill)

| Decision | Choice |
|----------|--------|
| Feature granularity | **Hybrid** — pre-split when plan lists slices; else umbrella + runtime child items |
| Queue priority | **GitHub-first** — drain issues before TODO / feature items |
| TODO write-back | **Auto check-off** — same PR branch flips `- [ ]` → `- [x]` |
| Automation | **Prompt per run** — edit source list in Automations UI each night |

## Canonical work item

```json
{
  "id": "github:52",
  "title": "Marquee visibility gate",
  "source": "github-issues",
  "executor": "pr-slice",
  "ref": "https://github.com/jjheffernan/cosmic-themes-starter/issues/52",
  "acceptance": "optional",
  "granularity": "single-pr",
  "status": "open"
}
```

**ID convention:** `{source}:{stable-key}` — e.g. `github:52`, `todo:3b-pause-audit`, `feature:currency-phase1`.

## Bootstrap (in-session)

```text
/loop 45m Follow .agents/skills/after-hours-loop/SKILL.md
Sources:
  - github-issues: label ready-for-agent limit 5
  - todo-md: section "Now"
  - feature-spec: docs/commerce/currency-support-plan.md phase 1
maxPrs: 3
priority: github-first
```

Run bootstrap immediately (tick 0), then arm 45m sentinel `AGENT_LOOP_TICK_AFTERHOURS`.

## Bootstrap (Cursor Automation)

Edit automation **Instructions** before each night — same syntax:

```text
after-hours-loop bootstrap:
  - github-issues: label ready-for-agent limit 5
  - todo-md: section "Now"
maxPrs: 2
priority: github-first
```

Repo: `jjheffernan/cosmic-themes-starter`, base branch **`dev`**.

## Source modules

| Source | Module |
|--------|--------|
| GitHub issues | [sources/github-issues.md](../../.agents/skills/after-hours-loop/sources/github-issues.md) |
| TODO.md | [sources/todo-md.md](../../.agents/skills/after-hours-loop/sources/todo-md.md) |
| Feature plan docs | [sources/feature-spec.md](../../.agents/skills/after-hours-loop/sources/feature-spec.md) |

## Executor modules

| Executor | Module |
|----------|--------|
| PR slice (ponytail-debug) | [executors/pr-slice.md](../../.agents/skills/after-hours-loop/executors/pr-slice.md) |
| Feature build (implement + TDD) | [executors/feature-build.md](../../.agents/skills/after-hours-loop/executors/feature-build.md) |

## State file

Ephemeral progress: `.cursor/after-hours-loop.state.json` (gitignored).

## Stop

- Empty queue
- `maxPrs` reached
- Guardrail trip (auth/webhook weakening → full stop)
- User: **stop loop** (kill sentinel PID)

## Related

- [Triage labels](./triage-labels.md) — `ready-for-agent`
- [Skills & subagents](./skills-and-subagents.md)
- [TODO.md](../../TODO.md) — internal backlog
