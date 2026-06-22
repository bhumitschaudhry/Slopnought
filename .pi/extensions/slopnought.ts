// Slopnought — Pi extension module
// Injects bootstrap context via the `context` event per turn.
// Skills registered via `resources_discover` → {skillPaths}.

import * as fs from "fs";
import * as path from "path";

const PLUGIN_ROOT = path.resolve(import.meta.dirname, "..", "..");
const SKILL_DIR = path.join(PLUGIN_ROOT, "skills", "slopnought");
const SKILL_FILE = path.join(SKILL_DIR, "SKILL.md");
const TOOL_MAP_FILE = path.join(SKILL_DIR, "references", "pi-tools.md");

const BOOTSTRAP_MARKER = "SLOPNOUGHT_BOOTSTRAP_INJECTED";

let cachedBootstrap: string | null = null;
let injectBootstrap = false;

const toolMapping = {
  "Read a file": "read",
  "Edit a file": "edit",
  "Run a shell command": "bash",
  "Search files by content": "grep",
  "Search files by name": "find",
  "Create/update todos": "plan file / TODO.md",
  "Dispatch a subagent": "(none — work in-session)",
  "Fetch a URL": "fetch",
  "Ask user a question": "text",
  "Invoke a skill": "read SKILL.md directly",
};

function piToolMapping(): string {
  return Object.entries(toolMapping)
    .map(([action, tool]) => `- ${action} → ${tool}`)
    .join("\n");
}

function buildBootstrap(): string | null {
  if (cachedBootstrap) return cachedBootstrap;

  if (!fs.existsSync(SKILL_FILE)) {
    console.error("slopnought: SKILL.md not found at", SKILL_FILE);
    return null;
  }

  let skillContent = fs.readFileSync(SKILL_FILE, "utf-8");

  // Strip YAML frontmatter
  const lines = skillContent.split("\n");
  let startIdx = 0;
  let frontmatterCount = 0;
  for (let i = 0; i < lines.length; i++) {
    if (lines[i].trim() === "---") {
      frontmatterCount++;
      if (frontmatterCount <= 2) {
        startIdx = i + 1;
        continue;
      }
    }
    if (frontmatterCount >= 2) {
      startIdx = i;
      break;
    }
  }
  const skillBody = lines.slice(startIdx).join("\n");

  let toolMap = piToolMapping();
  if (fs.existsSync(TOOL_MAP_FILE)) {
    toolMap = fs.readFileSync(TOOL_MAP_FILE, "utf-8");
  }

  cachedBootstrap = `<EXTREMELY_IMPORTANT>
You have Slopnought installed.

**IMPORTANT: The slopnought skill content is included below.
It is ALREADY LOADED - you are currently following it.
Do NOT use the skill tool to load "slopnought" again - that would be redundant.**

${skillBody}

## Tool mapping for Pi

When slopnought skill references tools, use these Pi equivalents:

${toolMap}
</EXTREMELY_IMPORTANT>`;

  return cachedBootstrap;
}

export default {
  name: "slopnought",

  resources_discover() {
    return { skillPaths: [SKILL_DIR] };
  },

  session_start() {
    injectBootstrap = true;
  },

  session_compact() {
    injectBootstrap = true;
  },

  agent_end() {
    injectBootstrap = false;
  },

  context(messages: any[]) {
    if (!injectBootstrap) return messages;

    const bootstrap = buildBootstrap();
    if (!bootstrap) return messages;

    // Dedup guard
    const hasMarker = messages.some(
      (m: any) =>
        m.role === "user" &&
        typeof m.content === "string" &&
        m.content.includes(BOOTSTRAP_MARKER)
    );
    if (hasMarker) return messages;

    // Insert after any leading compaction-summary messages
    const insertIdx = messages.findIndex(
      (m: any) => m.role === "user" && !m.content?.startsWith("[Compaction")
    );
    const idx = insertIdx === -1 ? 0 : insertIdx;

    const bootstrapMsg = {
      role: "user",
      content: `${bootstrap}\n\n<!-- ${BOOTSTRAP_MARKER} -->`,
    };

    const result = [...messages];
    result.splice(idx, 0, bootstrapMsg);
    return result;
  },
};
