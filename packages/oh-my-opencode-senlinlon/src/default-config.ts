import type { OhMyOpenCodeConfig } from "./config";

/**
 * Default configuration for oh-my-opencode-senlinlon
 * This is used when no user or project config file exists
 */
export const DEFAULT_CONFIG: OhMyOpenCodeConfig = {
  agents: {
    sisyphus: {
      model: "my-claude/claude-opus-4-5-thinking",
      temperature: 0.1,
      thinking: {
        type: "enabled",
        budgetTokens: 32000,
      },
    },
    atlas: {
      model: "my-claude/claude-sonnet-4-5-thinking",
      temperature: 0.1,
    },
    prometheus: {
      model: "my-claude/claude-opus-4-5-thinking",
    },
    metis: {
      model: "my-claude/claude-opus-4-5-thinking",
      temperature: 0.3,
    },
    momus: {
      model: "my-claude/claude-opus-4-5-thinking",
      temperature: 0.1,
    },
    oracle: {
      model: "my-gpt/gpt-5.2",
      temperature: 0.1,
      reasoningEffort: "medium",
      textVerbosity: "high",
    },
    librarian: {
      model: "my-claude/claude-sonnet-4-5-thinking",
      temperature: 0.1,
    },
    explore: {
      model: "my-gemini/gemini-3-flash",
      temperature: 0.1,
    },
    "multimodal-looker": {
      model: "my-gemini/gemini-3-flash",
      temperature: 0.1,
    },
    "sisyphus-junior": {
      model: "my-claude/claude-sonnet-4-5-thinking",
      temperature: 0.1,
    },
  },
  categories: {
    "visual-engineering": {
      model: "my-gemini/gemini-3-pro-high",
      temperature: 0.7,
    },
    ultrabrain: {
      model: "my-gpt/gpt-5.2",
      temperature: 0.1,
      variant: "xhigh",
    },
    artistry: {
      model: "my-gemini/gemini-3-pro-high",
      temperature: 0.9,
      variant: "max",
    },
    quick: {
      model: "my-claude/claude-haiku-4-5",
      temperature: 0.5,
    },
    "most-capable": {
      model: "my-claude/claude-opus-4-5-thinking",
      temperature: 0.3,
    },
    writing: {
      model: "my-gemini/gemini-3-flash",
      temperature: 0.7,
    },
    general: {
      model: "my-claude/claude-sonnet-4-5-thinking",
      temperature: 0.5,
    },
    "unspecified-low": {
      model: "my-claude/claude-sonnet-4-5-thinking",
      temperature: 0.5,
    },
    "unspecified-high": {
      model: "my-claude/claude-opus-4-5-thinking",
      temperature: 0.3,
      variant: "max",
    },
  },
  // Enable prometheus planner and replace_plan
  sisyphus_agent: {
    planner_enabled: true,
    replace_plan: true,
  },
  disabled_hooks: ["comment-checker", "startup-toast"],
  disabled_mcps: [],
  experimental: {
    auto_resume: true,
  },
};
