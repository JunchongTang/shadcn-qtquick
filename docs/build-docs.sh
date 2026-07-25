#!/usr/bin/env bash
# Generate the ShadcnQtQuick API docs (HTML) from the QML \qmltype comments.
#
# Usage:  docs/build-docs.sh  [/path/to/Qt/<ver>/<platform>]
# Output: docs/api/html/index.html  (open shadcn-qmlmodule.html for the module page)
#
# The generated HTML is a build artifact and is gitignored (see .gitignore).
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
QT_KIT="${1:-$HOME/Qt/6.8.6/macos}"

if [[ ! -d "$QT_KIT" ]]; then
  echo "Qt kit not found: $QT_KIT" >&2
  echo "Pass the kit path, e.g. docs/build-docs.sh ~/Qt/6.8.6/macos" >&2
  exit 1
fi

export QT_INSTALL_DOCS="$QT_KIT/doc"
export QT_VER=6.8
export QT_VERSION=6.8.6
export QT_VERSION_TAG=686
export BUILDDIR=.

OUT="$REPO_ROOT/docs/api/html"
rm -rf "$REPO_ROOT/docs/api"
mkdir -p "$OUT"

"$QT_KIT/bin/qdoc" "$REPO_ROOT/docs/shadcn.qdocconf" --outputdir "$OUT"

echo "Docs generated at: $OUT"
echo "Open: $OUT/shadcn-qmlmodule.html"
