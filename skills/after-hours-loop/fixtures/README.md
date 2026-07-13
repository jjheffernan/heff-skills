# State fixtures

Sample `.cursor/after-hours-loop.state.json` shapes for `scripts/validate-state.py`.

| File | Expected |
|------|----------|
| `sample-state.valid.json` | Exit 0 (`ok`) — schema v1, one `open` queue item, empty `prs` |
| `sample-state.invalid-prs.json` | Exit 1 — `prs` is a string array (must be objects with `url`) |
| `sample-state.invalid-status.json` | Exit 1 — `queue[].status` not in allowed set |

**Out of scope here:** parse / priority / write-back harnesses (Sources materialization) — still a Phase 5 stretch; these fixtures cover schema validation only.

From the heff-skills repo root:

```bash
python3 scripts/validate-state.py skills/after-hours-loop/fixtures/sample-state.valid.json
```

Expect `ok`. Invalid fixtures should exit nonzero with a clear `validate-state:` message.
