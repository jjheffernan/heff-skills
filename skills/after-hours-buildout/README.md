# after-hours-buildout

Companion for [after-hours-loop](../after-hours-loop/). Refills an empty overnight queue from a roadmap claim-ladder, recovers from false soft-parks, and denylists rabbit holes (LAN smoke, SPA rewrites, inventing APIs when UI gaps remain).

**Does not arm the AFK loop.** Load on empty-queue park or `/after-hours-buildout` / “go” wakes on a build-out draft PR.

## Install

```bash
./scripts/install.sh --with-companions /path/to/your/project
```

Or copy `skills/after-hours-buildout` into `.agents/skills/after-hours-buildout/`.

## Kickoff

```text
/after-hours-buildout
```

Or from a soft-park wake: follow `references/claim-ladder.md` before setting `parkedReason: empty-queue`.

Companions are **not** in `drop-in/` sync. See [INSTALL.md](../../INSTALL.md).
