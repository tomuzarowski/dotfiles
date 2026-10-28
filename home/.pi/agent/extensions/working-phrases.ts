/** Replaces pi's "Working" loader label with a random Claude Code-style phrase per run. */
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const PHRASES = [
  "Accomplishing", "Baking", "Brewing", "Calculating", "Cerebrating", "Churning", "Coalescing",
  "Cogitating", "Computing", "Conjuring", "Considering", "Cooking", "Crafting", "Crunching",
  "Deliberating", "Forging", "Generating", "Hatching", "Ideating", "Inferring", "Manifesting",
  "Marinating", "Mulling", "Musing", "Noodling", "Percolating", "Pondering", "Processing",
  "Puttering", "Reticulating", "Ruminating", "Simmering", "Spinning", "Stewing", "Synthesizing",
  "Thinking", "Tinkering", "Transmuting", "Vibing", "Wrangling",
];

export default function (pi: ExtensionAPI) {
  let last = "";

  pi.on("agent_start", async (_event, ctx) => {
    if (ctx.mode !== "tui") return;
    let phrase = last;
    while (phrase === last) phrase = PHRASES[Math.floor(Math.random() * PHRASES.length)]!;
    last = phrase;
    ctx.ui.setWorkingMessage(`${phrase}…`);
  });
}
