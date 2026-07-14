#!/usr/bin/env bash
# Update an already-installed after-hours-loop skill tree in a target repo.
# Same copy as install.sh — replaces skill dirs only; never touches project config,
# state JSON, or morning brief.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_SH="${SCRIPT_DIR}/install.sh"

DRY_RUN=0
WITH_GITIGNORE=0
WITH_COMPANIONS=0
TARGET_REPO="."
EXPLICIT_COMPANIONS=0

usage() {
  cat <<'EOF'
Usage: ./scripts/update.sh [--dry-run] [--with-gitignore] [--with-companions] [TARGET_REPO]

  Replaces `.agents/skills/after-hours-loop/` from this repo's SoT.
  Preserves:
    - .cursor/after-hours-loop.config.json
    - .cursor/after-hours-loop.state.json
    - .cursor/after-hours-morning-brief.md

  If after-hours-stop / after-hours-handoff are already installed, they are
  updated automatically. Pass --with-companions to install them when missing.

  Skills CLI alternative (from the target project):
    npx skills update after-hours -y
    npx skills update after-hours-stop after-hours-handoff -y   # if installed
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --with-gitignore)
      WITH_GITIGNORE=1
      shift
      ;;
    --with-companions)
      WITH_COMPANIONS=1
      EXPLICIT_COMPANIONS=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -*)
      echo "error: unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
    *)
      TARGET_REPO="$1"
      shift
      ;;
  esac
done

if [[ ! -d "${TARGET_REPO}" ]]; then
  echo "error: TARGET_REPO is not a directory: ${TARGET_REPO}" >&2
  exit 1
fi

TARGET_REPO="$(cd "${TARGET_REPO}" && pwd)"
DEST_LOOP="${TARGET_REPO}/.agents/skills/after-hours-loop"

if [[ ! -d "${DEST_LOOP}" ]]; then
  echo "error: after-hours-loop not installed at ${DEST_LOOP}" >&2
  echo "hint: use ./scripts/install.sh ${TARGET_REPO}  (or npx skills add jjheffernan/heff-skills -a cursor)" >&2
  exit 1
fi

# Refresh companions that are already present (unless user already asked).
if [[ "${EXPLICIT_COMPANIONS}" -eq 0 ]]; then
  if [[ -d "${TARGET_REPO}/.agents/skills/after-hours-stop" ]] \
    || [[ -d "${TARGET_REPO}/.agents/skills/after-hours-handoff" ]]; then
    WITH_COMPANIONS=1
  fi
fi

ARGS=()
[[ "${DRY_RUN}" -eq 1 ]] && ARGS+=(--dry-run)
[[ "${WITH_GITIGNORE}" -eq 1 ]] && ARGS+=(--with-gitignore)
[[ "${WITH_COMPANIONS}" -eq 1 ]] && ARGS+=(--with-companions)
ARGS+=("${TARGET_REPO}")

echo "Update mode: refresh skill tree(s), keep project config/state/brief."
exec "${INSTALL_SH}" "${ARGS[@]}"
