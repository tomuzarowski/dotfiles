import { isAbsolute, relative, resolve, sep } from "node:path";

import type { AssistantMessage } from "@earendil-works/pi-ai";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

function formatTokens(count: number): string {
	if (count < 1000) return count.toString();
	if (count < 10000) return `${(count / 1000).toFixed(1)}k`;
	if (count < 1000000) return `${Math.round(count / 1000)}k`;
	if (count < 10000000) return `${(count / 1000000).toFixed(1)}M`;
	return `${Math.round(count / 1000000)}M`;
}

function formatCwd(cwd: string): string {
	const home = process.env.HOME || process.env.USERPROFILE;
	if (!home) return cwd;

	const resolvedCwd = resolve(cwd);
	const resolvedHome = resolve(home);
	const relativeToHome = relative(resolvedHome, resolvedCwd);
	const insideHome =
		relativeToHome === "" ||
		(relativeToHome !== ".." && !relativeToHome.startsWith(`..${sep}`) && !isAbsolute(relativeToHome));

	if (!insideHome) return cwd;
	return relativeToHome === "" ? "~" : `~${sep}${relativeToHome}`;
}

function sanitizeStatus(text: string): string {
	return text.replace(/[\r\n\t]/g, " ").replace(/ +/g, " ").trim();
}

function getUsage(ctx: ExtensionContext) {
	let input = 0;
	let output = 0;
	let cacheRead = 0;
	let cacheWrite = 0;
	let cost = 0;
	let latestUsage: AssistantMessage["usage"] | undefined;

	for (const entry of ctx.sessionManager.getEntries()) {
		if (entry.type !== "message" || entry.message.role !== "assistant") continue;

		const usage = (entry.message as AssistantMessage).usage;
		if (!usage) continue;

		input += usage.input || 0;
		output += usage.output || 0;
		cacheRead += usage.cacheRead || 0;
		cacheWrite += usage.cacheWrite || 0;
		cost += usage.cost?.total || 0;
		latestUsage = usage;
	}

	let latestCacheHitRate: number | undefined;
	if (latestUsage) {
		const latestPromptTokens =
			(latestUsage.input || 0) + (latestUsage.cacheRead || 0) + (latestUsage.cacheWrite || 0);
		latestCacheHitRate =
			latestPromptTokens > 0 ? ((latestUsage.cacheRead || 0) / latestPromptTokens) * 100 : undefined;
	}

	return { input, output, cacheRead, cacheWrite, cost, latestCacheHitRate };
}

function installFooter(pi: ExtensionAPI, ctx: ExtensionContext) {
	ctx.ui.setFooter((tui, theme, footerData) => {
		const unsubscribe = footerData.onBranchChange(() => tui.requestRender());

		return {
			dispose: unsubscribe,
			invalidate() {},
			render(width: number): string[] {
				let location = formatCwd(ctx.sessionManager.getCwd());
				const branch = footerData.getGitBranch();
				if (branch) location += ` (${branch})`;

				const sessionName = ctx.sessionManager.getSessionName();
				if (sessionName) location += ` • ${sessionName}`;

				const sep = theme.fg("dim", " │ ");
				const softSpace = theme.fg("dim", " ");

				const usage = getUsage(ctx);
				const stats: string[] = [];
				if (usage.input) stats.push(theme.fg("dim", `↑${formatTokens(usage.input)}`));
				if (usage.output) stats.push(theme.fg("dim", `↓${formatTokens(usage.output)}`));
				if (usage.cacheRead) stats.push(theme.fg("dim", `R${formatTokens(usage.cacheRead)}`));
				if (usage.cacheWrite) stats.push(theme.fg("dim", `W${formatTokens(usage.cacheWrite)}`));
				if ((usage.cacheRead || usage.cacheWrite) && usage.latestCacheHitRate !== undefined) {
					stats.push(theme.fg("dim", `CH${usage.latestCacheHitRate.toFixed(1)}%`));
				}

				const usingSubscription = ctx.model ? ctx.modelRegistry.isUsingOAuth(ctx.model) : false;
				const cost =
					usage.cost || usingSubscription
						? theme.fg("dim", `$${usage.cost.toFixed(3)}${usingSubscription ? " sub" : ""}`)
						: "";

				const contextUsage = ctx.getContextUsage();
				const contextWindow = contextUsage?.contextWindow ?? ctx.model?.contextWindow ?? 0;
				const contextPercent = contextUsage?.percent == null ? "?" : `${contextUsage.percent.toFixed(1)}%`;
				const contextColor =
					(contextUsage?.percent ?? 0) > 90 ? "error" : (contextUsage?.percent ?? 0) > 70 ? "warning" : "success";
				const context = contextWindow
					? `${theme.fg("dim", "ctx ")}${theme.fg(contextColor, contextPercent)}${theme.fg("dim", `/${formatTokens(contextWindow)} auto`)}`
					: `${theme.fg("dim", "ctx ")}${theme.fg(contextColor, contextPercent)}`;

				const model = ctx.model ? `${ctx.model.provider}/${ctx.model.id}` : "no-model";
				const thinking = ctx.model?.reasoning ? ` ${pi.getThinkingLevel()}` : "";
				const modelPart = theme.fg("accent", model) + theme.fg("dim", thinking);

				const middle = [stats.join(softSpace), cost, context].filter(Boolean).join(sep);
				const locationMax = Math.max(12, Math.min(34, Math.floor(width * 0.3)));
				const leftPlain = truncateToWidth(location, locationMax, "…");
				const left = theme.fg("accent", leftPlain);
				const right = [middle, modelPart].filter(Boolean).join(sep);

				let mainLine: string;
				if (visibleWidth(left) + visibleWidth(sep) + visibleWidth(right) <= width) {
					mainLine = `${left}${sep}${right}`;
				} else if (width >= 90) {
					mainLine = truncateToWidth(`${left}${sep}${right}`, width, "…");
				} else {
					const first = truncateToWidth(`${theme.fg("accent", location)}${sep}${modelPart}`, width, "…");
					const second = truncateToWidth(middle, width, "…");
					const lines = [first, second];
					const statuses = footerData.getExtensionStatuses();
					if (statuses.size > 0) {
						lines.push(
							truncateToWidth(
								Array.from(statuses.entries())
									.sort(([a], [b]) => a.localeCompare(b))
									.map(([, text]) => sanitizeStatus(text))
									.join(" "),
								width,
								"…",
							),
						);
					}
					return lines;
				}

				const lines = [truncateToWidth(mainLine, width, "…")];
				const statuses = footerData.getExtensionStatuses();
				if (statuses.size > 0) {
					lines.push(
						truncateToWidth(
							Array.from(statuses.entries())
								.sort(([a], [b]) => a.localeCompare(b))
								.map(([, text]) => sanitizeStatus(text))
								.join(" "),
							width,
							"…",
						),
					);
				}
				return lines;
			},
		};
	});
}

export default function (pi: ExtensionAPI) {
	let enabled = true;

	pi.on("session_start", async (_event, ctx) => {
		if (ctx.mode !== "tui" || !enabled) return;
		installFooter(pi, ctx);
	});

	pi.registerCommand("footer-info", {
		description: "Toggle informative footer",
		handler: async (_args, ctx) => {
			enabled = !enabled;
			if (enabled) {
				installFooter(pi, ctx);
				ctx.ui.notify("Informative footer enabled", "info");
			} else {
				ctx.ui.setFooter(undefined);
				ctx.ui.notify("Default footer restored", "info");
			}
		},
	});
}
