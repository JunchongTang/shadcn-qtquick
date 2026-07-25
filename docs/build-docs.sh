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

# Locate the Qt .index docs so inherited/referenced Qt types cross-link to
# doc.qt.io (see the `depends` line in shadcn.qdocconf). The indexed Qt docs
# usually live under ~/Qt/Docs/Qt-<ver>, NOT under the kit's own doc/ (which
# only carries the HTML templates). Override with QT_DOCS_INDEX=/path.
find_index_dir() {
  local qt_root cand
  qt_root="$(cd "$QT_KIT/../.." && pwd)"   # e.g. ~/Qt  (from ~/Qt/<ver>/<platform>)
  for cand in "${QT_DOCS_INDEX:-}" "$qt_root/Docs/Qt-$QT_VERSION" "$qt_root"/Docs/Qt-* "$QT_INSTALL_DOCS"; do
    [[ -n "$cand" && -f "$cand/qtquick/qtquick.index" ]] && { echo "$cand"; return 0; }
  done
  return 1
}

OUT="$REPO_ROOT/docs/api/html"
rm -rf "$REPO_ROOT/docs/api"
mkdir -p "$OUT"

INDEX_ARGS=()
if INDEX_DIR="$(find_index_dir)"; then
  INDEX_ARGS=(--indexdir "$INDEX_DIR")
  echo "Cross-linking Qt types via index dir: $INDEX_DIR"
else
  echo "Note: no Qt .index dir found; inherited Qt types will render as plain text." >&2
  echo "      Install the Qt documentation, or set QT_DOCS_INDEX=/path/to/Qt/Docs/Qt-$QT_VERSION" >&2
fi

"$QT_KIT/bin/qdoc" "$REPO_ROOT/docs/shadcn.qdocconf" --outputdir "$OUT" "${INDEX_ARGS[@]}"

echo "Docs generated at: $OUT"
echo "Open: $OUT/shadcn-qmlmodule.html"
