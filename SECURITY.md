# Security

## No telemetry

This repository does not phone home. There is no analytics, usage reporting, or remote “check for updates” in the skill pack itself.

## What you install

**after-hours-loop** is prompts (markdown skill + references) and optional **local** helper scripts. Behavior runs inside your Cursor agent session and whatever commands *you* (or the agent under your policy) invoke.

## Install surface

`scripts/install.sh` is intended to write only into the **target project**:

- `.agents/skills/after-hours-loop/` (skill copy)
- Optional printed **gitignore hints** for local state / morning brief paths

It should not modify global Cursor settings, install browser extensions, or open network connections.

## Network

Network use is **opt-in by your tooling**, not by this pack:

- `gh` — only if you run GitHub CLI (auth, issues, PRs)
- `npx skills add …` — only if you choose the skills CLI install path
- Test / package commands from your project config — only when the agent runs them for you

The skill does not require a heff-skills server, account, or beacon.

## Trust boundary

Treat overnight loops like any unattended agent: use draft PRs, keep secrets out of the tree, and review the morning brief before merging.
