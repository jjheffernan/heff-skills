# Architecture — after-hours-loop

High-level shape of the AFK overnight skill. Runtime detail lives in `skills/after-hours-loop/`.

```text
                    ┌─────────────────────┐
   /after-hours ──► │  SKILL.md (thin)    │
   /loop           │  orchestrator        │
   Automation      └──────────┬──────────┘
                              │
         ┌────────────────────┼────────────────────┐
         ▼                    ▼                    ▼
   references/            sources/             executors/
   bootstrap              github-issues        pr-slice
   readiness              todo-md              feature-build
   compatibility          feature-spec         research-only
   guardrails             wayfinder-afk
   state-schema
   morning-brief
   tick-and-runners
```

| Concern | Where |
|---------|--------|
| Install / uninstall | Root `INSTALL.md`, `scripts/install.sh` |
| Generated install tree | `drop-in/` via `scripts/sync-drop-in.sh` |
| Drift CI | `scripts/check-drop-in-sync.sh` + `.github/workflows/drop-in-sync.yml` |
| State validation | `scripts/validate-state.py` (also skill-local `scripts/`) |
| Matt / peer composition | `docs/composition.md`, `references/compatibility.md` |

**Rule:** edit `skills/after-hours-loop/` only; never hand-edit `drop-in/`.
