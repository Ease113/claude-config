#!/usr/bin/env bash
# Installs the output styles in this repo into ~/.claude/output-styles (macOS / Linux).
# Usage: ./install.sh            copy styles only
# To enable one, set "outputStyle" in ~/.claude/settings.json or pick it with /output-style.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
dest="$HOME/.claude/output-styles"
mkdir -p "$dest"
for f in "$here"/output-styles/*.md; do
  cp "$f" "$dest/"
  echo "Copied $(basename "$f") -> $dest"
done
