# 集成 oh-my-opencode 到 opencode (重命名为 oh-my-opencode-senlinlon)

## Context

### Original Request

将 oh-my-opencode 作为 Monorepo workspace 内置到 opencode 项目中，重命名包名为 `oh-my-opencode-senlinlon`，无需通过 npm 安装。

### Interview Summary

**Key Discussions**:

- 包名改为 `@opencode-ai/oh-my-opencode-senlinlon`
- GitHub 用户名：`senlinlon`
- 配置文件名：`oh-my-opencode-senlinlon.json`
- 删除 CLI 安装器功能（已内置无需安装）
- Schema URL 使用相对路径
- 测试文件保留但标记为 broken
- 保持 `@code-yeongyu/comment-checker` 依赖
- 保留 `.github/` 目录不修改
- 保持原作者信息

**Research Findings**:

- OpenCode 使用 Bun Workspaces + Turborepo
- 插件通过 `INTERNAL_PLUGINS` 数组加载
- 依赖使用 `workspace:*` 和 `catalog:` 语法
- oh-my-opencode 有 53+ 文件需要字符串替换

### Metis Review

**Identified Gaps** (addressed):

- Schema URL 策略：改用相对路径
- 测试文件处理：保留但标记 broken
- 依赖版本冲突：验证 zod 等版本兼容
- 运行时路径：更新缓存目录路径

---

## Work Objectives

### Core Objective

将 oh-my-opencode 完整集成到 opencode monorepo 中，作为内置插件加载，无需用户单独安装。

### Concrete Deliverables

- `packages/oh-my-opencode-senlinlon/` - 新的 workspace 包
- 修改后的 `packages/opencode/src/plugin/index.ts` - 导入新插件
- 更新的依赖配置

### Definition of Done

- [x] `bun install` 在 opencode 根目录成功
- [x] `bun run typecheck` 在根目录通过
- [x] `cd packages/oh-my-opencode-senlinlon && bun run build` 成功
- [x] 启动 opencode 时插件正常加载（日志可见）
- [x] `~/.config/opencode/oh-my-opencode-senlinlon.json` 配置文件被识别

### Must Have

- 包名为 `@opencode-ai/oh-my-opencode-senlinlon`
- 所有 `oh-my-opencode` 相关路径/名称替换为 `oh-my-opencode-senlinlon`
- 所有 `code-yeongyu` GitHub 引用替换为 `senlinlon`
- 删除 CLI 相关代码（`src/cli/`, `bin/`, `postinstall.mjs`）
- 删除平台二进制包目录（`packages/`）
- 删除 `optionalDependencies`

### Must NOT Have (Guardrails)

- 不修改 oh-my-opencode 的任何功能逻辑
- 不修改 opencode 核心代码（仅限 plugin/index.ts 导入）
- 不修改测试文件内容（仅删除或保留）
- 不修改代码风格、格式、缩进
- 不添加新功能或"改进"
- 不删除原作者署名/版权信息
- 不替换注释中对原项目历史的引用

---

## Verification Strategy (MANDATORY)

### Test Decision

- **Infrastructure exists**: YES (Bun test)
- **User wants tests**: Tests-after (保留但标记 broken)
- **Framework**: bun test

### Manual Execution Verification

**For Package Build:**

- [x] Command: `cd packages/oh-my-opencode-senlinlon && bun run build`
- [x] Expected: 无错误，生成 `dist/` 目录

**For TypeScript:**

- [x] Command: `bun run typecheck` (根目录)
- [x] Expected: 无类型错误

**For Plugin Loading:**

- [x] Command: `bun run dev` (根目录)
- [x] Expected: 日志显示 `"loading internal plugin"` 包含 `OhMyOpenCodePlugin`

**For Config Recognition:**

- [x] 创建 `~/.config/opencode/oh-my-opencode-senlinlon.json` 测试文件
- [x] 启动 opencode，验证配置被读取

---

## Task Flow

```
Task 1 (Copy & Delete)
    ↓
Task 2 (Package.json)
    ↓
Task 3 (String Replacements)
    ↓
Task 4 (CLI Removal)
    ↓
Task 5 (opencode Dependencies)
    ↓
Task 6 (Plugin Integration)
    ↓
Task 7 (Build & Verify)
```

## Parallelization

| Group | Tasks            | Reason                   |
| ----- | ---------------- | ------------------------ |
| -     | 所有任务顺序执行 | 每个任务依赖前一个的完成 |

---

## TODOs

### Phase 1: 复制与清理

- [x] 1. 复制 oh-my-opencode 到 packages 目录并删除不需要的文件

  **What to do**:
  1. 复制 `/Users/工作2/opencode工作区/oh-my-opencode` 到 `/Users/工作2/opencode工作区/opencode/packages/oh-my-opencode-senlinlon`
  2. 删除 `packages/oh-my-opencode-senlinlon/packages/` 目录（平台二进制包）
  3. 删除 `packages/oh-my-opencode-senlinlon/bin/` 目录（CLI 入口）
  4. 删除 `packages/oh-my-opencode-senlinlon/postinstall.mjs`
  5. 删除 `packages/oh-my-opencode-senlinlon/node_modules/`（如存在）
  6. 删除 `packages/oh-my-opencode-senlinlon/dist/`（如存在）
  7. 删除 `packages/oh-my-opencode-senlinlon/bun.lock`（如存在）

  **Must NOT do**:
  - 不删除 `.github/` 目录
  - 不删除测试文件
  - 不删除文档文件

  **Parallelizable**: NO (第一个任务)

  **References**:
  - `/Users/工作2/opencode工作区/oh-my-opencode/` - 源目录
  - `/Users/工作2/opencode工作区/opencode/packages/` - 目标目录

  **Acceptance Criteria**:
  - [ ] `ls packages/oh-my-opencode-senlinlon/src` 显示源文件
  - [ ] `ls packages/oh-my-opencode-senlinlon/packages` 失败（目录不存在）
  - [ ] `ls packages/oh-my-opencode-senlinlon/bin` 失败（目录不存在）
  - [ ] `test -f packages/oh-my-opencode-senlinlon/postinstall.mjs` 失败

  **Commit**: NO (与后续任务合并)

---

### Phase 2: Package.json 更新

- [x] 2. 修改 oh-my-opencode-senlinlon 的 package.json

  **What to do**:
  1. 修改 `name` 为 `"@opencode-ai/oh-my-opencode-senlinlon"`
  2. 添加 `"private": true`
  3. 删除 `bin` 字段
  4. 删除 `optionalDependencies` 字段
  5. 删除 `postinstall` 脚本
  6. 修改 `scripts.build` 移除 CLI 构建部分
  7. 修改 `dependencies`:
     - `"@opencode-ai/plugin": "^1.1.19"` → `"@opencode-ai/plugin": "workspace:*"`
     - `"@opencode-ai/sdk": "^1.1.19"` → `"@opencode-ai/sdk": "workspace:*"`
     - `"zod": "^4.1.8"` → `"zod": "catalog:"`
  8. 修改 `repository.url` 为 `"git+https://github.com/senlinlon/oh-my-opencode-senlinlon.git"`
  9. 修改 `bugs.url` 为 `"https://github.com/senlinlon/oh-my-opencode-senlinlon/issues"`
  10. 修改 `homepage` 为 `"https://github.com/senlinlon/oh-my-opencode-senlinlon#readme"`
  11. 删除 `files` 字段（workspace 包不需要）
  12. 删除 `trustedDependencies` 字段

  **Must NOT do**:
  - 不修改 `author` 字段
  - 不删除 `license` 字段
  - 不删除非 CLI 相关的依赖

  **Parallelizable**: NO (依赖 Task 1)

  **References**:
  - `packages/oh-my-opencode-senlinlon/package.json` - 要修改的文件
  - `packages/plugin/package.json` - workspace 包示例（使用 `workspace:*`）
  - Root `package.json` `workspaces.catalog` - 可用的 catalog 版本

  **Acceptance Criteria**:
  - [ ] `jq '.name' packages/oh-my-opencode-senlinlon/package.json` → `"@opencode-ai/oh-my-opencode-senlinlon"`
  - [ ] `jq '.private' packages/oh-my-opencode-senlinlon/package.json` → `true`
  - [ ] `jq '.bin' packages/oh-my-opencode-senlinlon/package.json` → `null`
  - [ ] `jq '.optionalDependencies' packages/oh-my-opencode-senlinlon/package.json` → `null`
  - [ ] `jq '.dependencies["@opencode-ai/plugin"]' packages/oh-my-opencode-senlinlon/package.json` → `"workspace:*"`
  - [ ] `jq '.dependencies["zod"]' packages/oh-my-opencode-senlinlon/package.json` → `"catalog:"`

  **Commit**: NO (与后续任务合并)

---

### Phase 3: 字符串替换

- [x] 3. 执行全局字符串替换

  **What to do**:
  **注意：按以下顺序执行，避免部分匹配问题**
  1. **配置文件名替换**（精确匹配）:
     - `oh-my-opencode.json` → `oh-my-opencode-senlinlon.json`
     - `oh-my-opencode.jsonc` → `oh-my-opencode-senlinlon.jsonc`

  2. **Schema URL 替换**:
     - `https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json` → `./oh-my-opencode-senlinlon.schema.json`

  3. **缓存/数据目录名替换**:
     - `"oh-my-opencode"` (作为目录名，如 `/.cache/oh-my-opencode/`) → `"oh-my-opencode-senlinlon"`
     - `'oh-my-opencode'` (单引号版本) → `'oh-my-opencode-senlinlon'`

  4. **日志文件名替换**:
     - `oh-my-opencode.log` → `oh-my-opencode-senlinlon.log`

  5. **GitHub 仓库 URL 替换**:
     - `code-yeongyu/oh-my-opencode` → `senlinlon/oh-my-opencode-senlinlon`

  6. **npm 包名替换** (在 CLI 相关文件中，但 CLI 会被删除):
     - 如果有残留引用，替换 `"oh-my-opencode"` (作为包名) → `"oh-my-opencode-senlinlon"`

  7. **Schema 输出路径**:
     - `oh-my-opencode.schema.json` → `oh-my-opencode-senlinlon.schema.json`

  **Must NOT do**:
  - 不替换注释中对原项目历史的引用
  - 不替换 author 信息中的 `YeonGyu-Kim`
  - 不替换 license 文件内容
  - 不替换 `@code-yeongyu/comment-checker`（这是外部依赖包名）
  - 不替换 README 中对原项目的描述（保持原样）

  **Parallelizable**: NO (依赖 Task 2)

  **References**:
  - `packages/oh-my-opencode-senlinlon/src/plugin-config.ts` - 配置文件路径
  - `packages/oh-my-opencode-senlinlon/src/shared/opencode-config-dir.ts` - 配置目录
  - `packages/oh-my-opencode-senlinlon/src/shared/data-path.ts` - 缓存目录
  - `packages/oh-my-opencode-senlinlon/src/shared/logger.ts` - 日志文件名
  - `packages/oh-my-opencode-senlinlon/src/cli/model-fallback.ts` - Schema URL
  - `packages/oh-my-opencode-senlinlon/script/build-schema.ts` - Schema 构建

  **Acceptance Criteria**:
  - [ ] `grep -r "oh-my-opencode\.json" packages/oh-my-opencode-senlinlon/src/ --include="*.ts" | wc -l` → `0`
  - [ ] `grep -r "code-yeongyu/oh-my-opencode" packages/oh-my-opencode-senlinlon/src/ --include="*.ts" | wc -l` → `0`
  - [ ] `grep -r "oh-my-opencode-senlinlon\.json" packages/oh-my-opencode-senlinlon/src/ --include="*.ts" | wc -l` → 大于 0

  **Commit**: NO (与后续任务合并)

---

### Phase 4: CLI 移除

- [x] 4. 删除 CLI 相关代码

  **What to do**:
  1. 删除 `packages/oh-my-opencode-senlinlon/src/cli/` 目录
  2. 检查 `src/index.ts` 是否有 CLI 相关导入，如有则移除
  3. 修改 `package.json` 的 `scripts`:
     - 删除与 CLI 相关的脚本（如 `build:binaries`）
     - 修改 `build` 脚本，移除 CLI 构建部分:
       ```
       原: "build": "bun build src/index.ts --outdir dist ... && bun build src/cli/index.ts ..."
       改: "build": "bun build src/index.ts --outdir dist --target bun --format esm --external @ast-grep/napi && tsc --emitDeclarationOnly && bun run build:schema"
       ```
  4. 删除 CLI 相关依赖（如果仅 CLI 使用）:
     - `commander` - 仅 CLI 使用，删除
     - `detect-libc` - 仅平台检测使用，删除

  **Must NOT do**:
  - 不删除非 CLI 相关的代码
  - 不修改插件核心逻辑

  **Parallelizable**: NO (依赖 Task 3)

  **References**:
  - `packages/oh-my-opencode-senlinlon/src/cli/` - 要删除的目录
  - `packages/oh-my-opencode-senlinlon/src/index.ts` - 检查 CLI 导入
  - `packages/oh-my-opencode-senlinlon/package.json` - 修改 scripts

  **Acceptance Criteria**:
  - [ ] `test -d packages/oh-my-opencode-senlinlon/src/cli` 失败（目录不存在）
  - [ ] `grep -r "from.*cli" packages/oh-my-opencode-senlinlon/src/index.ts | wc -l` → `0`
  - [ ] `jq '.dependencies.commander' packages/oh-my-opencode-senlinlon/package.json` → `null`

  **Commit**: NO (与后续任务合并)

---

### Phase 5: opencode 依赖更新

- [x] 5. 在 opencode 主包添加依赖

  **What to do**:
  1. 修改 `packages/opencode/package.json`:
     - 在 `dependencies` 中添加: `"@opencode-ai/oh-my-opencode-senlinlon": "workspace:*"`
  2. 检查根 `package.json` 的 `workspaces.catalog`，确认需要的依赖版本:
     - 如果 `@clack/prompts` 不在 catalog 中，在新包中使用固定版本
     - 如果 `@ast-grep/napi` 不在 catalog 中，在新包中使用固定版本

  3. 在根目录运行 `bun install` 安装依赖

  **Must NOT do**:
  - 不修改 opencode 其他依赖
  - 不修改根 package.json（除非需要添加新的 catalog 条目）

  **Parallelizable**: NO (依赖 Task 4)

  **References**:
  - `packages/opencode/package.json` - 添加依赖
  - Root `package.json` - 检查 catalog

  **Acceptance Criteria**:
  - [ ] `jq '.dependencies["@opencode-ai/oh-my-opencode-senlinlon"]' packages/opencode/package.json` → `"workspace:*"`
  - [ ] `bun install` 在根目录成功完成

  **Commit**: NO (与后续任务合并)

---

### Phase 6: 插件集成

- [x] 6. 修改 opencode 的 plugin/index.ts 导入新插件

  **What to do**:
  1. 在 `packages/opencode/src/plugin/index.ts` 文件顶部添加导入:
     ```typescript
     import OhMyOpenCodePlugin from "@opencode-ai/oh-my-opencode-senlinlon"
     ```
  2. 修改 `INTERNAL_PLUGINS` 数组:
     ```typescript
     const INTERNAL_PLUGINS: PluginInstance[] = [
       CodexAuthPlugin,
       CopilotAuthPlugin,
       OhMyOpenCodePlugin, // 新增
     ]
     ```

  **Must NOT do**:
  - 不修改其他导入
  - 不修改 Plugin namespace 的其他代码
  - 不添加条件逻辑（始终加载插件）

  **Parallelizable**: NO (依赖 Task 5)

  **References**:
  - `packages/opencode/src/plugin/index.ts:1-22` - 导入区域和 INTERNAL_PLUGINS 定义
  - `packages/opencode/src/plugin/codex.ts` - 现有内部插件示例

  **Acceptance Criteria**:
  - [ ] `grep "OhMyOpenCodePlugin" packages/opencode/src/plugin/index.ts | wc -l` → 至少 2（导入和数组）
  - [ ] `grep "@opencode-ai/oh-my-opencode-senlinlon" packages/opencode/src/plugin/index.ts | wc -l` → 1

  **Commit**: NO (与后续任务合并)

---

### Phase 7: 构建与验证

- [x] 7. 构建并验证集成

  **What to do**:
  1. 在根目录运行类型检查: `bun run typecheck`
  2. 在新包目录构建: `cd packages/oh-my-opencode-senlinlon && bun run build`
  3. 验证构建产物存在: `ls packages/oh-my-opencode-senlinlon/dist/`
  4. 在根目录启动开发模式验证插件加载: `bun run dev`
  5. 检查日志确认插件加载成功

  **Must NOT do**:
  - 如果有错误，不要尝试"修复"超出范围的问题
  - 不要修改代码来通过测试（测试可能需要单独更新）

  **Parallelizable**: NO (最后一个任务)

  **References**:
  - 根目录 `turbo.json` - 构建配置
  - `packages/oh-my-opencode-senlinlon/package.json` - 构建脚本

  **Acceptance Criteria**:
  - [ ] `bun run typecheck` 无错误
  - [ ] `cd packages/oh-my-opencode-senlinlon && bun run build` 成功
  - [ ] `ls packages/oh-my-opencode-senlinlon/dist/index.js` 存在
  - [ ] 启动 opencode 日志显示 `"loading internal plugin"` 包含 `OhMyOpenCodePlugin`

  **Commit**: YES
  - Message: `feat(plugin): integrate oh-my-opencode-senlinlon as internal plugin`
  - Files: 所有修改的文件
  - Pre-commit: `bun run typecheck`

---

## Commit Strategy

| After Task | Message                                                               | Files                                                                                                       | Verification      |
| ---------- | --------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- | ----------------- |
| 7          | `feat(plugin): integrate oh-my-opencode-senlinlon as internal plugin` | packages/oh-my-opencode-senlinlon/\*, packages/opencode/package.json, packages/opencode/src/plugin/index.ts | bun run typecheck |

---

## Success Criteria

### Verification Commands

```bash
# 1. 依赖安装
bun install  # Expected: 成功，无错误

# 2. 类型检查
bun run typecheck  # Expected: 无错误

# 3. 包构建
cd packages/oh-my-opencode-senlinlon && bun run build  # Expected: 成功

# 4. 验证构建产物
ls packages/oh-my-opencode-senlinlon/dist/index.js  # Expected: 文件存在

# 5. 验证字符串替换
grep -r "oh-my-opencode\.json" packages/oh-my-opencode-senlinlon/src/ --include="*.ts"  # Expected: 无结果
grep -r "code-yeongyu/oh-my-opencode" packages/oh-my-opencode-senlinlon/src/ --include="*.ts"  # Expected: 无结果

# 6. 验证删除的文件
test -d packages/oh-my-opencode-senlinlon/packages && echo "FAIL" || echo "OK"  # Expected: OK
test -d packages/oh-my-opencode-senlinlon/bin && echo "FAIL" || echo "OK"  # Expected: OK
test -d packages/oh-my-opencode-senlinlon/src/cli && echo "FAIL" || echo "OK"  # Expected: OK
```

### Final Checklist

- [x] All "Must Have" present
- [x] All "Must NOT Have" absent
- [x] 包名正确为 `@opencode-ai/oh-my-opencode-senlinlon`
- [x] 插件被 opencode 作为内部插件加载
- [x] 配置文件路径使用 `oh-my-opencode-senlinlon.json`
- [x] 无 CLI 相关代码残留
- [x] 无平台二进制包残留
