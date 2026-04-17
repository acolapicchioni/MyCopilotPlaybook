#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_FILE="$ROOT_DIR/copilot-instructions.md"

if [[ ! -f "$SOURCE_FILE" ]]; then
  echo "Error: $SOURCE_FILE not found" >&2
  exit 1
fi

cp "$SOURCE_FILE" "$ROOT_DIR/CLAUDE.md"
cp "$SOURCE_FILE" "$ROOT_DIR/AGENTS.md"
cp "$SOURCE_FILE" "$ROOT_DIR/GEMINI.md"

mkdir -p "$ROOT_DIR/.github"
cp "$SOURCE_FILE" "$ROOT_DIR/.github/copilot-instructions.md"

echo "Synced copilot instructions to CLAUDE.md, AGENTS.md, GEMINI.md, and .github/copilot-instructions.md"
