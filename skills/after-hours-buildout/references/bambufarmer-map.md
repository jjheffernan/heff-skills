# BambuFarmer build-out map (dogfood snapshot)

Adapt this file per repo; keep the **rungs** generic in `claim-ladder.md`.

## Locked direction

| Topic | Choice |
|-------|--------|
| Language | Go monorepo; 1 service → 1 image → 1 container |
| Control plane now | `fm_native` (+ fixture / CDP escapes) |
| Control plane later | `packages/farm.ControlPlane` direct-printer |
| Growth | Thin interfaces + optional compose profiles |
| UI | Go embed + Tailwind (`services/web`); no SPA rewrite |

Canon: `docs/BUILD_OUT.md`, `docs/plugins.md`, `docs/DESIGN_SPEC.md`.

## Capability → home

| Capability | Module |
|------------|--------|
| Live fleet / HMS / liveview | `edge` → Redis → `gateway` SSE → `web` |
| Jobs / artifacts / reprint / queue | `core` (+ object profile) |
| Cost / utilization | rate cards + `analytics` |
| Filament / Spoolman / AMS map | `integrations` + presets |
| Notify / power | adapters via URL env; Admin UI |
| Auth LAN / OIDC | `gateway` |
| Commerce | `services/commerce` profile |
| Slicer | `services/slicer` profile (`ORCA_BIN` not bundled) |

## Phases (status after after-hours dogfood)

| Phase | Intent | Night status |
|-------|--------|--------------|
| P0 | FM loop + fleet controls + cost | Code on draft PR; **live smoke = daylight** |
| P1 | Archive, search, reprint, richer queue | Landed on `#16` draft |
| P2 | Spoolman finish, low-stock, AMS slots | Landed |
| P3 | Notify webhook, power adapter | Landed |
| P4 | Commerce webhook + pack/ship echo | Landed (echo not stored) |
| P5 | Direct-printer adapter | Deferred (intentional) |
| P6 | Slicer + FM parity depth | Partial (slicer profile + UI); depth ongoing |

## Where nights actually went (lesson)

After P1–P4 APIs existed, most productive wakes were:

1. Wire API → Admin/Jobs/Fleet/plugins UI  
2. Field/SSE polish (progress %, HMS, offline, timestamps)  
3. Deep-links / copy / Open affordances  
4. UX ergonomics (`bfFlash`, Stop confirm, Jobs More menu)

**False stall:** `empty-queue` when polish ladder still had work.  
**True daylight:** `feature:p0-fm-live-smoke` (LAN).

## Draft PR pattern

- Branch: `after-hours/build-out` → `dev`  
- One accumulating draft PR; many small commits  
- Do not merge overnight; daytime reviews residual risk

## Sore spots to iterate in the skill repo

| Sore spot | Skill pressure |
|-----------|----------------|
| Soft-park too early | Claim-ladder mandatory before empty-queue park |
| Explore dupes Unreleased | Prompt: “NOT in Unreleased” + skip saturated APIs |
| Changelog section corruption | Wake-protocol: append-only under correct `###` |
| LAN smoke magnet | Rabbit-hole hard deny + fixture substitute |
| Mega-diff wakes | One rung / one slice; handoff the rest |
| UI string tests brittle | Assert stable ids / function names, not full markup |
| CSS token edits forgotten | Wake-protocol: rebuild `app.css` when `input.css` changes |

## Suggested next claims (update as you ship)

- Create-job progressive disclosure (simple vs advanced)
- Nav groups / hide idle plugin routes from stack status
- Admin Daily vs Lab + jump links
- Replace remaining `prompt()`/`alert()` with inline dialog
- Fleet filter chips as real `<button aria-pressed>`
- Daytime: review/merge PR #16; opt-in LAN smoke
