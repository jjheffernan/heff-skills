# heff-skills — improvement plan

Living plan for **after-hours-loop**: a drop-in, **workflow-agnostic AFK orchestrator** — install once, point at any agent-ready tracker, walk away. Shape **heff-skills** like mature public skill repos (structure/UX only; do not copy their skill text).

**Status:** Phase 4 sealed on `main` (tag `v0.1.0` deferred); Phase 5 = abstraction + beyond-code  
**Last updated:** 2026-07-13  
**Target:** https://github.com/jjheffernan/heff-skills

**Research swarms:** [caveman](3b485d0f-3fee-4e40-9cdc-f90cafb9b5a3) · [ponytail](9228fb73-db99-4e86-b15b-4992c3191231) · [mattpocock](d66efc9e-b3cd-4ee6-a36d-bc59d3e6ade1) · [local audit](a95719c0-80a1-43a1-b667-d6ffa0014977)  
**Phase 1 structure audit:** [post-phase-1](5925cc8b-83e3-4ada-aed7-bf0c4f5d3273)  
**Phase 2 structure audit:** [post-phase-2](ae706577-6cae-4366-8e66-3c111daee94c)  
**Phase 3 structure audit:** [post-phase-3](73b45955-2172-4434-b4f2-b72d3d04242c)  
**Cumulative P1–P3 audit:** [cumulative](4cb22da8-a496-4894-a193-6a750b1bcc22)  
**Phase 4 structure audit:** [post-phase-4](bda1c157-e503-4961-8d80-f4222491c659)

---

## 1. North star

Ship a skill pack where someone can:

1. Install into any Cursor (Agent Skills–compatible) host in under a minute.
2. Point after-hours at **any** trackable inbox of agent-ready work (issues, TODOs, specs, tickets, maps, future non-code queues).
3. Walk away — the loop picks work, runs **A→Z** within the chosen executor, stops safely, leaves a morning brief.

**Positioning:** after-hours is the **AFK loop itself**, not a leaf under grill → tickets. Workflows (Matt, Linear, custom Markdown, research packs, …) are **optional peers** that may produce ready work. We stay Matt-**compatible** (detect/consume their artifacts) without requiring that pipeline or living inside it.

**Direction:** keep code/PR executors excellent for v1, then grow sources + executors beyond code-agent flows (research synthesis, docs, triage digests, ops checklists) while the orchestrator stays stable.

---

## 2. What research told us

### 2.1 Emulate from [caveman](https://github.com/JuliusBrussee/caveman)

| Pattern | Takeaway for us |
|---------|-----------------|
| Productized distribution | `skills/` SoT + INSTALL hierarchy (README 60s → INSTALL.md deep) |
| `npx skills add … -a cursor` | Match registry layout so Cursor installs without bespoke paths |
| Activation tiers | Opt-in skill / thin `--with-init` pointer — **never** always-on overnight hooks by default |
| Progressive disclosure | Thin `SKILL.md` + `references/` |
| Sibling loop-factory | Ready gate, batch limits, empty-queue noop, run artifacts, autonomy contract |

Also note Julius ships a separate [`loop-factory`](https://github.com/JuliusBrussee/skills/tree/main/skills/loop-factory) (inbox → active → archive). Study that shape for queue maturity; do not copy content.

**Don't:** 30-agent installer on day one; hand-maintained duplicate trees; metrics theater without harness.

### 2.2 Emulate from [ponytail](https://github.com/DietrichGebert/ponytail)

| Pattern | Takeaway for us |
|---------|-----------------|
| Thin adapters, one behavior source | One `skills/after-hours-loop/`; generate drop-in |
| Persistence / boundaries / stop | Re-anchor rules every tick; clear stop severity |
| Soft-fail optional tooling | Missing ponytail/hooks → continue with fallbacks |
| Deferred-work ledger | Blocked items must not vanish overnight |
| `after-install.md` + uninstall | Residual state (sentinel, state JSON) needs cleanup docs |
| Drift tests | If we mirror adapters, CI sync — or don't pretend |

**Don't:** multi-marketplace sprawl; mandatory peer skills; README as only portability map.

### 2.3 Compose with [mattpocock/skills](https://github.com/mattpocock/skills)

**Doctrine we adopt (structure):**

- User-invoked orchestrators vs model-invoked primitives; AHL is user/automation-invoked.
- Hard vs soft deps: soft = “if CONTEXT/ADRs/tracker docs exist”; hard = “items must already be agent-ready.”
- Main build chain we sit under:

```text
[optional] wayfinder (plan fog) / triage (incoming)
        → grill-with-docs | grill-me
        → to-spec → to-tickets
        → ★ after-hours-loop (AFK multi-ticket implement)
        → morning brief → human review
```

**Interfaces to consume (not reinvent):**

| Artifact | From | AHL behavior |
|----------|------|--------------|
| `CONTEXT.md` + `docs/adr/` | grill-with-docs / domain-modeling | Soft-read every tick; never rewrite overnight |
| Chat-only alignment | grill-me | Stateless — **no file to consume**; user must convert via to-spec/tickets **before** AFK |
| Map + `wayfinder:*` tickets | wayfinder | Build only when map clear *or* Sources opt into `wayfinder-afk` (research / AFK task only — never HITL grilling/prototype overnight) |
| `ready-for-agent` + Agent Brief | triage / to-tickets | Primary GitHub queue; prefer Brief over raw body |
| `docs/agents/issue-tracker.md` | setup-matt-pocock-skills | Prefer its ops; don't invent a second dialect |
| Handoff temp file | handoff | Fine for human↔human; AHL morning brief is **durable in-repo** (pointers > dumps) |

**Hard rule:** no interactive grilling, no answering HITL wayfinder tickets, no inventing product decisions during ticks.

### 2.4 Local audit verdict

Orchestration model (sources → queue → executors → PRs + state JSON) is **worth keeping**. Runtime contract is still a **cosmic-themes-starter export**: absolute paths, `dev`/pnpm/B3 hardcodes, mandatory non-bundled skills, identical `skill/` ↔ `drop-in/` twins, thin morning handoff, weak portable safety/stop policy.

---

## 3. Target product shape

### 3.1 Repo layout (locked proposal)

```text
heff-skills/
├── README.md
├── LICENSE
├── INSTALL.md
├── plan.md                          # this file
├── SECURITY.md                      # install/network surface; no telemetry
├── AGENTS.md                        # optional: @include skills for agents opened here
├── skills/
│   └── after-hours-loop/
│       ├── SKILL.md                 # thin orchestrator + COMPATIBILITY
│       ├── README.md                # human: what / kickoff / uninstall
│       ├── references/
│       │   ├── bootstrap.md
│       │   ├── tick-and-runners.md
│       │   ├── guardrails.md
│       │   ├── readiness.md         # agent-ready checklist
│       │   ├── compatibility.md     # wayfinder / grill-* / triage
│       │   ├── morning-brief.md     # template
│       │   └── state-schema.md
│       ├── sources/
│       │   ├── github-issues.md     # Agent Brief aware
│       │   ├── todo-md.md
│       │   ├── feature-spec.md
│       │   ├── wayfinder-afk.md     # NEW — opt-in
│       │   └── github-tickets.md    # NEW — to-tickets frontier (stretch)
│       ├── executors/
│       │   ├── pr-slice.md          # self-contained fallback path
│       │   ├── feature-build.md
│       │   └── research-only.md     # NEW — optional, no product PR
│       └── templates/
│           ├── Sources.example.txt
│           ├── config.example.json
│           └── morning-brief.md
├── scripts/
│   ├── sync-drop-in.sh              # generate drop-in from skills/
│   ├── install.sh                   # Cursor-first: copy + gitignore hints
│   └── validate-state.py            # optional schema check
├── drop-in/                         # GENERATED — do not hand-edit
│   └── .agents/skills/after-hours-loop/…
└── docs/
    ├── architecture.md
    ├── composition.md               # vs Matt main flow
    └── portability.md               # Cursor /loop + Automation only (v1)
```

Migrate from today's `after-hours-loop/skill` + `after-hours-loop/drop-in` into `skills/after-hours-loop` + generated `drop-in/`.

### 3.2 Startup cycle (maturity parity)

| Phase | Human? | Behavior |
|-------|--------|----------|
| **0. Install** | Yes | `npx skills add` or `install.sh` / copy; LICENSE + gitignore state + morning brief path |
| **1. Setup** | Yes once | Config: repo, baseBranch, testCommand, packageManager; soft-detect Matt setup / ponytail |
| **2. Align** | Yes (optional) | Prefer existing grill-with-docs / wayfinder / to-tickets; else require pre-approved Sources |
| **3. Arm / preflight** | Yes | Validate: `gh` auth, clean tree, base branch, sources non-empty or explicit allow, state writable; **dry-run** prints queue |
| **4. Tick loop** | No | Refresh → pick agent-ready → execute → draft PR → persist; soft-read CONTEXT/ADRs |
| **5. Stop** | Auto | empty / maxPrs / consecutive-blocked / dirty-tree / hard safety / user stop |
| **6. Morning** | Yes | Write `.cursor/after-hours-morning-brief.md` (PRs, blocked, residual risk, “grill tomorrow”); kill sentinel docs |

### 3.3 Compatibility contract (draft → implement in `references/compatibility.md`)

**Detect order**

1. `docs/agents/issue-tracker.md` → use tracker ops.
2. `ready-for-agent` issues (+ Agent Brief) → primary queue.
3. to-tickets frontier (GitHub deps or `.scratch/…/issues`) when Sources enable it.
4. Open `wayfinder:map` → ignore for product PRs unless `wayfinder-afk` source; only research/AFK task; mention map in morning brief.
5. `CONTEXT.md` / `docs/adr/` → soft constraints.
6. Native `todo-md` / `feature-spec` as today.

**Fallback if Matt absent:** only labeled / checked / named Sources; vague items → `blocked`, never invent scope.

**Soft deps:** ponytail, implement, tdd, code-review — “if present, use; else executor-local steps.”

### 3.4 AFK readiness bar

- [x] Zero personal absolute paths in published docs
- [x] Portable `config.example.json` (repo, baseBranch, testCommand, packageManager, safety paths)
- [x] Cursor install path(s) documented; skills-registry-ready `skills/*/SKILL.md`
- [x] Single SoT + generated drop-in
- [x] Validated state schema + resume + dry-run *(schema docs + `scripts/validate-state.py`)*
- [x] Preflight fail-closed *(prompt contract)*
- [x] Stop severity: skip / block / stop loop / escalate *(vocab + consecutive-blocked / CI-red cascades)*
- [x] Morning brief always written on stop *(prompt contract)*
- [x] Draft PRs by default overnight; path denylist; secrets/auth hard stops *(create-time + post-open isDraft verify)*
- [x] Works without ponytail and without Matt skills *(soft deps)*
- [x] Compatible *with* Matt when installed (same `ready-for-agent` language)
- [x] LICENSE + uninstall / residual-state docs
- [x] `/loop` vs Automation runners documented with same bootstrap syntax *(plus `/after-hours`)*

---

## 4. Implementation phases

### Phase 0 — Plan & research ✅

- [x] Research swarms (caveman, ponytail, mattpocock, local audit)
- [x] Fold findings into this plan
- [x] Lock layout: `skills/` SoT + generated `drop-in/`
- [x] Lock positioning: downstream AFK of Matt chain; Cursor-first packaging

### Phase 1 — Repo hygiene & packaging ✅

- [x] Add root `LICENSE`, rewrite `README.md`, draft `INSTALL.md` + `SECURITY.md`
- [x] Move canonical skill to `skills/after-hours-loop/` (legacy `after-hours-loop/` removed)
- [x] Strip cosmic-themes / absolute paths / mandatory peer skill reads
- [x] Add `templates/config.example.json` + parameterize `baseBranch` / `repo` / `testCommand`
- [x] `scripts/sync-drop-in.sh` + `scripts/install.sh` (Cursor-first; dry-run; uninstall notes)
- [x] Enrich frontmatter: triggers + `disable-model-invocation: true`; primary slash **`/after-hours`**
- [x] Generated `drop-in/` from SoT via sync script
- [x] Post-phase audit vs caveman/ponytail/mattpocock ([audit](5925cc8b-83e3-4ada-aed7-bf0c4f5d3273)); fixed soft-fails (config link, pnpm default, drop-in doc pointer, `references/` stubs)

**Audit residual → Phase 2:** fill `references/*`, morning-brief template, readiness/compatibility contracts, preflight; CI drift gate later.

### Phase 2 — Startup + compatibility + handoff ✅

- [x] `references/readiness.md` + `compatibility.md` (+ guardrails, bootstrap, state-schema, morning-brief)
- [x] Preflight checklist in bootstrap; dry-run mode (`/after-hours --dry-run`)
- [x] `morning-brief` template + always write on stop (in-repo, pointers > dumps)
- [x] github-issues source: prefer Agent Brief comments
- [x] Opt-in `sources/wayfinder-afk.md` + `executors/research-only.md`
- [x] Soft-deps wording (ADR-0001 style) in SKILL + compatibility
- [x] Phase-1 residual: thin SKILL → references, drop-in sync CI (`check-drop-in-sync.sh` + workflow), `docs/composition.md`
- [x] Post-phase-2 structure audit ([audit](ae706577-6cae-4366-8e66-3c111daee94c)); fixed pack links, `prs` schema, wayfinder fallback, `allowEmptyQueue`, thin SKILL + `tick-and-runners.md`
### Phase 3 — AFK loop completeness ✅

- [x] Harden stop policy (consecutive-blocked, dirty-tree, CI-red cascade)
- [x] Deepen self-contained executor fallback (Safety checklist on pr-slice / feature-build)
- [x] Portable denylist enforcement notes + draft-PR verification
- [x] Resume mid-queue docs + `scripts/validate-state.py` (also under skill `scripts/`)
- [x] Optional `research-only` executor *(shipped Phase 2)*
- [x] Automation multi-item vs `/loop` interval *(tick-and-runners.md)*
- [x] Post-phase-3 structure audit ([audit](73b45955-2172-4434-b4f2-b72d3d04242c)); fixed composition pack links, morning-brief `ci-red`, prs-object wording, research-only safety checklist

### Phase 4 — Polish & distribute ✅

- [x] `docs/composition.md` *(shipped Phase 2; also skill-local copy)*
- [x] `docs/portability.md` *(shipped Phase 1)*
- [x] `CHANGELOG.md` (Unreleased + 0.1.0 incl. Phase 4) + root `VERSION` (`0.1.0`)
- [x] Document primary install: `npx skills add jjheffernan/heff-skills -a cursor`; clone + `./scripts/install.sh` as alternative; note release tag `v0.1.0`
- [x] Minimal validate-state fixtures under `skills/after-hours-loop/fixtures/` (+ skill README pointer)
- [x] Example kickoff prompts + night Sources templates + `docs/first-night.md`
- [x] Optional thin Cursor rule template (`cursor-rule.after-hours-loop.mdc.example`)
- [x] Opt-in `sources/github-tickets.md` (to-tickets frontier)
- [x] Post-phase-4 structure audit ([audit](bda1c157-e503-4961-8d80-f4222491c659)); followed up: CHANGELOG/plan honesty, research-only `isDraft`, Sources/architecture/frontmatter consistency
- [x] Smoke CI for validate-state fixtures (valid → 0, invalid → nonzero)
- [ ] Create git tag `v0.1.0` *(cut at publish after push is green)*
- [ ] Fixtures for parse / priority / write-back (stretch beyond validate-state samples)

---

## 5. Decisions

| Date | Decision | Why |
|------|----------|-----|
| 2026-07-13 | Living `plan.md` before large refactors | Research → phases → AFK bar |
| 2026-07-13 | Emulate caveman/ponytail **packaging**; compose with mattpocock | Unique AHL; reuse ecosystem |
| 2026-07-13 | No interactive grilling mid-tick | Unattended safety |
| 2026-07-13 | **Cursor-first** install; multi-host matrix later | Avoid ponytail-scale adapter sprawl |
| 2026-07-13 | Canonical path: `skills/after-hours-loop/`; **generate** drop-in | End dual-edit drift |
| 2026-07-13 | Default base branch: **configurable**, example `main`; document `dev` as adapter | Portability |
| 2026-07-13 | AHL remains **user/automation-invoked** orchestrator | Matches Matt user-invoked pattern; model doesn't autodrain overnight |
| 2026-07-13 | Publish via skills registry after Phase 1 packaging stabilizes | SoT layout first |
| 2026-07-13 | Night Sources: optional committed template + nightly paste still OK | Bridge “set and forget” vs flexibility |
| 2026-07-13 | Draft PRs by default for overnight | Safer morning review |
| 2026-07-13 | Primary slash **`/after-hours`** (`name: after-hours`); `/loop` still supported | User-requested trigger; install path stays `after-hours-loop/` |

| 2026-07-13 | Ship `github-tickets` + `wayfinder-afk` in 0.1 (opt-in Sources) | Matt frontier + AFK research coverage without default noise |
| 2026-07-13 | Defer git tag `v0.1.0` until Phase 4 commit + push | Avoid tagging an incomplete tree |
| 2026-07-13 | Reposition: workflow-agnostic AFK; Matt is optional peer, not parent | Avoid locking growth to grill→ticket; enable non-code executors |

### Still open (non-blocking)

1. Exact morning brief path sticky issue vs `.cursor/` file — currently config `morningBriefPath`
2. Companion micro-skills (`after-hours-stop`, `after-hours-handoff`) vs reference files only
3. Parse/priority/write-back fixture harness (stretch)
4. First non-code executor + outcome shape (docs? research digest? ops report?)

---

## 6. Findings log (condensed)

### Caveman

Distribution machine: SoT `skills/`, INSTALL matrix, activation tiers, CI mirrors, integrity. AFK lesson via **loop-factory** sibling: ready-only work, batch limits, empty noop, run logs. heff should productize install + adapters + ready/stop/handoff — not a 30-agent installer.

### Ponytail

Thin adapters + one behavior source; persistence/stop maturity; soft-fail; deferred ledger; uninstall residual state. AFK borrows activation hygiene; heff already leads on queue/state/PR budget. Soft-require ponytail; don't gate Cursor AFK on Claude hooks.

### mattpocock/skills

Composable gate-heavy startup ending at labeled, briefed, frontier tickets. Treat as **optional upstream**: detect artifacts, prefer briefs/maps/tickets when named in Sources, degrade to any other ready tracker — never require grill/HITL overnight, never sit as a fixed leaf under that chain. Adopt readiness vocabulary: frontier, claim, agent-ready, brief, blocked, handoff, fog.

### Local after-hours-loop

Keep sources × executors × state × dual runners. Fix: portable config, self-contained executor, preflight, stop/handoff/safety, collapse duplication, strip export leftovers. Priority order = Phase 1 → 2 → 3 above.

---

## 7. Immediate next actions → Phase 5

Phases 1–4 shipped the portable AFK coding loop. Next:

### 7.1 Abstraction (workflow-agnostic core)

- [ ] Rewrite readiness / composition language everywhere so trackers are **inputs**, not a mandated upstream chain (Matt remains soft-compat docs + opt-in sources).
- [ ] Normalize the queue item contract: `id`, `title`, `acceptance`, `blockerPolicy`, `executorHint`, `outcomeKind` — independent of GitHub/PR.
- [ ] Separate **outcome adapters** from executors: `draft-pr` today; later `branch-only`, `doc-artifact`, `report-only`, `external-ticket-update`.
- [ ] Keep Sources as the only night-time binding to a workflow; add adapters, don’t fork orchestration.

### 7.2 Beyond code

- [ ] Ship one non-code executor MVP (candidate: research/docs digest writing into a repo artifact + morning brief, no PR required).
- [ ] Domain-agnostic stop reasons (`done` / `blocked` / `noop` / `budget`) with outcome-specific details in state.
- [ ] Document “A→Z” as executor-defined completion, not “opened a PR”.

### 7.3 Matt compatibility (without subordination)

- [ ] Keep `wayfinder-afk` + `github-tickets` opt-in; never default them.
- [ ] Smoke matrix: Matt artifacts present vs absent vs mixed Sources — same orchestrator path.
- [ ] Refuse any design that requires grill/to-tickets before `/after-hours` can start.

### 7.4 Hardening / release

- [ ] Tag `v0.1.0` when packaging + smoke CI are green on remote.
- [ ] Expand fixtures (parse / priority / write-back).
- [ ] Optional companion micro-skills for stop/handoff if references stay too long.

---

## References

- [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman)
- [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail)
- [mattpocock/skills](https://github.com/mattpocock/skills) — optional peers: wayfinder, grill-me, grill-with-docs, grilling, handoff, setup, triage, to-spec, to-tickets
- Optional peer pattern: [loop-factory](https://github.com/JuliusBrussee/skills/tree/main/skills/loop-factory)
