#!/usr/bin/env bash
# Fail if generated drop-in/ has drifted from skills/after-hours-loop/ SoT.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

SOT="${ROOT_DIR}/skills/after-hours-loop"
DROP_IN_SKILL="${ROOT_DIR}/drop-in/.agents/skills/after-hours-loop"
DROP_IN_DOCS="${ROOT_DIR}/drop-in/docs/agents/after-hours-loop.md"
POINTER="${SOT}/templates/drop-in-docs-pointer.md"

failed=0

if [[ ! -d "${SOT}" ]]; then
  echo "error: source of truth missing: ${SOT}" >&2
  exit 1
fi

if [[ ! -d "${DROP_IN_SKILL}" ]]; then
  echo "error: drop-in skill missing: ${DROP_IN_SKILL}" >&2
  echo "hint: run ./scripts/sync-drop-in.sh" >&2
  exit 1
fi

echo "Comparing skill trees:"
echo "  ${SOT}"
echo "  ${DROP_IN_SKILL}"

if ! diff -rq "${SOT}" "${DROP_IN_SKILL}"; then
  echo "error: drop-in skill tree differs from skills/after-hours-loop" >&2
  echo "hint: run ./scripts/sync-drop-in.sh and commit drop-in/" >&2
  failed=1
else
  echo "ok: skill trees match"
fi

if [[ -f "${POINTER}" && -f "${DROP_IN_DOCS}" ]]; then
  echo "Comparing docs pointer:"
  echo "  ${POINTER}"
  echo "  ${DROP_IN_DOCS}"
  if ! diff -q "${POINTER}" "${DROP_IN_DOCS}" >/dev/null; then
    echo "error: drop-in docs pointer differs from templates/drop-in-docs-pointer.md" >&2
    echo "hint: run ./scripts/sync-drop-in.sh and commit drop-in/" >&2
    failed=1
  else
    echo "ok: docs pointer matches"
  fi
elif [[ -f "${POINTER}" && ! -f "${DROP_IN_DOCS}" ]]; then
  echo "error: pointer exists but drop-in docs missing: ${DROP_IN_DOCS}" >&2
  echo "hint: run ./scripts/sync-drop-in.sh" >&2
  failed=1
fi

if [[ "${failed}" -ne 0 ]]; then
  exit 1
fi

echo "done: drop-in in sync"
