#!/usr/bin/env bash
# Generate drop-in/ from the canonical skills/after-hours-loop/ source of truth.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

SOT="${ROOT_DIR}/skills/after-hours-loop"
DROP_IN_SKILL="${ROOT_DIR}/drop-in/.agents/skills/after-hours-loop"
DROP_IN_DOCS="${ROOT_DIR}/drop-in/docs/agents/after-hours-loop.md"

if [[ ! -d "${SOT}" ]]; then
  echo "error: source of truth missing: ${SOT}" >&2
  exit 1
fi

echo "SoT: ${SOT}"
echo "Wiping: ${DROP_IN_SKILL}"
rm -rf "${DROP_IN_SKILL}"
mkdir -p "$(dirname "${DROP_IN_SKILL}")"

echo "Copying skill → ${DROP_IN_SKILL}"
cp -R "${SOT}" "${DROP_IN_SKILL}"

DOCS_SRC=""
DROP_IN_DOCS="${ROOT_DIR}/drop-in/docs/agents/after-hours-loop.md"
POINTER="${SOT}/templates/drop-in-docs-pointer.md"

mkdir -p "$(dirname "${DROP_IN_DOCS}")"
if [[ -f "${POINTER}" ]]; then
  cp "${POINTER}" "${DROP_IN_DOCS}"
  echo "Copied docs pointer: ${POINTER} → ${DROP_IN_DOCS}"
  DOCS_SRC="${POINTER}"
elif [[ -f "${SOT}/docs/glossary.md" ]]; then
  cp "${SOT}/docs/glossary.md" "${DROP_IN_DOCS}"
  echo "Copied docs: ${SOT}/docs/glossary.md → ${DROP_IN_DOCS}"
  DOCS_SRC="${SOT}/docs/glossary.md"
else
  echo "skip docs: no pointer or glossary"
fi

echo "Synced:"
echo "  ${SOT}/ → ${DROP_IN_SKILL}/"
if [[ -n "${DOCS_SRC}" ]]; then
  echo "  ${DOCS_SRC} → ${DROP_IN_DOCS}"
fi
echo "done."
