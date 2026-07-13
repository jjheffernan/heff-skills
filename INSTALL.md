# Install — heff-skills

Cursor-first install for **after-hours-loop** (**alpha** — `VERSION` `0.1.0-alpha.2`). Prefer the skills CLI once this repo is cloned or available via registry; clone + `install.sh` remains the explicit alternative. **Do not** treat alpha as a release: cut git tag `v0.1.0` only after dogfood runs.

## Path A — skills CLI (primary)

Requires a top-level `skills/` layout (this repo already has it). From the project where you want the skill installed:

```bash
npx skills add jjheffernan/heff-skills -a cursor
```

Installs into the current project’s Cursor agent skills location. After install, complete the [adapter checklist](#project-adapter-checklist) below.

Use this once the package is available via the skills registry / GitHub (`jjheffernan/heff-skills`). Alpha builds install the same way; expect change until `v0.1.0`.

## Path B — clone + install script (alternative)

From a clone of this repo:

```bash
./scripts/install.sh [--dry-run] [--with-gitignore] [--with-companions] TARGET_REPO
```

- Copies the skill into `TARGET_REPO/.agents/skills/after-hours-loop/`
- Seeds `.cursor/after-hours-loop.config.json` from the example if missing
- `--with-gitignore` appends ignore entries for loop state and morning brief
- `--with-companions` also copies opt-in siblings `after-hours-stop` + `after-hours-handoff` into `.agents/skills/` (not always-on; **not** in drop-in sync)
- `--dry-run` prints what would change without writing

Example:

```bash
./scripts/install.sh --dry-run ~/code/my-app
./scripts/install.sh --with-gitignore ~/code/my-app
./scripts/install.sh --with-companions --with-gitignore ~/code/my-app
```

### Companion micro-skills (opt-in)

| Skill | Role |
|-------|------|
| [`after-hours-stop`](./skills/after-hours-stop/) | Kill sentinel / stop phrases / ensure morning brief |
| [`after-hours-handoff`](./skills/after-hours-handoff/) | Morning-brief focused handoff after a stop |

Default `install.sh` and `sync-drop-in.sh` stay **loop-only**. Companions ship under `skills/` and install only with `--with-companions` (or a manual `cp -R`). They use `disable-model-invocation: true` — never always-on overnight hooks.

## Path C — manual copy

```bash
mkdir -p TARGET_REPO/.agents/skills
cp -R skills/after-hours-loop TARGET_REPO/.agents/skills/after-hours-loop
```

## Path D — generated drop-in

After `scripts/sync-drop-in.sh` has generated `drop-in/` from `skills/` (do not hand-edit drop-in):

```bash
cp -R drop-in/. TARGET_REPO/
```

This mirrors **after-hours-loop** under `.agents/skills/` only. Companion stop/handoff skills are **not** generated into `drop-in/` — use Path B with `--with-companions` or copy from `skills/` manually.

---

## Project adapter checklist

Do this once per target project:

1. **Config** — copy the example and edit:

   ```bash
   cp skills/after-hours-loop/templates/config.example.json \
     TARGET_REPO/.cursor/after-hours-loop.config.json
   ```

   (Equivalently under `docs/agents/` if your team keeps agent config there — stay consistent. Skills CLI installs may already place the skill tree; still ensure a project config exists.)

2. **Set at least**:
   - `repo` — GitHub `owner/name`
   - `baseBranch` — e.g. `main` (or your default)
   - `testCommand` — command the loop can run to verify
   - `packageManager` — e.g. `npm` / `pnpm` / `yarn` / `bun`

3. **Gitignore session artifacts** (`--with-gitignore` or paste from [`templates/gitignore.snippet`](./skills/after-hours-loop/templates/gitignore.snippet)):

   ```gitignore
   .cursor/after-hours-loop.state.json
   .cursor/after-hours-morning-brief.md
   ```

4. Confirm `gh` auth and a clean tree before arming an overnight run.

5. **Optional Cursor rule** (not always-on) — copy `skills/after-hours-loop/templates/cursor-rule.after-hours-loop.mdc.example` to `TARGET_REPO/.cursor/rules/after-hours-loop.mdc` so `/after-hours` can point at `.agents/skills/after-hours-loop/SKILL.md`; leave `alwaysApply: false`.

---

## Uninstall

1. Stop any running `/loop` / Automation / sentinel for after-hours.
2. Remove the skill directory:

   ```bash
   rm -rf TARGET_REPO/.agents/skills/after-hours-loop
   rm -rf TARGET_REPO/.agents/skills/after-hours-stop
   rm -rf TARGET_REPO/.agents/skills/after-hours-handoff
   ```

3. Optionally delete local state and config:

   ```bash
   rm -f TARGET_REPO/.cursor/after-hours-loop.state.json
   rm -f TARGET_REPO/.cursor/after-hours-morning-brief.md
   rm -f TARGET_REPO/.cursor/after-hours-loop.config.json
   ```

4. Drop any gitignore lines you added solely for those files if unused.

---

## Kickoff examples

First overnight walkthrough: [docs/first-night.md](./docs/first-night.md).

Primary slash command (preferred):

```text
/after-hours 45m
Sources:
  - github-issues: label ready-for-agent limit 5
  - todo-md: section "Now"
maxPrs: 3
priority: github-first
```

Dry-run before arming: `/after-hours --dry-run` with the same Sources block.

Night Sources presets: [`night-Sources.github.txt`](./skills/after-hours-loop/templates/night-Sources.github.txt), [`night-Sources.mixed.txt`](./skills/after-hours-loop/templates/night-Sources.mixed.txt).

Built-in `/loop` + skill path (equivalent):

```text
/loop 45m Follow .agents/skills/after-hours-loop/SKILL.md
Sources:
  - github-issues: label ready-for-agent limit 5
  - todo-md: section "Now"
maxPrs: 3
priority: github-first
```

Stop: `stop after-hours` or `stop loop`.

See [docs/portability.md](./docs/portability.md) for what hosts are supported in v1.

---

## Maintainer

Edit **`skills/`** only (source of truth). Before commit, run `./scripts/sync-drop-in.sh` so `drop-in/` stays generated and in sync. CI runs `./scripts/check-drop-in-sync.sh` and fails on drift — do not hand-edit `drop-in/`.

Version: see root [`VERSION`](./VERSION) and [`CHANGELOG.md`](./CHANGELOG.md). Current line is **alpha** (`0.1.0-alpha.2`); tag `v0.1.0` only when publishing a stable release.

Automation (office hours close): [docs/automation.md](./docs/automation.md).
