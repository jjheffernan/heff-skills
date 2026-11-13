# Rabbit holes — do not claim overnight

Deny these unless the human explicitly opted in **for this run**.

## Hard denylist

| Hole | Why it burns nights |
|------|---------------------|
| Live Farm Manager / LAN smoke | Needs human network consent; blocks forever without it |
| Merge draft mega-PR to `dev`/`main` | Daytime review; residual risk stacks |
| Frontend stack rewrite (React/Vue/SPA) | Violates lean Go + embedded UI; unbounded |
| Vendor / paste third-party product source | Clean-room + license landmines |
| Bundle Orca binary into images | Size/license; keep `ORCA_BIN` operator-supplied |
| New plugin mega-framework / shared SDK | Prefer one profiled service + thin interface |
| “Just add one more API” when UI gap exists | Inflates surface; wire existing first |
| Full a11y/design-system rewrite | Ship `bfFlash` / danger confirms / density in slices |
| Amending pushed commits / force-push default branch | Safety; after-hours stays additive |
| Editing `.env` / secrets paths | Denylist; document env in compose/service docs only |
| HITL wayfinder / grill-me overnight | after-hours refuses peer chains that need humans |

## Soft denylist (claim only if ladder above is empty)

| Hole | Safer substitute |
|------|------------------|
| Server-side filter perf when client filter works | Skip until measured pain |
| New Admin routes per panel | In-page anchors / `<details>` |
| Replacing `prompt()` everywhere in one PR | One dialog helper + highest-traffic prompts |
| Deep FM feature parity | One control/API at a time behind `ControlPlane` |
| Storing pack/ship / commerce state | Echo/stub OK until product asks |

## Smell test before Explore returns

If the proposed claim needs **two** of {new service, new migration, new compose profile, new auth mode}, split it. Overnight takes the smallest shippable piece.
