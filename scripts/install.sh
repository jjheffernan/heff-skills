#!/usr/bin/env bash
# Install after-hours-loop into a target Cursor / Agent Skills repo.
# Optionally install companion micro-skills with --with-companions.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

SOT="${ROOT_DIR}/skills/after-hours-loop"
CONFIG_EXAMPLE="${SOT}/templates/config.example.json"
COMPANIONS=(after-hours-stop after-hours-handoff)

DRY_RUN=0
WITH_GITIGNORE=0
WITH_COMPANIONS=0
TARGET_REPO="."

usage() {
  cat <<'EOF'
Usage: ./scripts/install.sh [--dry-run] [--with-gitignore] [--with-companions] [TARGET_REPO]

  TARGET_REPO         Destination repo root (default: .)
  --dry-run           Print actions only; do not write files
  --with-gitignore    Append ignore entries for loop state + morning brief if missing
  --with-companions   Also copy after-hours-stop + after-hours-handoff into .agents/skills/
                      (opt-in; not part of drop-in sync)
EOF
}

install_skill_dir() {
  local name="$1"
  local src="${ROOT_DIR}/skills/${name}"
  local dest="${TARGET_REPO}/.agents/skills/${name}"

  if [[ ! -d "${src}" ]]; then
    echo "error: companion source missing: ${src}" >&2
    exit 1
  fi

  if [[ "${DRY_RUN}" -eq 1 ]]; then
    echo "dry-run: mkdir -p $(dirname "${dest}")"
    echo "dry-run: rm -rf ${dest}"
    echo "dry-run: cp -R ${src} ${dest}"
  else
    mkdir -p "$(dirname "${dest}")"
    rm -rf "${dest}"
    cp -R "${src}" "${dest}"
    echo "Copied skill → ${dest}"
  fi
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

if [[ ! -d "${SOT}" ]]; then
  echo "error: source of truth missing: ${SOT}" >&2
  exit 1
fi

if [[ ! -d "${TARGET_REPO}" ]]; then
  echo "error: TARGET_REPO is not a directory: ${TARGET_REPO}" >&2
  exit 1
fi

TARGET_REPO="$(cd "${TARGET_REPO}" && pwd)"
DEST_SKILL="${TARGET_REPO}/.agents/skills/after-hours-loop"
DEST_CONFIG="${TARGET_REPO}/.cursor/after-hours-loop.config.json"
GITIGNORE="${TARGET_REPO}/.gitignore"

IGNORE_STATE=".cursor/after-hours-loop.state.json"
IGNORE_BRIEF=".cursor/after-hours-morning-brief.md"

echo "Install target: ${TARGET_REPO}"
echo "SoT: ${SOT}"

if [[ "${DRY_RUN}" -eq 1 ]]; then
  echo "dry-run: mkdir -p $(dirname "${DEST_SKILL}")"
  echo "dry-run: rm -rf ${DEST_SKILL}"
  echo "dry-run: cp -R ${SOT} ${DEST_SKILL}"
else
  mkdir -p "$(dirname "${DEST_SKILL}")"
  rm -rf "${DEST_SKILL}"
  cp -R "${SOT}" "${DEST_SKILL}"
  echo "Copied skill → ${DEST_SKILL}"
fi

if [[ "${WITH_COMPANIONS}" -eq 1 ]]; then
  for companion in "${COMPANIONS[@]}"; do
    install_skill_dir "${companion}"
  done
fi

if [[ -f "${CONFIG_EXAMPLE}" ]]; then
  if [[ -f "${DEST_CONFIG}" ]]; then
    echo "skip config: already present at ${DEST_CONFIG}"
  else
    if [[ "${DRY_RUN}" -eq 1 ]]; then
      echo "dry-run: mkdir -p $(dirname "${DEST_CONFIG}")"
      echo "dry-run: cp ${CONFIG_EXAMPLE} ${DEST_CONFIG}"
    else
      mkdir -p "$(dirname "${DEST_CONFIG}")"
      cp "${CONFIG_EXAMPLE}" "${DEST_CONFIG}"
      echo "Copied config → ${DEST_CONFIG}"
    fi
  fi
else
  echo "skip config: no ${CONFIG_EXAMPLE}"
fi

if [[ "${WITH_GITIGNORE}" -eq 1 ]]; then
  ensure_gitignore_line() {
    local line="$1"
    if [[ -f "${GITIGNORE}" ]] && grep -qxF -- "${line}" "${GITIGNORE}"; then
      echo "skip gitignore: already has ${line}"
      return
    fi
    if [[ "${DRY_RUN}" -eq 1 ]]; then
      echo "dry-run: append ${line} → ${GITIGNORE}"
    else
      if [[ ! -f "${GITIGNORE}" ]]; then
        : > "${GITIGNORE}"
      elif [[ -s "${GITIGNORE}" ]] && [[ "$(tail -c 1 "${GITIGNORE}" | wc -l)" -eq 0 ]]; then
        printf '\n' >> "${GITIGNORE}"
      fi
      printf '%s\n' "${line}" >> "${GITIGNORE}"
      echo "Appended to .gitignore: ${line}"
    fi
  }

  ensure_gitignore_line "${IGNORE_STATE}"
  ensure_gitignore_line "${IGNORE_BRIEF}"
fi

cat <<EOF

Next steps:
  1. Configure ${DEST_CONFIG} (repo, baseBranch, testCommand, packageManager).
  2. Run /after-hours with a Sources block.
     See ${DEST_SKILL}/templates/Sources.example.txt
EOF

if [[ "${WITH_COMPANIONS}" -eq 1 ]]; then
  cat <<EOF
  3. Companions installed: after-hours-stop, after-hours-handoff
     (opt-in stop / morning-brief handoff — not always-on).
EOF
fi
