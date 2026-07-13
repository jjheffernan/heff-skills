# State fixtures

Sample `.cursor/after-hours-loop.state.json` shapes for `scripts/validate-state.py`.

| File | Expected |
|------|----------|
| `sample-state.valid.json` | Exit 0 (`ok`) — schema v1, one `open` queue item, empty `prs` |
| `sample-state.invalid-prs.json` | Exit 1 — `prs` is a string array (must be objects with `url`) |
| `sample-state.invalid-status.json` | Exit 1 — `queue[].status` not in allowed set |
| `sample-state.invalid-stopReason.json` | Exit 1 — `stopReason` not in `{done, blocked, noop, budget}` |
| `sample-state.invalid-megaPr.json` | Exit 1 — `megaPr` is a non-boolean (must be bool when set) |

**Deferred (not validated by `validate-state.py` yet):** `priority` enum (`github-first` \| `fifo` \| `todo-first` per [state-schema.md](../references/state-schema.md)). No `sample-state.invalid-priority.json` until the validator enforces it. Valid fixtures may still use `priority: github-first`.

From the heff-skills repo root:

```bash
python3 scripts/validate-state.py skills/after-hours-loop/fixtures/sample-state.valid.json
```

Expect `ok`. Invalid fixtures should exit nonzero with a clear `validate-state:` message.

## Harness expectations (stubs OK)

These are **documented contracts** for a future parse / priority / write-back harness. Schema fixtures above do **not** assert them yet.

### Parse (Sources → queue)

A future harness would assert:

1. Each Sources line maps to a `sources/*.md` module and materializes portable queue fields (`id`, `title`, `acceptance`, `blockerPolicy`, `executorHint`, `outcomeKind`).
2. Invalid / unknown source types fail closed or materialize `blocked` with reason — never invent tracker IDs.
3. Readiness: non-ready items become `blocked` (or omit) with a reason listable in the morning brief.
4. Round-trip: fixture Sources text → queue JSON matches golden shapes (ids, executor binding, no silent drop).

### Priority

A future harness would assert:

1. `priority: github-first` drains `github-issues` / `github-tickets` before `todo-md` / `feature-spec`.
2. `fifo` preserves materialization order across sources.
3. `todo-first` drains TODO before GitHub when both are present.
4. Unknown `priority` values: once `validate-state.py` enforces the enum, invalid fixture exit 1; until then, orchestrator should treat unknown as `github-first` and note in brief (harness documents expected soft-default).

### Write-back

A future harness would assert:

1. **TODO auto check-off:** on `done` for a `todo-md` item, the same PR branch (or doc commit path) flips matching `- [ ]` → `- [x]` — no silent skip of write-back when the source module promises it.
2. **Idempotency:** re-running write-back on an already-checked line is a no-op (no duplicate edits / churn).
3. **No cross-source mutation:** GitHub / feature-spec completion does not rewrite unrelated TODO sections.
4. **Outcomes without PR:** `doc-artifact` / `report-only` / `ops-checklist` nights record notes / brief pointers without inventing a draft PR for write-back alone.
