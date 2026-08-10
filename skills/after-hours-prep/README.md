# after-hours-prep

Daytime HITL companion for [after-hours-loop](../after-hours-loop/). Builds a thick agent-ready overnight queue via grill-style questions, then hands off to `/after-hours --dry-run`.

**Never arms the AFK loop.**

## Install

```bash
./scripts/install.sh --with-companions /path/to/your/project
```

Or copy `skills/after-hours-prep` into `.agents/skills/after-hours-prep/`.

## Kickoff

```text
/after-hours-prep
```

When ready: paste the printed Sources into `/after-hours --dry-run`, then arm.

Companions are **not** in `drop-in/` sync. See [INSTALL.md](../../INSTALL.md).
