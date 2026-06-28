#!/usr/bin/env bash
# Slopnought — Antigravity (agy) installer
# Creates a staging directory with the manifest, skills, and a generated
# ANTIGRAVITY.md context file, then runs `agy plugin install` against it.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$SCRIPT_DIR"

SKILL_FILE="${PLUGIN_ROOT}/skills/slopnought/SKILL.md"
TOOL_MAP_FILE="${PLUGIN_ROOT}/skills/slopnought/references/antigravity-tools.md"
MANIFEST="${PLUGIN_ROOT}/antigravity-plugin/plugin.json"

if [ ! -f "$SKILL_FILE" ]; then
  echo "Error: SKILL.md not found at $SKILL_FILE" >&2
  exit 1
fi

if [ ! -f "$MANIFEST" ]; then
  echo "Error: plugin.json not found at $MANIFEST" >&2
  exit 1
fi

# Create staging directory
STAGING_DIR=$(mktemp -d)
trap 'rm -rf "$STAGING_DIR"' EXIT

echo "Building Antigravity plugin in staging directory..."

# Copy skills directory
cp -r "${PLUGIN_ROOT}/skills" "${STAGING_DIR}/skills"

# Copy assets if they exist
if [ -d "${PLUGIN_ROOT}/skills/slopnought/assets" ]; then
  : # Already copied with skills/
fi

# Read skill content and strip YAML frontmatter
SKILL_CONTENT=$(cat "$SKILL_FILE")
SKILL_BODY=$(echo "$SKILL_CONTENT" | sed '1,/^---$/d' | sed '1,/^---$/d')

# Read tool mapping
TOOL_MAP=""
if [ -f "$TOOL_MAP_FILE" ]; then
  TOOL_MAP=$(cat "$TOOL_MAP_FILE")
fi

# Generate ANTIGRAVITY.md with bootstrap wrapped in EXTREMELY_IMPORTANT
cat > "${STAGING_DIR}/ANTIGRAVITY.md" << BOOTSTRAP
<EXTREMELY_IMPORTANT>
You have Slopnought installed.

**IMPORTANT: The slopnought skill content is included below.
It is ALREADY LOADED - you are currently following it.
Do NOT use the skill tool to load "slopnought" again - that would be redundant.**

${SKILL_BODY}

${TOOL_MAP}
</EXTREMELY_IMPORTANT>
BOOTSTRAP

# Copy manifest
cp "$MANIFEST" "${STAGING_DIR}/plugin.json"

echo "Staging directory ready at: $STAGING_DIR"
echo "Running: agy plugin install $STAGING_DIR"

# Install via agy
if command -v agy &>/dev/null; then
  agy plugin install "$STAGING_DIR"
  echo "Slopnought installed for Antigravity."
else
  echo "Warning: 'agy' not found in PATH." >&2
  echo "To install manually, run:" >&2
  echo "  agy plugin install $STAGING_DIR" >&2
  echo "Or copy the staging directory contents to your Antigravity plugins directory." >&2
fi
