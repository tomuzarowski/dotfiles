/** Shared by Claude and OpenAI; no shell profile changes or secrets required. */
export default function () {
  process.env.PI_WEB_TOOLS_SEARCH_PROVIDER = "exa";
  process.env.PI_WEB_TOOLS_EXA_ENDPOINT = "https://mcp.exa.ai/mcp";
  process.env.PI_CLAUDE_CLI_RELAY = "off";
  process.env.PI_CLAUDE_CLI_ALLOW_USAGE_CREDITS = "0";
}
