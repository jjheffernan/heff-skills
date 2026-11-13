# Stalls — detect and recover

## Soft-park vs hard stop

| Kind | Meaning | Sentinel |
|------|---------|----------|
| Soft-park | Temporary; refill queue or wait for next tick | Keep armed |
| Hard stop | User stop / guardrail / consecutive blocked | Kill; write morning brief |

**Bug from dogfood:** treating “feature-spec phases complete” as empty-queue soft-park while UI polish and API→UI gaps remained. Fix: claim-ladder before park.

## Stall taxonomy

### 1. False empty queue

**Looks like:** Sources return nothing; `parkedReason: empty-queue`.  
**Actually:** Roadmap handoff **Next**, Unreleased gaps, or Explore finds API-without-UI.  
**Recover:** Run claim-ladder top-down. Only soft-park if every rung is empty.

### 2. Human-gated (needs daylight)

**Looks like:** Live hardware smoke, merge approval, secrets, OIDC IdP.  
**Recover:** One brief bullet under handoff **Blocked** / morning **Needs daylight**. Claim a fixture/UI/docs slice instead. Never retry LAN in a loop.

### 3. Verification thrash

**Looks like:** Same test failing; sandbox/permission flips; CSS not rebuilt.  
**Recover:**
- Go services: prefer `docker run golang:… go test` with `GOWORK=off` when host Go mismatches.
- Web CSS: edit `input.css` then `make web-css` / `npm run build:css`; commit `app.css`.
- One permission escalation (`all` / network), then proceed — don’t invent alternate stacks.

### 4. Scope creep mid-wake

**Looks like:** “While I’m here” backend + UI + docs mega-diff.  
**Recover:** Cut to one vertical slice; park the rest on handoff **Next** as separate claims.

### 5. Saturation blindness

**Looks like:** “Every API is wired.”  
**Recover:** Drop claim-ladder to field-level / UX / a11y rungs. If those are empty, *then* soft-park.

### 6. Changelog / handoff rot

**Looks like:** Bullets under wrong `###` section; handoff stale.  
**Recover:** Read full `[Unreleased]` headers before edit; append bullets under the correct section only; update handoff every wake.

## Unpark checklist

- [ ] Read Session handoff **Next** and **Deferred**
- [ ] Skim last 15 Unreleased bullets (avoid dupes)
- [ ] Claim-ladder rung identified + rabbit-hole check
- [ ] Single slice scoped (files ≤ ~3 conceptual areas)
- [ ] Tests that don’t need LAN
- [ ] Changelog + handoff updated
