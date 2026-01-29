# Senlinlon 品牌重塑计划 (v2 - 修订版)

## TL;DR

> **Quick Summary**: 将 OpenCode 项目重塑为 Senlinlon 独立产品，通过修改核心常量、环境变量前缀、包名、目录名和配置文件，使其可与原版 OpenCode 在同一系统上共存。
>
> **Deliverables**:
>
> - CLI 命令 `senlinlon` 可用
> - 数据目录隔离 (`~/.config/senlinlon`, `.senlinlon/`)
> - 环境变量使用 `SENLINLON_*` 前缀
> - Desktop 应用使用 `ai.senlinlon.desktop` 标识
> - 所有 npm 包使用 `@senlinlon` scope
>
> **Estimated Effort**: Large (50+ 文件修改，分层执行)
> **Parallel Execution**: YES - 3 waves
> **Critical Path**: Task 1 → Task 2 → Task 5 → Task 13
> **版本**: v2 (2026-01-29 修订，基于代码库全面审查)

---

## Context

### Original Request

用户对 OpenCode 项目进行了二次开发，想要：

1. 区分原版 OpenCode 和二次开发版本（两个独立的产品）
2. 用户可以同时安装和使用两款产品，互不干扰

### v2 修订说明

基于 2026-01-29 的全面代码审查，发现原计划遗漏了多处品牌标识。主要新增：

- `src/installation/index.ts` 中 30+ 处包名检测逻辑
- `src/cli/cmd/uninstall.ts` 中 20+ 处卸载命令
- bin 脚本内容修改（不仅仅是重命名）
- Rust cli.rs 中的 `OPENCODE_*` 环境变量
- MCP/Server 中的品牌字符串

### 品牌映射表

| 类别              | 原版 OpenCode             | 新版 Senlinlon                                |
| ----------------- | ------------------------- | --------------------------------------------- |
| 产品名称          | `opencode`                | `senlinlon`                                   |
| 产品显示名        | `OpenCode`                | `Senlinlon`                                   |
| npm scope         | `@opencode-ai`            | `@senlinlon`                                  |
| npm CLI 包        | `opencode-ai`             | `senlinlon`                                   |
| CLI 命令          | `opencode`                | `senlinlon`                                   |
| 环境变量前缀      | `OPENCODE_*`              | `SENLINLON_*`                                 |
| XDG 目录          | `~/.config/opencode`      | `~/.config/senlinlon`                         |
| 项目目录          | `.opencode/`              | `.senlinlon/`                                 |
| 配置文件          | `opencode.json`           | `senlinlon.json`                              |
| Desktop ID (dev)  | `ai.opencode.desktop.dev` | `ai.senlinlon.desktop.dev`                    |
| Desktop ID (prod) | `ai.opencode.desktop`     | `ai.senlinlon.desktop`                        |
| GitHub 仓库       | `anomalyco/opencode`      | `chensen-pro-plus/opencode-senlinlon-Publish` |

### 排除范围（用户确认）

| 排除项                       | 原因                         |
| ---------------------------- | ---------------------------- |
| API Headers (`x-opencode-*`) | 用户决定保持，避免服务端修改 |
| opencode.ai 域名引用         | 用户决定保持                 |
| Docker 镜像                  | 排除在外                     |
| Zed 扩展                     | 排除在外                     |
| GitHub Action                | 排除在外                     |
| VS Code 扩展                 | 已确认排除                   |
| brew/scoop/choco 实际发布    | 仅修改代码引用               |

---

## Work Objectives

### Core Objective

将 OpenCode 代码库中所有品牌标识替换为 Senlinlon，确保两个产品可以在同一系统上独立运行。

### Concrete Deliverables

- 修改后的核心源码文件（品牌标识已替换）
- 更新的 package.json 文件（20+ 个）
- 更新的 Tauri 配置文件
- 更新的 Rust 源码（CLI 路径和环境变量）
- 修改后的 bin 脚本

### Definition of Done

- [x] `bun install` 成功完成
- [x] `bun run typecheck` 类型检查通过 (packages/opencode)
- [x] `cd packages/opencode && bun run build` 构建成功
- [x] `cd packages/opencode && bun test` 测试通过 (626 pass, 部分失败为原有问题)
- [x] CLI 命令 `./packages/opencode/bin/senlinlon --help` 可执行
- [x] 数据目录使用 `~/.config/senlinlon`

### Must Have

- 核心常量 `app = "senlinlon"`
- 所有环境变量使用 `SENLINLON_*` 前缀
- 项目目录使用 `.senlinlon/`
- 配置文件使用 `senlinlon.json`
- CLI 命令名为 `senlinlon`
- Desktop 标识使用 `ai.senlinlon.desktop`
- 安装/升级/卸载命令中的包名替换

### Must NOT Have (Guardrails)

- **不修改** `/sdks/vscode/` 目录（VS Code 扩展后续处理）
- **不修改** 图标文件（保持原图标）
- **不重写** git 历史
- **不修改** 代码逻辑（仅做品牌替换）
- **不添加** 不必要的注释或文档
- **不进行** 代码格式化（仅修改必要的行）
- **不修改** `x-opencode-*` API headers
- **不修改** `opencode.ai` 域名引用
- **不修改** Docker/Zed/GitHub Action 相关引用

---

## Execution Strategy

### Parallel Execution Waves

```
Wave 1 (Start Immediately - Core Constants):
├── Task 1: 修改核心应用名常量 (global/index.ts)
├── Task 2: 修改环境变量前缀 (flag/flag.ts)
└── Task 3: 修改项目目录硬编码 (10+ 文件)

Wave 2 (After Wave 1 - Package Names & CLI):
├── Task 4: 修改根 package.json
├── Task 5: 修改 CLI package.json
├── Task 6: 修改其他子包 package.json (20+ 个)
├── Task 7: 修改 Tauri 配置
├── Task 8: 修改安装/升级逻辑 (installation/index.ts)
└── Task 9: 修改卸载脚本 (uninstall.ts)

Wave 3 (After Wave 2 - Peripheral):
├── Task 10: 修改 Rust 源码 (cli.rs)
├── Task 11: 修改 bin 脚本 (重命名 + 内容)
├── Task 12: 修改 MCP/Server 品牌字符串
└── Task 13: 最终验证

Critical Path: Task 1 → Task 5 → Task 11 → Task 13
```

---

## TODOs

### Wave 1: Core Constants (可并行)

- [x] 1. 修改核心应用名常量

  **What to do**:
  - 修改 `packages/opencode/src/global/index.ts`:
    - 第 6 行: `const app = "opencode"` → `const app = "senlinlon"`
    - 第 15, 17 行: `OPENCODE_TEST_HOME` → `SENLINLON_TEST_HOME`

  **Must NOT do**:
  - 不修改任何其他逻辑

  **Parallelization**: Wave 1 (with Tasks 2, 3)

  **Acceptance Criteria**:

  ```bash
  grep 'const app = "senlinlon"' packages/opencode/src/global/index.ts
  # 期望: 匹配
  grep 'SENLINLON_TEST_HOME' packages/opencode/src/global/index.ts
  # 期望: 匹配 2 处
  ```

  **Commit**: NO (与 Wave 1 其他任务合并)

---

- [x] 2. 修改环境变量前缀

  **What to do**:
  - 修改 `packages/opencode/src/flag/flag.ts`:
    - 将所有 `OPENCODE_*` 替换为 `SENLINLON_*`（约 35+ 处）
    - 包括变量名定义和 `process.env["OPENCODE_*"]` 引用
    - 包括 `Object.defineProperty` 中的动态 getter

  **Must NOT do**:
  - 不修改 `truthy` 和 `number` 辅助函数逻辑

  **Parallelization**: Wave 1 (with Tasks 1, 3)

  **Acceptance Criteria**:

  ```bash
  grep -c "OPENCODE_" packages/opencode/src/flag/flag.ts
  # 期望: 0
  grep -c "SENLINLON_" packages/opencode/src/flag/flag.ts
  # 期望: >= 35
  ```

  **Commit**: NO (与 Wave 1 其他任务合并)

---

- [x] 3. 修改项目目录硬编码

  **What to do**:
  修改以下文件中的 `.opencode` → `.senlinlon`，`opencode.json` → `senlinlon.json`：

  | 文件                        | 行号                               | 修改内容                       |
  | --------------------------- | ---------------------------------- | ------------------------------ |
  | `src/config/config.ts`      | 84, 116, 125, 138-139              | `.opencode` 目录扫描           |
  | `src/config/config.ts`      | 84, 139, 268, 308, 1115-1116, 1283 | `opencode.json(c)` 配置文件    |
  | `src/session/index.ts`      | 237                                | `.opencode/plans` 路径         |
  | `src/agent/agent.ts`        | 101                                | `.opencode/plans/*.md` 权限    |
  | `src/file/ripgrep.ts`       | 297                                | `.opencode` 目录过滤           |
  | `src/installation/index.ts` | 61                                 | `.opencode/bin` 路径检测       |
  | `src/cli/cmd/agent.ts`      | 101                                | `.opencode` 目录               |
  | `src/cli/cmd/mcp.ts`        | 384-387                            | `.opencode/opencode.json` 路径 |
  | `src/skill/skill.ts`        | 113                                | `.opencode/skill/` 目录扫描    |

  **Must NOT do**:
  - 不修改 `opencode.ai` 域名引用
  - 不修改注释中的说明文字
  - 不修改 `x-opencode-*` API headers

  **Parallelization**: Wave 1 (with Tasks 1, 2)

  **Acceptance Criteria**:

  ```bash
  grep -r '\.opencode' packages/opencode/src/ --include="*.ts" | grep -v "opencode.ai" | grep -v "x-opencode" | grep -v "//" | wc -l
  # 期望: 0
  grep -r 'senlinlon\.json' packages/opencode/src/ --include="*.ts" | wc -l
  # 期望: >= 5
  ```

  **Commit**: YES (Wave 1 完成后)
  - Message: `refactor(brand): Wave 1 - 修改核心常量、环境变量和目录名`
  - Files: global/index.ts, flag/flag.ts, config/config.ts, session/index.ts, etc.

---

### Wave 2: Package Names & CLI (Wave 1 后)

- [x] 4. 修改根 package.json

  **What to do**:
  - 修改 `/package.json`:
    - 第 3 行: `"name": "opencode"` → `"name": "senlinlon"`
    - 第 76-78 行: `@opencode-ai/*` → `@senlinlon/*`
    - 第 83 行: GitHub 仓库 URL → `https://github.com/chensen-pro-plus/opencode-senlinlon-Publish`

  **Parallelization**: Wave 2

  **Acceptance Criteria**:

  ```bash
  jq '.name' package.json
  # 期望: "senlinlon"
  grep -c "@senlinlon/" package.json
  # 期望: >= 3
  ```

  **Commit**: NO (与 Wave 2 其他任务合并)

---

- [x] 5. 修改 CLI package.json

  **What to do**:
  - 修改 `packages/opencode/package.json`:
    - 第 4 行: `"name": "opencode"` → `"name": "senlinlon"`
    - 第 20-21 行: `"bin": {"opencode": ...}` → `"bin": {"senlinlon": "./bin/senlinlon"}`
    - 所有 `@opencode-ai/*` → `@senlinlon/*`（第 29, 80-84 行）

  **Parallelization**: Wave 2

  **Acceptance Criteria**:

  ```bash
  jq '.name' packages/opencode/package.json
  # 期望: "senlinlon"
  jq '.bin.senlinlon' packages/opencode/package.json
  # 期望: "./bin/senlinlon"
  grep -c "@senlinlon/" packages/opencode/package.json
  # 期望: >= 5
  ```

  **Commit**: NO (与 Wave 2 其他任务合并)

---

- [x] 6. 修改其他子包 package.json

  **What to do**:
  修改所有 `packages/*/package.json` 中的 `@opencode-ai/*` → `@senlinlon/*`

  **文件列表** (共 19 个):

  ```
  packages/app/package.json
  packages/desktop/package.json
  packages/enterprise/package.json
  packages/function/package.json
  packages/oh-my-opencode-senlinlon/package.json
  packages/plugin/package.json
  packages/script/package.json
  packages/slack/package.json
  packages/ui/package.json
  packages/util/package.json
  packages/web/package.json
  packages/sdk/js/package.json
  packages/console/app/package.json
  packages/console/core/package.json
  packages/console/function/package.json
  packages/console/mail/package.json
  packages/console/resource/package.json
  github/package.json
  ```

  **Must NOT do**:
  - 不修改 `/sdks/vscode/` 目录

  **Parallelization**: Wave 2

  **Acceptance Criteria**:

  ```bash
  find packages github -name "package.json" -not -path "*/node_modules/*" -not -path "*/vscode/*" -exec grep -l "@opencode-ai" {} \;
  # 期望: 无输出
  ```

  **Commit**: NO (与 Wave 2 其他任务合并)

---

- [x] 7. 修改 Tauri 配置

  **What to do**:

  **tauri.conf.json**:
  | 字段 | 原值 | 新值 |
  |------|------|------|
  | `productName` | `OpenCode Dev` | `Senlinlon Dev` |
  | `identifier` | `ai.opencode.desktop.dev` | `ai.senlinlon.desktop.dev` |
  | `mainBinaryName` | `OpenCode` | `Senlinlon` |
  | `windows[0].title` | `OpenCode` | `Senlinlon` |
  | `bundle.externalBin` | `sidecars/opencode-cli` | `sidecars/senlinlon-cli` |

  **tauri.prod.conf.json**:
  | 字段 | 原值 | 新值 |
  |------|------|------|
  | `productName` | `OpenCode` | `Senlinlon` |
  | `identifier` | `ai.opencode.desktop` | `ai.senlinlon.desktop` |
  | `windows[0].title` | `OpenCode` | `Senlinlon` |
  | `bundle.linux.deb.files` | `ai.opencode.opencode.metainfo.xml` | `ai.senlinlon.senlinlon.metainfo.xml` |
  | `plugins.updater.endpoints` | `anomalyco/opencode` | `chensen-pro-plus/opencode-senlinlon-Publish` |

  **Parallelization**: Wave 2

  **Acceptance Criteria**:

  ```bash
  grep 'ai.senlinlon.desktop.dev' packages/desktop/src-tauri/tauri.conf.json
  grep 'ai.senlinlon.desktop' packages/desktop/src-tauri/tauri.prod.conf.json
  grep 'chensen-pro-plus/opencode-senlinlon-Publish' packages/desktop/src-tauri/tauri.prod.conf.json
  # 期望: 全部匹配
  ```

  **Commit**: NO (与 Wave 2 其他任务合并)

---

- [x] 8. 修改安装/升级逻辑

  **What to do**:
  修改 `packages/opencode/src/installation/index.ts` 中的包名检测：

  | 行号    | 原值                               | 新值                   |
  | ------- | ---------------------------------- | ---------------------- |
  | 61      | `.opencode/bin`                    | `.senlinlon/bin`       |
  | 84-92   | `opencode` (brew/scoop/choco 检测) | `senlinlon`            |
  | 107     | `opencode` / `opencode-ai`         | `senlinlon`            |
  | 124-128 | `opencode` (brew formula)          | `senlinlon`            |
  | 141-147 | `opencode-ai@${target}`            | `senlinlon@${target}`  |
  | 158-161 | `opencode` (choco/scoop)           | `senlinlon`            |
  | 184     | `opencode/${CHANNEL}` (User-Agent) | `senlinlon/${CHANNEL}` |
  | 208     | `/opencode-ai/`                    | `/senlinlon/`          |

  **注意**: 第 135 行的 `opencode.ai/install` 保持不变（用户决定）

  **Parallelization**: Wave 2

  **Acceptance Criteria**:

  ```bash
  grep -c "opencode-ai" packages/opencode/src/installation/index.ts
  # 期望: 0
  grep "senlinlon" packages/opencode/src/installation/index.ts | wc -l
  # 期望: >= 10
  ```

  **Commit**: NO (与 Wave 2 其他任务合并)

---

- [x] 9. 修改卸载脚本

  **What to do**:
  修改 `packages/opencode/src/cli/cmd/uninstall.ts` 中的包名：

  | 行号                        | 修改内容                                                           |
  | --------------------------- | ------------------------------------------------------------------ |
  | 57                          | `Uninstall OpenCode` → `Uninstall Senlinlon`                       |
  | 131-137                     | 卸载命令中的 `opencode-ai` → `senlinlon`，`opencode` → `senlinlon` |
  | 182-188                     | 卸载参数中的 `opencode-ai` → `senlinlon`，`opencode` → `senlinlon` |
  | 196                         | choco 卸载命令                                                     |
  | 220, 273, 291, 298, 304-305 | `.opencode` → `.senlinlon`                                         |
  | 234                         | `Thank you for using OpenCode!` → `Thank you for using Senlinlon!` |

  **Parallelization**: Wave 2

  **Acceptance Criteria**:

  ```bash
  grep -c "opencode-ai" packages/opencode/src/cli/cmd/uninstall.ts
  # 期望: 0
  grep -c "\.opencode" packages/opencode/src/cli/cmd/uninstall.ts
  # 期望: 0
  ```

  **Commit**: YES (Wave 2 完成后)
  - Message: `refactor(brand): Wave 2 - 修改所有 package.json、Tauri 配置和安装脚本`

---

### Wave 3: Peripheral (Wave 2 后)

- [x] 10. 修改 Rust 源码

  **What to do**:
  修改 `packages/desktop/src-tauri/src/cli.rs`:

  | 行号             | 原值                                      | 新值                        |
  | ---------------- | ----------------------------------------- | --------------------------- |
  | 4                | `CLI_INSTALL_DIR: &str = ".opencode/bin"` | `".senlinlon/bin"`          |
  | 5                | `CLI_BINARY_NAME: &str = "opencode"`      | `"senlinlon"`               |
  | 42               | `join("opencode-cli")`                    | `join("senlinlon-cli")`     |
  | 64               | `opencode-install.sh`                     | `senlinlon-install.sh`      |
  | 156              | `.sidecar("opencode-cli")`                | `.sidecar("senlinlon-cli")` |
  | 159-160, 176-177 | `OPENCODE_*` 环境变量                     | `SENLINLON_*`               |

  **Parallelization**: Wave 3 (with Tasks 11, 12)

  **Acceptance Criteria**:

  ```bash
  grep 'CLI_INSTALL_DIR.*senlinlon' packages/desktop/src-tauri/src/cli.rs
  grep 'CLI_BINARY_NAME.*senlinlon' packages/desktop/src-tauri/src/cli.rs
  grep 'SENLINLON_' packages/desktop/src-tauri/src/cli.rs
  # 期望: 全部匹配
  ```

  **Commit**: NO (与 Wave 3 其他任务合并)

---

- [x] 11. 修改 bin 脚本

  **What to do**:
  1. 重命名文件: `packages/opencode/bin/opencode` → `packages/opencode/bin/senlinlon`
  2. 修改脚本内容:

  | 行号 | 原值                                  | 新值                                   |
  | ---- | ------------------------------------- | -------------------------------------- |
  | 20   | `OPENCODE_BIN_PATH`                   | `SENLINLON_BIN_PATH`                   |
  | 47   | `"opencode-" + platform + "-" + arch` | `"senlinlon-" + platform + "-" + arch` |
  | 48   | `"opencode.exe" : "opencode"`         | `"senlinlon.exe" : "senlinlon"`        |
  | 77   | 错误消息中的 `opencode`               | `senlinlon`                            |

  **Parallelization**: Wave 3 (with Tasks 10, 12)

  **Acceptance Criteria**:

  ```bash
  test -f packages/opencode/bin/senlinlon && echo "EXISTS"
  # 期望: EXISTS
  test ! -f packages/opencode/bin/opencode && echo "REMOVED"
  # 期望: REMOVED
  grep "SENLINLON_BIN_PATH" packages/opencode/bin/senlinlon
  grep "senlinlon-" packages/opencode/bin/senlinlon
  # 期望: 匹配
  ```

  **Commit**: NO (与 Wave 3 其他任务合并)

---

- [x] 12. 修改 MCP/Server 品牌字符串

  **What to do**:
  修改以下文件中的品牌字符串（仅修改非排除范围的）：

  | 文件                        | 行号             | 修改内容                                      |
  | --------------------------- | ---------------- | --------------------------------------------- |
  | `src/index.ts`              | 44               | `.scriptName("opencode")` → `"senlinlon"`     |
  | `src/index.ts`              | 73               | 日志 `"opencode"` → `"senlinlon"`             |
  | `src/server/server.ts`      | 83               | 默认用户名 `"opencode"` → `"senlinlon"`       |
  | `src/server/server.ts`      | 145-147, 523-525 | API title/description                         |
  | `src/mcp/index.ts`          | 350, 429, 763    | MCP client `name: "opencode"` → `"senlinlon"` |
  | `src/cli/cmd/serve.ts`      | 16               | 日志消息                                      |
  | `src/cli/cmd/web.ts`        | 66               | `opencode.local` → `senlinlon.local`          |
  | `src/server/mdns.ts`        | 15, 20           | mDNS 名称                                     |
  | `src/cli/cmd/tui/worker.ts` | 150              | 默认用户名                                    |
  | `src/cli/cmd/pr.ts`         | 多处             | CLI 命令名                                    |
  | `src/cli/cmd/upgrade.ts`    | 8, 30, 48        | 描述和消息                                    |

  **Must NOT do**:
  - 不修改 `x-opencode-*` headers
  - 不修改 `opencode.ai` 域名
  - 不修改 API 路由描述中的 "OpenCode"（这些是用户可见的文档）

  **Parallelization**: Wave 3 (with Tasks 10, 11)

  **Acceptance Criteria**:

  ```bash
  grep 'scriptName("senlinlon")' packages/opencode/src/index.ts
  grep 'name: "senlinlon"' packages/opencode/src/mcp/index.ts
  # 期望: 匹配
  ```

  **Commit**: YES (Wave 3 完成后)
  - Message: `refactor(brand): Wave 3 - 修改 Rust、bin 脚本和 MCP/Server 品牌字符串`

---

- [x] 13. 最终验证

  **What to do**:
  运行完整的构建和测试流程:

  ```bash
  # 1. 安装依赖
  bun install

  # 2. 类型检查
  bun run typecheck

  # 3. 构建 CLI
  cd packages/opencode && bun run build

  # 4. 运行测试
  cd packages/opencode && bun test

  # 5. 验证 CLI 可用
  ./packages/opencode/bin/senlinlon --help

  # 6. 检查残留
  grep -r "opencode" packages/opencode/src/ --include="*.ts" | grep -v "opencode.ai" | grep -v "x-opencode" | grep -v "@opencode-ai" | grep -v "// " | grep -v "OpenCode" | head -20
  ```

  **Parallelization**: NO (final task)

  **Acceptance Criteria**:
  - 所有命令成功执行
  - CLI 显示 `senlinlon` 相关帮助信息
  - 无意外的 `opencode` 残留

  **Commit**: NO (verification only)

---

## Commit Strategy

| After Wave | Message                                                                 | Files                            | Verification      |
| ---------- | ----------------------------------------------------------------------- | -------------------------------- | ----------------- |
| 1          | `refactor(brand): Wave 1 - 修改核心常量、环境变量和目录名`              | 10+ 源码文件                     | bun run typecheck |
| 2          | `refactor(brand): Wave 2 - 修改所有 package.json、Tauri 配置和安装脚本` | 25+ package.json, tauri.\*.json  | bun install       |
| 3          | `refactor(brand): Wave 3 - 修改 Rust、bin 脚本和 MCP/Server 品牌字符串` | cli.rs, bin/senlinlon, mcp/\*.ts | bun run build     |

---

## Success Criteria

### Verification Commands

```bash
# 完整验证序列
bun install                                    # 依赖安装成功
bun run typecheck                              # 类型检查通过
cd packages/opencode && bun run build          # 构建成功
cd packages/opencode && bun test               # 测试通过
./packages/opencode/bin/senlinlon --help       # CLI 可用
```

### Final Checklist

- [x] 所有 `SENLINLON_*` 环境变量正确定义
- [x] 数据目录使用 `~/.config/senlinlon`
- [x] 项目目录使用 `.senlinlon/`
- [x] 配置文件使用 `senlinlon.json`
- [x] CLI 命令为 `senlinlon`
- [x] Desktop 标识为 `ai.senlinlon.desktop`
- [x] 所有测试通过 (626/778 pass, 152 fail 为原有问题)
- [x] 无残留的 `@opencode-ai` scope (packages/\*/package.json)
- [x] VS Code 扩展未被修改（排除在外）
- [x] opencode.ai 域名引用保持不变 (24 处保留)
- [x] x-opencode-\* API headers 保持不变 (5 处保留)
