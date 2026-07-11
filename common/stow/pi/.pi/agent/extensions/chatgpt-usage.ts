import { readFile } from "node:fs/promises";
import { homedir } from "node:os";
import { join } from "node:path";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

const STATUS_ID = "chatgpt-codex-usage";
const USAGE_URL = "https://chatgpt.com/backend-api/wham/usage";
const AUTH_FILE = join(homedir(), ".pi", "agent", "auth.json");
const MIN_REFRESH_INTERVAL_MS = 30_000;

type WindowUsage = {
	used_percent: number;
	limit_window_seconds: number;
	reset_at: number;
};

type UsageResponse = {
	plan_type?: string;
	rate_limit?: {
		allowed: boolean;
		limit_reached: boolean;
		primary_window?: WindowUsage;
		secondary_window?: WindowUsage;
	};
};

type CodexCredential = {
	type: "oauth";
	access: string;
	accountId?: string;
};

let latest: UsageResponse | undefined;
let lastRefresh = 0;
let inFlight: Promise<UsageResponse> | undefined;

async function getCredential(): Promise<CodexCredential> {
	const auth = JSON.parse(await readFile(AUTH_FILE, "utf8")) as Record<string, unknown>;
	const credential = auth["openai-codex"] as Partial<CodexCredential> | undefined;
	if (credential?.type !== "oauth" || !credential.access) {
		throw new Error("OpenAI Codex subscription login not found; run /login");
	}
	return credential as CodexCredential;
}

async function fetchUsage(): Promise<UsageResponse> {
	const credential = await getCredential();
	const controller = new AbortController();
	const timeout = setTimeout(() => controller.abort(), 10_000);

	try {
		const response = await fetch(USAGE_URL, {
			headers: {
				Authorization: `Bearer ${credential.access}`,
				...(credential.accountId ? { "ChatGPT-Account-Id": credential.accountId } : {}),
			},
			signal: controller.signal,
		});
		if (!response.ok) throw new Error(`OpenAI usage endpoint returned ${response.status}`);
		return (await response.json()) as UsageResponse;
	} finally {
		clearTimeout(timeout);
	}
}

function windowLabel(window: WindowUsage | undefined, fallback: string): string | undefined {
	if (!window) return undefined;
	const hours = Math.round(window.limit_window_seconds / 3600);
	const period = hours >= 24 ? `${Math.round(hours / 24)}d` : `${hours}h`;
	return `${period || fallback} ${Math.round(window.used_percent)}%`;
}

function statusText(usage: UsageResponse): string {
	const primary = windowLabel(usage.rate_limit?.primary_window, "5h");
	const secondary = windowLabel(usage.rate_limit?.secondary_window, "7d");
	return `Codex used: ${[primary, secondary].filter(Boolean).join(" · ") || "unknown"}`;
}

function setStatus(ctx: ExtensionContext, usage: UsageResponse): void {
	const primary = usage.rate_limit?.primary_window?.used_percent ?? 0;
	const secondary = usage.rate_limit?.secondary_window?.used_percent ?? 0;
	const text = statusText(usage);
	const color = usage.rate_limit?.limit_reached || Math.max(primary, secondary) >= 90
		? "error"
		: Math.max(primary, secondary) >= 70
			? "warning"
			: "dim";
	ctx.ui.setStatus(STATUS_ID, ctx.ui.theme.fg(color, text));
}

async function refresh(ctx: ExtensionContext, force = false): Promise<UsageResponse> {
	if (!force && latest && Date.now() - lastRefresh < MIN_REFRESH_INTERVAL_MS) {
		setStatus(ctx, latest);
		return latest;
	}

	if (!inFlight) {
		inFlight = fetchUsage()
			.then((usage) => {
				latest = usage;
				lastRefresh = Date.now();
				return usage;
			})
			.finally(() => {
				inFlight = undefined;
			});
	}

	const usage = await inFlight;
	setStatus(ctx, usage);
	return usage;
}

function formatReset(window: WindowUsage | undefined): string | undefined {
	if (!window?.reset_at) return undefined;
	return new Date(window.reset_at * 1000).toLocaleString(undefined, {
		month: "short",
		day: "numeric",
		hour: "2-digit",
		minute: "2-digit",
	});
}

export default function (pi: ExtensionAPI) {
	pi.on("session_start", async (_event, ctx) => {
		try {
			await refresh(ctx, true);
		} catch {
			ctx.ui.setStatus(STATUS_ID, ctx.ui.theme.fg("dim", "Codex usage unavailable"));
		}
	});

	pi.on("agent_settled", async (_event, ctx) => {
		try {
			await refresh(ctx, true);
		} catch {
			// Keep the last successful value. A refreshed OAuth token may become
			// available in auth.json after a later request.
		}
	});

	pi.registerCommand("codex-usage", {
		description: "Refresh and show ChatGPT Codex subscription usage",
		handler: async (_args, ctx) => {
			try {
				const usage = await refresh(ctx, true);
				const primaryReset = formatReset(usage.rate_limit?.primary_window);
				const secondaryReset = formatReset(usage.rate_limit?.secondary_window);
				const resets = [
					primaryReset && `5-hour reset: ${primaryReset}`,
					secondaryReset && `weekly reset: ${secondaryReset}`,
				].filter(Boolean);
				ctx.ui.notify(`${statusText(usage)}${resets.length ? `\n${resets.join("\n")}` : ""}`, "info");
			} catch (error) {
				const message = error instanceof Error ? error.message : String(error);
				ctx.ui.notify(`Could not read Codex usage: ${message}`, "error");
			}
		},
	});

	pi.on("session_shutdown", async (_event, ctx) => {
		ctx.ui.setStatus(STATUS_ID, undefined);
	});
}
