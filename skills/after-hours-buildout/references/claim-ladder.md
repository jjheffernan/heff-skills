# Claim ladder — refill when Sources are empty

Walk **top to bottom**. Claim the first rung with concrete work. Soft-park only if none apply.

## Rung 0 — Explicit handoff

Read `docs/BUILD_OUT.md` (or repo roadmap) **Session handoff → Next**.  
If it names a slice, claim that.

## Rung 1 — Phase gaps (feature-spec)

Compare roadmap phases (P0…Pn) to what shipped in `[Unreleased]` + draft PR.  
Prefer **fixture-testable** leftovers over live-hardware acceptance.

## Rung 2 — API exists, UI missing

Explore gateway/core routes vs embedded web (`services/web/main.go` or equivalent).  
One page/control per wake. String-test the HTML for the new affordance.

## Rung 3 — Field / SSE payload polish

Data already on the wire (progress %, HMS, timestamps, offline) but not shown.  
No new endpoints.

## Rung 4 — Cross-page affordances

Deep-links (`?id=`), copy/share, Open → drawer, filter URL bootstrap.  
Tiny diffs; high operator value.

## Rung 5 — UX ergonomics

Density (row More menus), destructive confirm + danger style, shared flash/toast, progressive disclosure on fat forms, nav grouping, Admin jump links.  
Still Go-embedded; no framework swap.

## Rung 6 — Docs / compose / env documentation

Service docs, compose profile notes, BUILD_OUT handoff clarity.  
Skip `.env` files on denylist — document keys in markdown/compose.

## Rung 7 — True soft-park

Write morning brief: queue empty **after** ladder. Suggest daytime: merge draft PR, LAN smoke opt-in, or new roadmap phases.

## Explore prompt (reuse)

```
Branch HEAD ~<sha>. Recently landed: <bullets>.
Find 3–5 NEW small operator slices NOT in CHANGELOG Unreleased and NOT
fully wired in the web UI. Prefer API-exists-UI-missing or UX bugfixes.
No LAN/FM. Go minimal. Rank: title, files, why, scope.
```

When Explore says saturated, jump to rung 5 — don’t re-Explore the same API list.
