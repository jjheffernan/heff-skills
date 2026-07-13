# State fixtures

Sample `.cursor/after-hours-loop.state.json` shapes for `scripts/validate-state.py`.

| File | Expected |
|------|----------|
| `sample-state.valid.json` | Exit 0 (`ok`) — schema v1, one `open` queue item, empty `prs` |
| `sample-state.invalid-prs.json` | Exit 1 — `prs` is a string array (must be objects with `url`) |

From the heff-skills repo root:

```bash
python3 scripts/validate-state.py skills/after-hours-loop/fixtures/sample-state.valid.json
```

Expect `ok`. The invalid fixture should fail with a message that `prs[0]` must be an object.
