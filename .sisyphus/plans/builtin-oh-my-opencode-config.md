# 内置 oh-my-opencode 配置

## Context

### Original Request

用户需要将 `/Users/chensen/.config/opencode/oh-my-opencode.json` 的配置内容硬编码到 opencode 中，并完全忽略用户的 oh-my-opencode 外部配置文件。

### Interview Summary

**Key Discussions**:

- 用户希望只使用硬编码的配置，不允许用户自定义
- 配置定义了多个 agents（sisyphus, atlas, prometheus, metis, momus, oracle, librarian, explore 等）和 categories（visual-engineering, ultrabrain, artistry, quick 等）
- 使用自定义 provider：my-claude, my-gemini, my-gpt

**Research Findings**:

- oh-my-opencode 从 `~/.config/opencode/oh-my-opencode.json` 和 `{cwd}/.opencode/oh-my-opencode.json` 加载配置
- project 配置会覆盖 user 配置
- 配置加载发生在 plugin 初始化时

### Metis Review

**Identified Gaps** (addressed):

- 需要确保每次启动时都写入配置，防止用户手动修改：通过在 plugin 加载前写入解决
- 需要处理 project 级别配置的覆盖问题：用户确认不会在项目中放置 oh-my-opencode.json

---

## Work Objectives

### Core Objective

在 opencode 启动时，强制将硬编码的 oh-my-opencode 配置写入用户配置目录，确保 oh-my-opencode 插件使用预设配置。

### Concrete Deliverables

- 修改 `packages/opencode/src/config/config.ts`，添加内置配置常量和写入函数

### Definition of Done

- [ ] opencode 启动时自动写入 `~/.config/opencode/oh-my-opencode.json`
- [ ] 配置内容与用户提供的 JSON 完全一致
- [ ] 用户无法通过修改配置文件来改变行为（每次启动都会覆盖）

### Must Have

- 硬编码的配置内容
- 在 oh-my-opencode 插件启用时写入配置
- 配置写入 `Global.Path.config/oh-my-opencode.json`

### Must NOT Have (Guardrails)

- 不要修改 oh-my-opencode npm 包
- 不要添加新的配置选项
- 不要处理 project 级别的配置（{cwd}/.opencode/oh-my-opencode.json）

---

## Verification Strategy (MANDATORY)

### Test Decision

- **Infrastructure exists**: YES
- **User wants tests**: NO (用户未要求测试)
- **Framework**: bun test

### If Manual QA Only

**CRITICAL**: 手动验证配置是否正确写入和生效

---

## Task Flow

```
Task 1 (添加常量和函数) → Task 2 (调用函数) → Task 3 (验证)
```

## Parallelization

| Task | Depends On | Reason         |
| ---- | ---------- | -------------- |
| 2    | 1          | 需要先定义函数 |
| 3    | 2          | 需要先完成修改 |

---

## TODOs

- [ ] 1. 添加内置 oh-my-opencode 配置常量和写入函数

  **What to do**:
  - 在 `packages/opencode/src/config/config.ts` 文件顶部（namespace Config 内）添加常量 `BUILTIN_OH_MY_OPENCODE_CONFIG`，包含完整的 JSON 配置
  - 添加异步函数 `writeBuiltinOhMyOpencodeConfig()`，将配置写入 `path.join(Global.Path.config, "oh-my-opencode.json")`

  **Must NOT do**:
  - 不要添加任何条件判断，总是覆盖现有文件

  **Parallelizable**: NO (第一步)

  **References** (CRITICAL - Be Exhaustive):

  **Pattern References** (existing code to follow):
  - `packages/opencode/src/config/config.ts:1-30` - 文件顶部的 import 语句和 namespace 开始位置
  - `packages/opencode/src/global/index.ts:13-25` - Global.Path.config 的定义

  **API/Type References** (contracts to implement against):
  - `Bun.write()` - 用于写入文件

  **配置内容** (直接使用):

  ```json
  {
    "agents": {
      "sisyphus": {
        "model": "my-claude/claude-opus-4-5-thinking",
        "temperature": 0.1,
        "thinking": { "type": "enabled", "budgetTokens": 32000 }
      },
      "atlas": { "model": "my-claude/claude-sonnet-4-5-thinking", "temperature": 0.1 },
      "prometheus": { "model": "my-claude/claude-opus-4-5-thinking", "enabled": true, "replace_plan": true },
      "metis": { "model": "my-claude/claude-opus-4-5-thinking", "temperature": 0.3 },
      "momus": { "model": "my-claude/claude-opus-4-5-thinking", "temperature": 0.1 },
      "oracle": { "model": "my-gpt/gpt-5.2", "temperature": 0.1, "reasoningEffort": "medium", "textVerbosity": "high" },
      "librarian": { "model": "my-claude/claude-sonnet-4-5-thinking", "temperature": 0.1 },
      "explore": { "model": "my-gemini/gemini-3-flash", "temperature": 0.1 },
      "frontend-ui-ux-engineer": { "model": "my-gemini/gemini-3-pro-high", "temperature": 0.7 },
      "document-writer": { "model": "my-gemini/gemini-3-flash", "temperature": 0.7 },
      "multimodal-looker": { "model": "my-gemini/gemini-3-flash", "temperature": 0.1 },
      "sisyphus-junior": { "model": "my-claude/claude-sonnet-4-5-thinking", "temperature": 0.1 }
    },
    "categories": {
      "visual-engineering": { "model": "my-gemini/gemini-3-pro-high", "temperature": 0.7 },
      "ultrabrain": { "model": "my-gpt/gpt-5.2", "temperature": 0.1, "variant": "xhigh" },
      "artistry": { "model": "my-gemini/gemini-3-pro-high", "temperature": 0.9, "variant": "max" },
      "quick": { "model": "my-claude/claude-haiku-4-5", "temperature": 0.5 },
      "most-capable": { "model": "my-claude/claude-opus-4-5-thinking", "temperature": 0.3 },
      "writing": { "model": "my-gemini/gemini-3-flash", "temperature": 0.7 },
      "general": { "model": "my-claude/claude-sonnet-4-5-thinking", "temperature": 0.5 },
      "unspecified-low": { "model": "my-claude/claude-sonnet-4-5-thinking", "temperature": 0.5 },
      "unspecified-high": { "model": "my-claude/claude-opus-4-5-thinking", "temperature": 0.3, "variant": "max" }
    },
    "disabled_hooks": ["comment-checker", "startup-toast"],
    "disabled_mcps": [],
    "lsp": {
      "typescript-language-server": {
        "command": ["typescript-language-server", "--stdio"],
        "extensions": [".ts", ".tsx"],
        "priority": 10
      }
    },
    "experimental": {
      "preemptive_compaction_threshold": 0.85,
      "auto_resume": true
    }
  }
  ```

  **Acceptance Criteria**:

  **Manual Execution Verification:**
  - [ ] 检查 `packages/opencode/src/config/config.ts` 中存在 `BUILTIN_OH_MY_OPENCODE_CONFIG` 常量
  - [ ] 检查 `writeBuiltinOhMyOpencodeConfig` 函数定义正确
  - [ ] 运行 `bun run typecheck` 确保无类型错误

  **Commit**: NO (与 Task 2 一起提交)

---

- [ ] 2. 在 oh-my-opencode 插件启用时调用写入函数

  **What to do**:
  - 在 `packages/opencode/src/config/config.ts` 中，找到 `result.plugin.push("oh-my-opencode")` 所在位置（约第 102-103 行）
  - 在 push 语句后添加 `await writeBuiltinOhMyOpencodeConfig()` 调用

  **Must NOT do**:
  - 不要删除现有的注释
  - 不要改变其他逻辑

  **Parallelizable**: NO (依赖 Task 1)

  **References** (CRITICAL - Be Exhaustive):

  **Pattern References** (existing code to follow):
  - `packages/opencode/src/config/config.ts:98-108` - 当前 oh-my-opencode 插件处理逻辑

  **Acceptance Criteria**:

  **Manual Execution Verification:**
  - [ ] 运行 `bun run typecheck` 确保无类型错误

  **Commit**: YES
  - Message: `feat(config): add builtin oh-my-opencode config injection`
  - Files: `packages/opencode/src/config/config.ts`
  - Pre-commit: `bun run typecheck`

---

- [ ] 3. 验证配置写入和生效

  **What to do**:
  - 启动 opencode 并确认配置已写入
  - 检查 `~/.config/opencode/oh-my-opencode.json` 内容是否正确

  **Parallelizable**: NO (依赖 Task 2)

  **References**:
  - `/Users/chensen/.config/opencode/oh-my-opencode.json` - 验证写入的配置文件

  **Acceptance Criteria**:

  **Manual Execution Verification:**
  - [ ] 运行 `bun run --conditions=browser ./src/index.ts` 启动 opencode
  - [ ] 检查 `~/.config/opencode/oh-my-opencode.json` 文件内容
  - [ ] 确认配置包含所有预期的 agents 和 categories

  **Commit**: NO (无代码修改)

---

## Commit Strategy

| After Task | Message                                                     | Files     | Verification      |
| ---------- | ----------------------------------------------------------- | --------- | ----------------- |
| 2          | `feat(config): add builtin oh-my-opencode config injection` | config.ts | bun run typecheck |

---

## Success Criteria

### Verification Commands

```bash
# 检查类型
bun run typecheck

# 启动 opencode（在 packages/opencode 目录）
bun run --conditions=browser ./src/index.ts

# 检查配置文件
cat ~/.config/opencode/oh-my-opencode.json | jq .
```

### Final Checklist

- [ ] 配置常量正确定义
- [ ] 写入函数正确实现
- [ ] 每次启动时配置被覆盖
- [ ] 无类型错误
