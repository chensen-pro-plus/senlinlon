# Provider 白名单硬编码锁定

## Context

### Original Request

用户想要二次开发 OpenCode，限制客户只能使用预设的模型配置（my-claude, my-gemini, my-gpt），不能添加或修改 provider/model，baseURL 只能使用指定的域名。即使用户没有配置文件，也应该有默认的 provider 可用。**apiKey 允许用户通过简化的顶层变量配置**。

### Interview Summary

**Key Discussions**:

- 用户选择「代码级强制锁定」而非配置级限制
- 用户选择「硬编码白名单」作为最安全的实现方式
- 只限制 provider/model 和 baseURL 域名，其他配置（permission, plugin 等）不受影响
- 允许的域名：`ccmaxhub.de5.net` 和 `codexhub.de5.net`
- 需要硬编码默认 provider 配置，用户无需配置文件即可使用
- **apiKey 允许用户配置**，使用顶层简化变量：`claudeKey`、`geminiKey`、`gptKey`

**用户配置示例** (opencode.json):

```jsonc
{
  "claudeKey": "用户的 claude apiKey",
  "geminiKey": "用户的 gemini apiKey",
  "gptKey": "用户的 gpt apiKey",
}
```

**用户预设的 Provider 配置（硬编码默认值）**:

```jsonc
{
  "provider": {
    "my-claude": {
      "npm": "@ai-sdk/anthropic",
      "name": "Claude [crs 中转]",
      "options": {
        "baseURL": "https://ccmaxhub.de5.net/claudeMax/v1",
        "apiKey": "默认key或空",
      },
      "models": {
        "claude-sonnet-4-5-thinking": { "name": "Sonnet 4.5 Thinking [CLI]" },
        "claude-opus-4-5-thinking": { "name": "Opus 4.5 Thinking [CLI]" },
        "claude-haiku-4-5": { "name": "Haiku 4.5 [CLI]" },
      },
    },
    "my-gemini": {
      "npm": "@ai-sdk/google",
      "name": "Gemini [crs 中转]",
      "options": {
        "baseURL": "https://ccmaxhub.de5.net/claudeMax/v1beta",
        "apiKey": "默认key或空",
      },
      "models": {
        "gemini-3-pro-high": { "name": "Gemini 3 Pro(High) [crs]" },
        "gemini-3-flash": { "name": "Gemini 3 flash [crs]" },
      },
    },
    "my-gpt": {
      "npm": "@ai-sdk/openai",
      "name": "GPT [crs 中转]",
      "options": {
        "baseURL": "https://codexhub.de5.net/openai/v1",
        "apiKey": "默认key或空",
      },
      "models": {
        "gpt-5.2": { "name": "GPT-5.2 [crs]" },
        "gpt-5.2-codex": { "name": "gpt-5.2-codex [crs]" },
      },
    },
  },
  "model": "my-claude/claude-opus-4-5-thinking",
}
```

---

## Work Objectives

### Core Objective

在代码中实现：

1. 硬编码的默认 provider 配置（用户无需配置文件即可使用）
2. Provider 白名单过滤（只允许 my-claude, my-gemini, my-gpt）
3. BaseURL 域名白名单验证（只允许 ccmaxhub.de5.net, codexhub.de5.net）
4. **新增配置项** `claudeKey`、`geminiKey`、`gptKey` 允许用户配置 apiKey

无法通过任何配置覆盖 provider 白名单和 baseURL 限制。

### Concrete Deliverables

- 修改 `packages/opencode/src/config/config.ts`，添加 `claudeKey`、`geminiKey`、`gptKey` 配置项
- 修改 `packages/opencode/src/provider/provider.ts`，添加硬编码默认 provider 配置
- 修改 `packages/opencode/src/provider/provider.ts`，读取用户的 apiKey 配置
- 修改 `packages/opencode/src/provider/provider.ts`，添加白名单过滤

### Definition of Done

- [x] 用户可以通过 `claudeKey`、`geminiKey`、`gptKey` 配置 apiKey
- [x] 即使没有配置文件，也能使用 my-claude, my-gemini, my-gpt（如果有默认 key）
- [x] 默认模型为 my-claude/claude-opus-4-5-thinking
- [x] 只有 my-claude, my-gemini, my-gpt 三个 provider 可用
- [x] baseURL 固定使用硬编码值，用户无法修改
- [x] 用户在项目级 opencode.json 中添加其他 provider 会被忽略
- [x] 其他配置（permission, plugin, keybinds 等）正常工作

### Must Have

- 新增配置项：`claudeKey`、`geminiKey`、`gptKey`
- 硬编码默认 provider 配置（包括 baseURL、models）
- 从配置读取用户的 apiKey
- 硬编码 provider 白名单过滤逻辑
- 硬编码 baseURL 域名白名单验证
- 日志记录被阻止的 provider 和非法 baseURL

### Must NOT Have (Guardrails)

- 不允许用户修改 baseURL
- 不允许用户添加其他 provider
- 不影响其他非 provider 相关的功能

---

## Verification Strategy

### Test Decision

- **Infrastructure exists**: YES (bun test)
- **User wants tests**: Manual verification
- **Framework**: bun test

### Manual QA Procedure

1. 用户配置 `claudeKey` 后，验证 my-claude 使用该 key
2. 验证只有 my-claude, my-gemini, my-gpt 可选
3. 验证 baseURL 无法被用户修改
4. 在项目目录创建 opencode.json 添加 anthropic provider，验证被忽略

---

## TODOs

- [x] 1. 修改 config.ts 添加 apiKey 配置项

  **What to do**:
  在 `packages/opencode/src/config/config.ts` 的 `Info` schema 中（约第 885 行），添加三个新的配置项：

  找到 `export const Info = z.object({` 然后在合适位置添加：

  ```typescript
  // 自定义 API Key 配置 (二次开发)
  claudeKey: z.string().optional().describe("API Key for Claude provider"),
  geminiKey: z.string().optional().describe("API Key for Gemini provider"),
  gptKey: z.string().optional().describe("API Key for GPT provider"),
  ```

  **修改位置**: 在 `Info` schema 的 `.object({` 内部，建议放在 `model` 配置项附近（约第 925 行之后）

  **Must NOT do**:
  - 不要修改其他配置项的定义

  **Parallelizable**: YES (与任务 2 并行)

  **References**:
  - `packages/opencode/src/config/config.ts:885-1096` - Info schema 定义
  - `packages/opencode/src/config/config.ts:925-929` - model 配置项位置

  **Acceptance Criteria**:
  - [ ] 配置项添加成功
  - [ ] `bun run --cwd packages/opencode typecheck` 通过
  - [ ] 用户可以在 opencode.json 中配置这三个字段

  **Commit**: NO (与其他任务一起提交)

---

- [x] 2. 添加硬编码默认 Provider 配置

  **What to do**:
  在 `packages/opencode/src/provider/provider.ts` 文件顶部（在 `export namespace Provider {` 之后，约第 42 行），添加默认 provider 配置常量：

  ```typescript
  // ========== 硬编码默认 Provider 配置 (二次开发) ==========
  // 这些是内置的 provider 配置，用户无需配置文件即可使用
  // apiKey 从用户配置的 claudeKey/geminiKey/gptKey 读取
  const DEFAULT_PROVIDERS: Record<
    string,
    {
      npm: string
      name: string
      api: string
      baseURL: string
      configKey: "claudeKey" | "geminiKey" | "gptKey"
      models: Record<string, { name: string }>
    }
  > = {
    "my-claude": {
      npm: "@ai-sdk/anthropic",
      name: "Claude [crs 中转]",
      api: "https://ccmaxhub.de5.net/claudeMax/v1",
      baseURL: "https://ccmaxhub.de5.net/claudeMax/v1",
      configKey: "claudeKey",
      models: {
        "claude-sonnet-4-5-thinking": { name: "Sonnet 4.5 Thinking [CLI]" },
        "claude-opus-4-5-thinking": { name: "Opus 4.5 Thinking [CLI]" },
        "claude-haiku-4-5": { name: "Haiku 4.5 [CLI]" },
      },
    },
    "my-gemini": {
      npm: "@ai-sdk/google",
      name: "Gemini [crs 中转]",
      api: "https://ccmaxhub.de5.net/claudeMax/v1beta",
      baseURL: "https://ccmaxhub.de5.net/claudeMax/v1beta",
      configKey: "geminiKey",
      models: {
        "gemini-3-pro-high": { name: "Gemini 3 Pro(High) [crs]" },
        "gemini-3-flash": { name: "Gemini 3 flash [crs]" },
      },
    },
    "my-gpt": {
      npm: "@ai-sdk/openai",
      name: "GPT [crs 中转]",
      api: "https://codexhub.de5.net/openai/v1",
      baseURL: "https://codexhub.de5.net/openai/v1",
      configKey: "gptKey",
      models: {
        "gpt-5.2": { name: "GPT-5.2 [crs]" },
        "gpt-5.2-codex": { name: "gpt-5.2-codex [crs]" },
      },
    },
  }

  // 默认模型
  const DEFAULT_MODEL = "my-claude/claude-opus-4-5-thinking"

  // 允许的 baseURL 域名白名单
  const ALLOWED_DOMAINS = ["ccmaxhub.de5.net", "codexhub.de5.net"]

  // 验证 baseURL 域名是否在白名单中
  function isAllowedBaseURL(baseURL: string | undefined): boolean {
    if (!baseURL) return false
    try {
      const url = new URL(baseURL)
      return ALLOWED_DOMAINS.some((domain) => url.hostname === domain)
    } catch {
      return false
    }
  }
  // ========== 默认配置结束 ==========
  ```

  **修改位置**: 第 42 行 `const log = Log.create({ service: "provider" })` 之后

  **Must NOT do**:
  - 不要修改现有的 BUNDLED_PROVIDERS 或 CUSTOM_LOADERS

  **Parallelizable**: YES (与任务 1 并行)

  **References**:
  - `packages/opencode/src/provider/provider.ts:41-43` - log 定义位置

  **Acceptance Criteria**:
  - [ ] 常量定义无语法错误
  - [ ] `bun run --cwd packages/opencode typecheck` 通过

  **Commit**: NO (与其他任务一起提交)

---

- [x] 3. 在 state() 函数中注入默认 Provider 并读取用户 apiKey

  **What to do**:
  在 `state()` 函数中，在处理 configProviders 之前（约第 700 行），注入默认 provider 到 database，并从配置读取用户的 apiKey：

  ```typescript
  // ========== 注入硬编码默认 Provider ==========
  for (const [providerID, defaultProvider] of Object.entries(DEFAULT_PROVIDERS)) {
    // 从用户配置读取 apiKey
    const userApiKey = config[defaultProvider.configKey] as string | undefined

    // 如果用户没有配置 apiKey，跳过此 provider（或使用默认key，根据需求调整）
    if (!userApiKey) {
      log.info("provider skipped: no apiKey configured", { providerID, configKey: defaultProvider.configKey })
      continue
    }

    // 构建符合 Info 格式的 provider
    const defaultModels: Record<string, Model> = {}
    for (const [modelID, modelConfig] of Object.entries(defaultProvider.models)) {
      defaultModels[modelID] = {
        id: modelID,
        providerID,
        name: modelConfig.name,
        api: {
          id: modelID,
          url: defaultProvider.api,
          npm: defaultProvider.npm,
        },
        status: "active",
        headers: {},
        options: {},
        cost: { input: 0, output: 0, cache: { read: 0, write: 0 } },
        limit: { context: 200000, output: 8192 },
        capabilities: {
          temperature: true,
          reasoning: true,
          attachment: true,
          toolcall: true,
          input: { text: true, audio: false, image: true, video: false, pdf: true },
          output: { text: true, audio: false, image: false, video: false, pdf: false },
          interleaved: true,
        },
        family: "",
        release_date: "",
        variants: {},
      }
    }

    database[providerID] = {
      id: providerID,
      name: defaultProvider.name,
      source: "custom",
      env: [],
      options: {
        baseURL: defaultProvider.baseURL,
        apiKey: userApiKey,
      },
      models: defaultModels,
    }

    // 同时标记为已加载的 provider
    providers[providerID] = database[providerID]
    log.info("injected default provider", { providerID })
  }
  // ========== 注入结束 ==========
  ```

  **修改位置**: 在第 700 行 `const configProviders = Object.entries(config.provider ?? {})` 之前

  **Must NOT do**:
  - 不要修改现有的 provider 加载逻辑

  **Parallelizable**: NO (依赖任务 1、2)

  **References**:
  - `packages/opencode/src/provider/provider.ts:676-700` - state() 函数开头
  - `packages/opencode/src/provider/provider.ts:509-578` - Model 类型定义

  **Acceptance Criteria**:
  - [ ] 用户配置 `claudeKey` 后，my-claude 使用该 key
  - [ ] 用户未配置 key 时，对应 provider 不可用
  - [ ] `bun run --cwd packages/opencode typecheck` 通过

  **Commit**: NO (与任务 4 一起提交)

---

- [x] 4. 添加 Provider 和 BaseURL 白名单过滤

  **What to do**:
  在 `state()` 函数的 `return` 之前（约第 945-947 行之间），添加白名单过滤逻辑：

  ```typescript
  // ========== 硬编码 Provider 白名单过滤 (二次开发锁定) ==========
  const ALLOWED_PROVIDERS = new Set(Object.keys(DEFAULT_PROVIDERS))

  for (const providerID of Object.keys(providers)) {
    // 检查 provider 是否在白名单中
    if (!ALLOWED_PROVIDERS.has(providerID)) {
      log.info("provider blocked by hardcoded whitelist", { providerID })
      delete providers[providerID]
      continue
    }

    // 强制使用硬编码的 baseURL（防止用户覆盖）
    const defaultProvider = DEFAULT_PROVIDERS[providerID]
    if (defaultProvider) {
      const provider = providers[providerID]
      provider.options = {
        ...provider.options,
        baseURL: defaultProvider.baseURL,
      }
    }

    // 检查 baseURL 是否使用允许的域名
    const provider = providers[providerID]
    const baseURL = provider.options?.baseURL as string | undefined
    if (!isAllowedBaseURL(baseURL)) {
      log.error("provider blocked: invalid baseURL domain", {
        providerID,
        baseURL,
        allowedDomains: ALLOWED_DOMAINS,
      })
      delete providers[providerID]
    }
  }
  // ========== 白名单过滤结束 ==========
  ```

  **修改位置**: 第 945 行 `log.info("found", { providerID })` 的 `}` 之后，第 947 行 `return {` 之前

  **Must NOT do**:
  - 不要修改其他代码逻辑
  - 不要删除任何现有代码

  **Parallelizable**: NO (依赖任务 2、3)

  **References**:
  - `packages/opencode/src/provider/provider.ts:908-945` - 现有的 provider 过滤逻辑
  - `packages/opencode/src/provider/provider.ts:947-953` - return 语句

  **Acceptance Criteria**:
  - [ ] 只有白名单中的 provider 可用
  - [ ] baseURL 被强制使用硬编码值
  - [ ] apiKey 使用用户配置的值
  - [ ] `bun run --cwd packages/opencode typecheck` 通过

  **Commit**: YES
  - Message: `feat(provider): add hardcoded providers with user-configurable apiKey`
  - Files: `packages/opencode/src/config/config.ts`, `packages/opencode/src/provider/provider.ts`

---

- [x] 5. 修改 defaultModel() 函数使用硬编码默认模型

  **What to do**:
  修改 `defaultModel()` 函数（约第 1180 行），在没有配置时返回硬编码的默认模型：

  找到：

  ```typescript
  export async function defaultModel() {
    const cfg = await Config.get()
    if (cfg.model) return parseModel(cfg.model)

    const provider = await list()
  ```

  修改为：

  ```typescript
  export async function defaultModel() {
    const cfg = await Config.get()
    if (cfg.model) return parseModel(cfg.model)

    // 使用硬编码的默认模型
    return parseModel(DEFAULT_MODEL)
  }
  ```

  删除函数中 `const provider = await list()` 之后的所有代码（到函数结束的 `}`）。

  **修改位置**: 第 1180-1194 行

  **Must NOT do**:
  - 不要影响 parseModel 函数

  **Parallelizable**: NO (依赖任务 2)

  **References**:
  - `packages/opencode/src/provider/provider.ts:1180-1194` - defaultModel() 函数

  **Acceptance Criteria**:
  - [ ] 没有配置 model 时使用 my-claude/claude-opus-4-5-thinking
  - [ ] `bun run --cwd packages/opencode typecheck` 通过

  **Commit**: YES
  - Message: `feat(provider): use hardcoded default model`
  - Files: `packages/opencode/src/provider/provider.ts`

---

## Commit Strategy

| After Task | Message                                                                 | Files                  | Verification      |
| ---------- | ----------------------------------------------------------------------- | ---------------------- | ----------------- |
| 4          | `feat(provider): add hardcoded providers with user-configurable apiKey` | config.ts, provider.ts | bun run typecheck |
| 5          | `feat(provider): use hardcoded default model`                           | provider.ts            | bun run typecheck |

---

## Success Criteria

### Verification Commands

```bash
bun run --cwd packages/opencode typecheck  # Expected: 无错误
bun run --cwd packages/opencode ./src/index.ts  # 启动后只显示配置了 key 的 provider
```

### Final Checklist

- [x] 新增配置项 `claudeKey`、`geminiKey`、`gptKey`
- [x] 用户配置 apiKey 后对应 provider 可用
- [x] 用户未配置 apiKey 时对应 provider 不可用
- [x] 默认模型为 my-claude/claude-opus-4-5-thinking
- [x] Provider 白名单过滤逻辑已添加
- [x] BaseURL 强制使用硬编码值（用户无法覆盖）
- [x] 只有 my-claude, my-gemini, my-gpt 可用
- [x] 其他功能正常工作

---

## 用户配置示例

用户只需要在 `opencode.json` 中配置：

```jsonc
{
  "claudeKey": "cr_xxxxxxxxxxxxxxxx",
  "geminiKey": "cr_xxxxxxxxxxxxxxxx",
  "gptKey": "cr_xxxxxxxxxxxxxxxx",
}
```

- 配置了哪个 key，哪个 provider 就可用
- 不需要配置复杂的 provider 结构
- baseURL 自动使用硬编码值，用户无法修改
- 其他 provider（如 anthropic、openai）会被自动过滤掉

---

## 测试场景

### 场景 1: 用户只配置 claudeKey

```json
{ "claudeKey": "cr_xxx" }
```

**预期**: 只有 my-claude 可用，my-gemini 和 my-gpt 不可用

### 场景 2: 用户配置全部 key

```json
{
  "claudeKey": "cr_xxx",
  "geminiKey": "cr_xxx",
  "gptKey": "cr_xxx"
}
```

**预期**: my-claude, my-gemini, my-gpt 全部可用

### 场景 3: 用户尝试添加其他 provider

```json
{
  "claudeKey": "cr_xxx",
  "provider": {
    "anthropic": { "options": { "apiKey": "sk-xxx" } }
  }
}
```

**预期**: anthropic 被忽略，只有 my-claude 可用

### 场景 4: 用户尝试修改 baseURL

```json
{
  "claudeKey": "cr_xxx",
  "provider": {
    "my-claude": {
      "options": { "baseURL": "https://api.anthropic.com/v1" }
    }
  }
}
```

**预期**: my-claude 仍然使用 `https://ccmaxhub.de5.net/claudeMax/v1`，baseURL 被强制还原
