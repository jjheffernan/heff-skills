---
name: after-hours-buildout
description: >
  Companion to after-hours-loop for multi-session build-outs: refill an empty
  queue from a roadmap claim-ladder, recover from soft-parks/stalls, and avoid
  rabbit holes (LAN smoke, frontend rewrites, API invention). Trigger on
  /after-hours-buildout, empty-queue park, "go" wakes on a draft build-out PR,
  STOP PARKING, or when BUILD_OUT / feature-spec phases look done but polish remains.
disable-model-invocation: true
license: MIT
---

# after-hours-buildout (companion)

Thin companion to **after-hours-loop**. Does **not** replace Sources → executors →
outcomes. It answers: *what to claim next when the formal queue is empty*, and
*how to unstick without digging a hole*.

Pair with: `after-hours-loop`, `after-hours-stop`, `after-hours-handoff`, project
`docs/BUILD_OUT.md` (or equivalent roadmap).

## Load map

| Doc | When |
|-----|------|
| [references/stalls.md](./references/stalls.md) | Soft-park, empty queue, blocked, thrash |
| [references/rabbit-holes.md](./references/rabbit-holes.md) | Denylist before claiming |
| [references/claim-ladder.md](./references/claim-ladder.md) | What to pick when phases look “done” |
| [references/wake-protocol.md](./references/wake-protocol.md) | Single “go” / sentinel tick |
| [references/bambufarmer-map.md](./references/bambufarmer-map.md) | Example roadmap map (copy/adapt per repo) |


## Path notes

Canon for the orchestrator: resolve `after-hours-loop` as:

| Layout | Base |
|--------|------|
| Repo SoT (sibling) | `../after-hours-loop/` |
| Installed project | `.agents/skills/after-hours-loop/` (or `.agents/skills/after-hours/`) |

## When to use

- After-hours soft-parked with `parkedReason: empty-queue` but handoff **Next** still has work
- User says **go** / STOP PARKING / keep draining a draft build-out PR
- Feature-spec P0–Pn marked done; agent is about to invent large new backends
- Morning brief says “ready queue empty” while polish / UX / wiring gaps remain

## Do not use for

- Starting a brand-new overnight loop (use **after-hours-loop**)
- Killing the sentinel (use **after-hours-stop**)
- Daytime merge / LAN smoke that needs a human (park as `needs-daylight`, don’t loop)

## Hard rules (sprint-learned)

1. **Empty formal queue ≠ stop.** Refill from [claim-ladder](./references/claim-ladder.md) before soft-parking.
2. **One vertical slice per wake.** Ship: code + tests + `CHANGELOG` `[Unreleased]` + roadmap handoff (+ push if that is the repo’s after-hours norm).
3. **Prefer API-exists-UI-missing** over new endpoints once the control plane is wired.
4. **Defer human-gated work** (LAN, secrets, merge-to-default) — never busy-loop on it.
5. **No stack rewrites overnight** (no React/Vue migration, no vendoring third-party product trees, no “temporary” Python services).
6. **Changelog edits are surgical.** Never insert a new `###` section in the middle of an existing bullet list (common StrReplace foot-gun).

## Minimal wake (copy into ticks)

```
1. Read BUILD_OUT Session handoff + CHANGELOG [Unreleased] head
2. git status; confirm branch / draft PR target (usually not main)
3. Classify: blocked-human | claim-next | soft-park-only-if-ladder-empty
4. Explore for ONE claim (see claim-ladder); skip rabbit-holes.md matches
5. Implement minimal slice → unit/fixture tests only → changelog → handoff
6. Push to draft PR branch if that is configured; do not merge unless asked
7. Chat: one line landed + "Say go for more" (or arm sentinel per after-hours)
```

## Stall triage (30 seconds)

| Signal | Action |
|--------|--------|
| `empty-queue` / “nothing left” | Run claim-ladder; **do not** park if any rung has work |
| Waiting on LAN / FM live smoke | Mark `needs-daylight`; switch to fixture/UI/docs slice |
| Same file thrash >2 wakes | Shrink scope or switch surface; log in handoff **Blocked** |
| Explore returns only “saturated” | Drop to UX ergonomics rung; then true soft-park |
| Tests need Docker/`all` perms | Request once; don’t invent a second toolchain |
| Dirty tree / auth weakening | Stop per after-hours guardrails — not a polish continue |

## Outcome

Every wake updates roadmap **Session handoff** (`Done` / `Next` / `Blocked` / `Deferred`).  
Every stop still writes the after-hours **morning brief**.
