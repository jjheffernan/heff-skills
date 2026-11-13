# Wake protocol — one tick / one “go”

## Preconditions

- Branch: build-out draft (e.g. `after-hours/build-out`), tracking remote
- Base: `dev` (or config `baseBranch`) — **do not** merge unless asked
- Constraints from user sticky notes still apply (clean-room Go, skip LAN smoke, etc.)

## Steps

1. **Orient (≤2 min)**  
   `git status -sb`, `git log -1`, handoff table, Unreleased head.

2. **Claim**  
   Claim-ladder + rabbit-hole check. Announce claim only in todos/handoff — chat stays short.

3. **Implement**  
   Minimal files. Match existing patterns (embedded HTML string tests, `bfJSON`, compose profiles).

4. **Verify**  
   Fixture/unit only. Example web:  
   `docker run --rm -v "$PWD:/src" -w /src/services/web -e GOWORK=off golang:1.26-bookworm go test ./...`  
   Rebuild CSS if `input.css` changed.

5. **Record**  
   - `CHANGELOG.md` → correct `[Unreleased]` section (`Added`/`Changed`/`Fixed`)  
   - `docs/BUILD_OUT.md` Session handoff  
   - Avoid mid-list `###` inserts

6. **Publish**  
   Commit (repo style) + push draft PR branch. No merge. No force-push to default.

7. **Continue or park**  
   - More ladder work → say **go** / re-arm sentinel  
   - Ladder empty → soft-park + morning brief note  
   - Human gate → `needs-daylight` + different claim

## Anti-patterns this wake

- Parking because “P0–P6 done” without claim-ladder
- Opening a second PR for the same build-out stack without ask
- Research-only Explore with no land
- Partial changelog that orphans bullets under `### Fixed` / `### Changed`
