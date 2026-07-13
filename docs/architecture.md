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
   guardrails             wayfinder-afk        docs-digest
   state-schema           github-tickets
   morning-brief          (+ fixtures/)
   tick-and-runners
   outcomes / cloud-ledger
```

| Concern | Where |
|---------|--------|
| Install / uninstall | Root `INSTALL.md`, `scripts/install.sh` |
| First overnight | `docs/first-night.md` |
| Office-hours Automation | `docs/automation.md`, `references/cloud-ledger.md` |
| Matt smoke matrix | `docs/smoke-matrix.md` |
| Night / Sources templates | `skills/after-hours-loop/templates/` (`Sources.example.txt`, `night-Sources.*.txt`) |
| Generated install tree | `drop-in/` via `scripts/sync-drop-in.sh` |
| Drift CI | `scripts/check-drop-in-sync.sh` + `.github/workflows/ci.yml` |
| State validation | `scripts/validate-state.py` (also skill-local `scripts/`) |
| Matt / peer composition | `docs/composition.md`, `references/compatibility.md` |

**Rule:** edit `skills/after-hours-loop/` only; never hand-edit `drop-in/`.
