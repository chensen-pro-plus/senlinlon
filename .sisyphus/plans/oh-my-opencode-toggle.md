# oh-my-opencode 功能开关

## Context

### Original Request

用户希望：

1. 默认配置文件内置 `"plugin": ["oh-my-opencode"]`
2. 用户可以通过配置 `"ohMyOpencode": false` 来禁用这个插件功能

### 目标行为

- 默认启用白名单限制（通过内置 plugin 配置）
- 用户配置 `ohMyOpencode: false` 时，禁用 oh-my-opencode 功能

---

## Work Objectives

### Core Objective

1. 在 config schema 中添加 `ohMyOpencode` 配置项
2. 在默认配置中内置 `plugin: ["oh-my-opencode"]`
3. 修改 provider.ts，当 `ohMyOpencode: false` 时禁用白名单限制

### Concrete Deliverables

- 修改 `packages/opencode/src/config/config.ts` 添加配置项和默认 plugin
- 修改 `packages/opencode/src/provider/provider.ts` 白名单过滤逻辑
- 更新 `资料/用户配置指南.md`

---

## TODOs

- [x] 1. 在 config.ts 中添加 ohMyOpencode 配置项和默认 plugin

  **What to do**:
  1. 在 Schema 定义中（约第 932 行，gptKey 之后）添加：

  ```typescript
  ohMyOpencode: z
    .boolean()
    .optional()
    .describe("Set to false to disable oh-my-opencode whitelist restriction"),
  ```

  2. 在配置加载逻辑中（约第 100 行，`result.plugin = result.plugin || []` 之后）添加默认 plugin：

  ```typescript
  result.plugin = result.plugin || []
  // 内置 oh-my-opencode 插件
  if (!result.plugin.includes("oh-my-opencode")) {
    result.plugin.push("oh-my-opencode")
  }
  ```

  **References**:
  - `packages/opencode/src/config/config.ts:100` - plugin 初始化位置
  - `packages/opencode/src/config/config.ts:930-932` - 配置项定义位置

  **Acceptance Criteria**:
  - [ ] 类型检查通过：`bun run typecheck`

  **Commit**: NO (与任务2一起提交)

---

- [x] 2. 修改 provider.ts 白名单过滤逻辑

  **What to do**:

  在 `packages/opencode/src/provider/provider.ts` 第 1078-1113 行，修改条件判断：

  ```typescript
  // ========== 硬编码 Provider 白名单过滤 (二次开发锁定) ==========
  // 说明: 默认启用，用户配置 ohMyOpencode: false 时禁用
  const isWhitelistEnabled = config.ohMyOpencode !== false

  if (isWhitelistEnabled) {
    const ALLOWED_PROVIDERS = new Set(Object.keys(DEFAULT_PROVIDERS))

    for (const providerID of Object.keys(providers)) {
      if (!ALLOWED_PROVIDERS.has(providerID)) {
        log.info("provider blocked by oh-my-opencode whitelist", { providerID })
        delete providers[providerID]
        continue
      }

      const defaultProvider = DEFAULT_PROVIDERS[providerID]
      if (defaultProvider) {
        const provider = providers[providerID]
        provider.options = {
          ...provider.options,
          baseURL: defaultProvider.baseURL,
        }
      }

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
  } else {
    log.info("oh-my-opencode disabled by user config")
  }
  // ========== 白名单过滤结束 ==========
  ```

  **References**:
  - `packages/opencode/src/provider/provider.ts:1078-1113` - 当前白名单过滤代码

  **Acceptance Criteria**:
  - [ ] 代码编译通过：`bun run typecheck`
  - [ ] 默认白名单生效
  - [ ] 配置 `ohMyOpencode: false` 时白名单关闭

  **Commit**: YES
  - Message: `feat(provider): add ohMyOpencode config toggle`
  - Files: `config.ts`, `provider.ts`

---

- [x] 3. 更新用户配置指南文档

  **What to do**:

  在 `资料/用户配置指南.md` 中添加：

  ````markdown
  ## 禁用 oh-my-opencode

  默认内置 `oh-my-opencode` 插件，限制只能使用白名单内的 Provider。

  如需禁用此限制，使用其他 Provider：

  ```json
  {
    "ohMyOpencode": false
  }
  ```
  ````

  ```

  **Acceptance Criteria**:
  - [ ] 文档包含禁用说明

  **Commit**: YES
  - Message: `docs: add ohMyOpencode disable option`
  ```

---

## Success Criteria

```bash
bun run typecheck  # 无错误
```

### 用户配置示例

**默认行为**（白名单限制启用）：

```json
{
  "claudeKey": "sk-xxx"
}
```

**禁用限制**：

```json
{
  "ohMyOpencode": false,
  "provider": {
    "anthropic": { "apiKey": "sk-xxx" }
  }
}
```
