#!/usr/bin/env python3
"""Slopnought — Python fallback for Codex session-start bootstrap."""
import json
import os
import sys

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PLUGIN_ROOT = os.path.dirname(SCRIPT_DIR)

SKILL_FILE = os.path.join(PLUGIN_ROOT, "skills", "slopnought", "SKILL.md")

if not os.path.isfile(SKILL_FILE):
    print(json.dumps({"error": "slopnought skill file not found"}), file=sys.stderr)
    sys.exit(1)

with open(SKILL_FILE, "r", encoding="utf-8") as f:
    skill_content = f.read()

lines = skill_content.split("\n")
body_lines = []
frontmatter_count = 0
for line in lines:
    if line.strip() == "---":
        frontmatter_count += 1
        if frontmatter_count <= 2:
            continue
    if frontmatter_count >= 2:
        body_lines.append(line)
skill_body = "\n".join(body_lines)

bootstrap = f"""<EXTREMELY_IMPORTANT>
You have Slopnought installed.

**IMPORTANT: The slopnought skill content is included below.
It is ALREADY LOADED - you are currently following it.
Do NOT use the skill tool to load "slopnought" again - that would be redundant.**

{skill_body}
</EXTREMELY_IMPORTANT>"""

# Codex uses flat additionalContext
print(json.dumps({"additionalContext": bootstrap}))
