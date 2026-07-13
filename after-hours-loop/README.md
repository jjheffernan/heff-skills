# after-hours-loop (portable)

Modular overnight / late-session agent loop: pluggable **work sources** + **executors** → PRs.

Part of **heff-skills**. Exported from cosmic-themes-starter (2026-07-13).

## Layout

| Path | Use |
|------|-----|
| `skill/` | Raw skill (copy → `.agents/skills/after-hours-loop/`) |
| `docs/glossary.md` | Ubiquitous language + bootstrap examples |
| `drop-in/` | Pre-wired tree — copy *contents* onto a project root |

Needs Cursor built-in `/loop`. Optional: ponytail / ponytail-debug (referenced, not bundled).

## Add to a project

```bash
PKG="/Users/jjheffernan/Dev/Projects/Personal/heff-skills/after-hours-loop"
REPO="/path/to/your/project"

cp -R "$PKG/skill" "$REPO/.agents/skills/after-hours-loop"
mkdir -p "$REPO/docs/agents"
cp "$PKG/docs/glossary.md" "$REPO/docs/agents/after-hours-loop.md"
```

Or:

```bash
cp -R "$PKG/drop-in/." "$REPO/"
```

Then:

1. **`.gitignore`**:

   ```gitignore
   .cursor/after-hours-loop.state.json
   ```

2. Search-replace repo-specific bits:

   | File | Change |
   |------|--------|
   | `sources/github-issues.md` | `--repo owner/name` |
   | `SKILL.md` (Automation section) | Repo slug + base branch |
   | `executors/pr-slice.md` | Base branch if not `dev`; soften/remove ponytail links if missing |
   | `docs/agents/after-hours-loop.md` | Example repo / branch |

3. Kickoff:

   ```text
   /loop 45m Follow .agents/skills/after-hours-loop/SKILL.md
   Sources:
     - github-issues: label ready-for-agent limit 5
     - todo-md: section "Now"
   maxPrs: 3
   priority: github-first
   ```

## New skills repo

```bash
cd /Users/jjheffernan/Dev/Projects/Personal/heff-skills
git init
```

Keep one folder per skill (`after-hours-loop/`, …).

## Not included

- Target-repo `TODO.md`, domain subagents, ponytail
- Live `.cursor/after-hours-loop.state.json` (session-local)
