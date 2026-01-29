# 代码库研究发现

> **项目**: OpenCode → Senlinlon 品牌重塑
> **研究时间**: 2026-01-29

---

## 核心品牌标识位置

### 1. 应用名常量 - 最关键的文件

**文件**: `/packages/opencode/src/global/index.ts`

```typescript
// 第 6 行
const app = "opencode"

// 第 15, 17 行 - 引用测试环境变量
process.env.OPENCODE_TEST_HOME
```

**影响范围**:

- 所有 XDG 目录路径（~/.config/opencode, ~/.local/share/opencode 等）
- 缓存目录、日志目录、bin 目录

---

### 2. 环境变量 - 30+ 个变量

**文件**: `/packages/opencode/src/flag/flag.ts`

所有环境变量列表：

- `OPENCODE_AUTO_SHARE`
- `OPENCODE_GIT_BASH_PATH`
- `OPENCODE_CONFIG`
- `OPENCODE_CONFIG_DIR`
- `OPENCODE_CONFIG_CONTENT`
- `OPENCODE_DISABLE_AUTOUPDATE`
- `OPENCODE_DISABLE_PRUNE`
- `OPENCODE_DISABLE_TERMINAL_TITLE`
- `OPENCODE_PERMISSION`
- `OPENCODE_DISABLE_DEFAULT_PLUGINS`
- `OPENCODE_DISABLE_LSP_DOWNLOAD`
- `OPENCODE_ENABLE_EXPERIMENTAL_MODELS`
- `OPENCODE_DISABLE_AUTOCOMPACT`
- `OPENCODE_DISABLE_MODELS_FETCH`
- `OPENCODE_DISABLE_CLAUDE_CODE`
- `OPENCODE_DISABLE_CLAUDE_CODE_PROMPT`
- `OPENCODE_DISABLE_CLAUDE_CODE_SKILLS`
- `OPENCODE_DISABLE_PROJECT_CONFIG`
- `OPENCODE_FAKE_VCS`
- `OPENCODE_CLIENT`
- `OPENCODE_SERVER_PASSWORD`
- `OPENCODE_SERVER_USERNAME`
- `OPENCODE_EXPERIMENTAL`
- `OPENCODE_EXPERIMENTAL_FILEWATCHER`
- `OPENCODE_EXPERIMENTAL_DISABLE_FILEWATCHER`
- `OPENCODE_EXPERIMENTAL_ICON_DISCOVERY`
- `OPENCODE_EXPERIMENTAL_DISABLE_COPY_ON_SELECT`
- `OPENCODE_ENABLE_EXA`
- `OPENCODE_EXPERIMENTAL_BASH_MAX_OUTPUT_LENGTH`
- `OPENCODE_EXPERIMENTAL_BASH_DEFAULT_TIMEOUT_MS`
- `OPENCODE_EXPERIMENTAL_OUTPUT_TOKEN_MAX`
- `OPENCODE_EXPERIMENTAL_OXFMT`
- `OPENCODE_EXPERIMENTAL_LSP_TY`
- `OPENCODE_EXPERIMENTAL_LSP_TOOL`
- `OPENCODE_DISABLE_FILETIME_CHECK`
- `OPENCODE_EXPERIMENTAL_PLAN_MODE`
- `OPENCODE_MODELS_URL`

---

### 3. 项目目录 `.opencode/` - 分散硬编码

**关键发现**: 没有中央常量定义，需要在多个文件中替换

| 文件               | 行号 | 内容                                      |
| ------------------ | ---- | ----------------------------------------- |
| `config/config.ts` | 84   | `opencode.jsonc`, `opencode.json`         |
| `config/config.ts` | 116  | `targets: [".opencode"]`                  |
| `config/config.ts` | 125  | `targets: [".opencode"]`                  |
| `config/config.ts` | 138  | `dir.endsWith(".opencode")`               |
| `session/index.ts` | -    | `.opencode/plans` 路径                    |
| `cli/cmd/agent.ts` | -    | `.opencode` 目录                          |
| `cli.rs` (Rust)    | 4    | `CLI_INSTALL_DIR: &str = ".opencode/bin"` |
| `cli.rs` (Rust)    | 5    | `CLI_BINARY_NAME: &str = "opencode"`      |

---

### 4. npm 包结构

#### 已发布的包（影响外部用户）

| 当前名称              | 新名称              | 说明                     |
| --------------------- | ------------------- | ------------------------ |
| `opencode-ai`         | `senlinlon`         | CLI 在 npm 上的发布名    |
| `@opencode-ai/sdk`    | `@senlinlon/sdk`    | 供第三方开发者构建客户端 |
| `@opencode-ai/plugin` | `@senlinlon/plugin` | 供第三方开发者编写插件   |
| `opencode` (VS Code)  | 后续处理            | VS Code 扩展             |

#### 内部包（需同步更新 workspace 引用）

| 当前名称                                | 新名称                                |
| --------------------------------------- | ------------------------------------- |
| `@opencode-ai/ui`                       | `@senlinlon/ui`                       |
| `@opencode-ai/util`                     | `@senlinlon/util`                     |
| `@opencode-ai/app`                      | `@senlinlon/app`                      |
| `@opencode-ai/desktop`                  | `@senlinlon/desktop`                  |
| `@opencode-ai/web`                      | `@senlinlon/web`                      |
| `@opencode-ai/script`                   | `@senlinlon/script`                   |
| `@opencode-ai/slack`                    | `@senlinlon/slack`                    |
| `@opencode-ai/enterprise`               | `@senlinlon/enterprise`               |
| `@opencode-ai/function`                 | `@senlinlon/function`                 |
| `@opencode-ai/console-core`             | `@senlinlon/console-core`             |
| `@opencode-ai/console-app`              | `@senlinlon/console-app`              |
| `@opencode-ai/console-mail`             | `@senlinlon/console-mail`             |
| `@opencode-ai/console-function`         | `@senlinlon/console-function`         |
| `@opencode-ai/console-resource`         | `@senlinlon/console-resource`         |
| `@opencode-ai/oh-my-opencode-senlinlon` | `@senlinlon/oh-my-opencode-senlinlon` |

---

### 5. Tauri Desktop 配置

#### 开发环境 (`tauri.conf.json`)

| 字段             | 当前值                    | 新值                       |
| ---------------- | ------------------------- | -------------------------- |
| `productName`    | `OpenCode Dev`            | `Senlinlon Dev`            |
| `identifier`     | `ai.opencode.desktop.dev` | `ai.senlinlon.desktop.dev` |
| `mainBinaryName` | `OpenCode`                | `Senlinlon`                |
| `title`          | `OpenCode`                | `Senlinlon`                |
| `externalBin`    | `sidecars/opencode-cli`   | `sidecars/senlinlon-cli`   |

#### 生产环境 (`tauri.prod.conf.json`)

| 字段              | 当前值                 | 新值                                          |
| ----------------- | ---------------------- | --------------------------------------------- |
| `productName`     | `OpenCode`             | `Senlinlon`                                   |
| `identifier`      | `ai.opencode.desktop`  | `ai.senlinlon.desktop`                        |
| `title`           | `OpenCode`             | `Senlinlon`                                   |
| `endpoints`       | `anomalyco/opencode`   | `chensen-pro-plus/opencode-senlinlon-Publish` |
| `linux.deb.files` | `ai.opencode.opencode` | `ai.senlinlon.senlinlon`                      |

---

### 6. GitHub 仓库引用

约 168 处引用 `anomalyco/opencode`，主要分布在：

- 文档文件 (`*.md`, `*.mdx`)
- 配置文件 (`tauri.*.conf.json`)
- CI/CD 工作流 (`.github/workflows/`)
- README 文件

---

## 修改策略建议

### Wave 1: 核心常量（可并行）

1. `global/index.ts` - 应用名常量
2. `flag/flag.ts` - 环境变量前缀
3. `config/config.ts` + 其他 - 项目目录硬编码

### Wave 2: 包名（Wave 1 后）

4. 根 `package.json`
5. CLI `package.json`
6. 所有子包 `package.json` (20+)
7. Tauri 配置

### Wave 3: 外围（Wave 2 后）

8. Rust 源码
9. bin 脚本重命名
10. 最终验证
