function truthy(key: string) {
  const value = process.env[key]?.toLowerCase()
  return value === "true" || value === "1"
}

export namespace Flag {
  export const SENLINLON_AUTO_SHARE = truthy("SENLINLON_AUTO_SHARE")
  export const SENLINLON_GIT_BASH_PATH = process.env["SENLINLON_GIT_BASH_PATH"]
  export const SENLINLON_CONFIG = process.env["SENLINLON_CONFIG"]
  export declare const SENLINLON_CONFIG_DIR: string | undefined
  export const SENLINLON_CONFIG_CONTENT = process.env["SENLINLON_CONFIG_CONTENT"]
  export const SENLINLON_DISABLE_AUTOUPDATE = truthy("SENLINLON_DISABLE_AUTOUPDATE")
  export const SENLINLON_DISABLE_PRUNE = truthy("SENLINLON_DISABLE_PRUNE")
  export const SENLINLON_DISABLE_TERMINAL_TITLE = truthy("SENLINLON_DISABLE_TERMINAL_TITLE")
  export const SENLINLON_PERMISSION = process.env["SENLINLON_PERMISSION"]
  export const SENLINLON_DISABLE_DEFAULT_PLUGINS = truthy("SENLINLON_DISABLE_DEFAULT_PLUGINS")
  export const SENLINLON_DISABLE_LSP_DOWNLOAD = truthy("SENLINLON_DISABLE_LSP_DOWNLOAD")
  export const SENLINLON_ENABLE_EXPERIMENTAL_MODELS = truthy("SENLINLON_ENABLE_EXPERIMENTAL_MODELS")
  export const SENLINLON_DISABLE_AUTOCOMPACT = truthy("SENLINLON_DISABLE_AUTOCOMPACT")
  export const SENLINLON_DISABLE_MODELS_FETCH = truthy("SENLINLON_DISABLE_MODELS_FETCH")
  export const SENLINLON_DISABLE_CLAUDE_CODE = truthy("SENLINLON_DISABLE_CLAUDE_CODE")
  export const SENLINLON_DISABLE_CLAUDE_CODE_PROMPT =
    SENLINLON_DISABLE_CLAUDE_CODE || truthy("SENLINLON_DISABLE_CLAUDE_CODE_PROMPT")
  export const SENLINLON_DISABLE_CLAUDE_CODE_SKILLS =
    SENLINLON_DISABLE_CLAUDE_CODE || truthy("SENLINLON_DISABLE_CLAUDE_CODE_SKILLS")
  export declare const SENLINLON_DISABLE_PROJECT_CONFIG: boolean
  export const SENLINLON_FAKE_VCS = process.env["SENLINLON_FAKE_VCS"]
  export const SENLINLON_CLIENT = process.env["SENLINLON_CLIENT"] ?? "cli"
  export const SENLINLON_SERVER_PASSWORD = process.env["SENLINLON_SERVER_PASSWORD"]
  export const SENLINLON_SERVER_USERNAME = process.env["SENLINLON_SERVER_USERNAME"]

  // Experimental
  export const SENLINLON_EXPERIMENTAL = truthy("SENLINLON_EXPERIMENTAL")
  export const SENLINLON_EXPERIMENTAL_FILEWATCHER = truthy("SENLINLON_EXPERIMENTAL_FILEWATCHER")
  export const SENLINLON_EXPERIMENTAL_DISABLE_FILEWATCHER = truthy("SENLINLON_EXPERIMENTAL_DISABLE_FILEWATCHER")
  export const SENLINLON_EXPERIMENTAL_ICON_DISCOVERY =
    SENLINLON_EXPERIMENTAL || truthy("SENLINLON_EXPERIMENTAL_ICON_DISCOVERY")
  export const SENLINLON_EXPERIMENTAL_DISABLE_COPY_ON_SELECT = truthy("SENLINLON_EXPERIMENTAL_DISABLE_COPY_ON_SELECT")
  export const SENLINLON_ENABLE_EXA =
    truthy("SENLINLON_ENABLE_EXA") || SENLINLON_EXPERIMENTAL || truthy("SENLINLON_EXPERIMENTAL_EXA")
  export const SENLINLON_EXPERIMENTAL_BASH_MAX_OUTPUT_LENGTH = number("SENLINLON_EXPERIMENTAL_BASH_MAX_OUTPUT_LENGTH")
  export const SENLINLON_EXPERIMENTAL_BASH_DEFAULT_TIMEOUT_MS = number("SENLINLON_EXPERIMENTAL_BASH_DEFAULT_TIMEOUT_MS")
  export const SENLINLON_EXPERIMENTAL_OUTPUT_TOKEN_MAX = number("SENLINLON_EXPERIMENTAL_OUTPUT_TOKEN_MAX")
  export const SENLINLON_EXPERIMENTAL_OXFMT = SENLINLON_EXPERIMENTAL || truthy("SENLINLON_EXPERIMENTAL_OXFMT")
  export const SENLINLON_EXPERIMENTAL_LSP_TY = truthy("SENLINLON_EXPERIMENTAL_LSP_TY")
  export const SENLINLON_EXPERIMENTAL_LSP_TOOL = SENLINLON_EXPERIMENTAL || truthy("SENLINLON_EXPERIMENTAL_LSP_TOOL")
  export const SENLINLON_DISABLE_FILETIME_CHECK = truthy("SENLINLON_DISABLE_FILETIME_CHECK")
  export const SENLINLON_EXPERIMENTAL_PLAN_MODE = SENLINLON_EXPERIMENTAL || truthy("SENLINLON_EXPERIMENTAL_PLAN_MODE")
  export const SENLINLON_MODELS_URL = process.env["SENLINLON_MODELS_URL"]

  function number(key: string) {
    const value = process.env[key]
    if (!value) return undefined
    const parsed = Number(value)
    return Number.isInteger(parsed) && parsed > 0 ? parsed : undefined
  }
}

// Dynamic getter for SENLINLON_DISABLE_PROJECT_CONFIG
// This must be evaluated at access time, not module load time,
// because external tooling may set this env var at runtime
Object.defineProperty(Flag, "SENLINLON_DISABLE_PROJECT_CONFIG", {
  get() {
    return truthy("SENLINLON_DISABLE_PROJECT_CONFIG")
  },
  enumerable: true,
  configurable: false,
})

// Dynamic getter for SENLINLON_CONFIG_DIR
// This must be evaluated at access time, not module load time,
// because external tooling may set this env var at runtime
Object.defineProperty(Flag, "SENLINLON_CONFIG_DIR", {
  get() {
    return process.env["SENLINLON_CONFIG_DIR"]
  },
  enumerable: true,
  configurable: false,
})
