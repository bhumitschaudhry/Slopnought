// Slopnought — OpenCode plugin module
// Injects bootstrap context via experimental.chat.messages.transform lifecycle hook.
// Skills registered via config hook → config.skills.paths.

const fs = require("fs");
const path = require("path");

const PLUGIN_ROOT = path.dirname(__dirname);
const SKILL_DIR = path.join(PLUGIN_ROOT, "skills", "slopnought");
const AUDIT_SKILL_DIR = path.join(PLUGIN_ROOT, "skills", "slopnought-audit");
const SKILL_FILE = path.join(SKILL_DIR, "SKILL.md");

const BOOTSTRAP_MARKER = "EXTREMELY_IMPORTANT";

let cachedBootstrap = null;

function buildBootstrap() {
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

  cachedBootstrap = `<EXTREMELY_IMPORTANT>
You have Slopnought installed.

**IMPORTANT: The slopnought skill content is included below.
It is ALREADY LOADED - you are currently following it.
Do NOT use the skill tool to load "slopnought" again - that would be redundant.**

${skillBody}
</EXTREMELY_IMPORTANT>`;

  return cachedBootstrap;
}

const SlopnoughtPlugin = {
  config(hooks) {
    // Register skills directory for OpenCode discovery
    if (hooks.config && hooks.config.skills) {
      hooks.config.skills.paths = hooks.config.skills.paths || [];
      hooks.config.skills.paths.push(SKILL_DIR);
      hooks.config.skills.paths.push(AUDIT_SKILL_DIR);
    }
  },

  experimental: {
    chat: {
      messages: {
        transform(messages) {
          const bootstrap = buildBootstrap();
          if (!bootstrap) return messages;

          // Dedup guard: check if bootstrap already injected
          const firstUserMsg = messages.find((m) => m.role === "user");
          if (
            firstUserMsg &&
            firstUserMsg.content &&
            firstUserMsg.content.includes(BOOTSTRAP_MARKER)
          ) {
            return messages;
          }

          // Inject as user-role message (not system — avoids token bloat)
          return [
            { role: "user", content: bootstrap },
            ...messages,
          ];
        },
      },
    },
  },
};

module.exports = { SlopnoughtPlugin };
