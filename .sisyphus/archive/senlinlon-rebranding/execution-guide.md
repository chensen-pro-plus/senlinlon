# 执行指南

> **项目**: OpenCode → Senlinlon 品牌重塑
> **创建时间**: 2026-01-29

---

## 🚀 快速开始

当您准备好执行此计划时：

```bash
# 进入项目目录
cd /Users/工作2/opencode工作区/opencode

# 启动 Sisyphus 执行器
/start-work
```

---

## 📋 任务清单

### Wave 1: 核心常量（可并行）

- [ ] **Task 1**: 修改核心应用名常量
  - 文件: `packages/opencode/src/global/index.ts`
  - 修改: `const app = "opencode"` → `const app = "senlinlon"`
  - 修改: `OPENCODE_TEST_HOME` → `SENLINLON_TEST_HOME`

- [ ] **Task 2**: 修改环境变量前缀
  - 文件: `packages/opencode/src/flag/flag.ts`
  - 修改: 所有 `OPENCODE_*` → `SENLINLON_*`（30+ 处）

- [ ] **Task 3**: 修改项目目录硬编码
  - 文件: `packages/opencode/src/config/config.ts` 等
  - 修改: `.opencode` → `.senlinlon`
  - 修改: `opencode.json` → `senlinlon.json`

### Wave 2: 包名修改（Wave 1 后）

- [ ] **Task 4**: 修改根 package.json
  - 文件: `package.json`
  - 修改: 包名、scope、仓库 URL

- [ ] **Task 5**: 修改 CLI package.json
  - 文件: `packages/opencode/package.json`
  - 修改: 包名、bin 命令、依赖 scope

- [ ] **Task 6**: 修改其他子包 package.json
  - 文件: 20+ 个 `packages/*/package.json`
  - 修改: 包名、依赖 scope
  - **排除**: `sdks/vscode/package.json`

- [ ] **Task 7**: 修改 Tauri 配置
  - 文件: `tauri.conf.json`, `tauri.prod.conf.json`
  - 修改: productName, identifier, title, endpoints

### Wave 3: 外围修改（Wave 2 后）

- [ ] **Task 8**: 修改 Rust 源码
  - 文件: `packages/desktop/src-tauri/src/cli.rs`
  - 修改: CLI_INSTALL_DIR, CLI_BINARY_NAME

- [ ] **Task 9**: 修改 bin 脚本
  - 操作: 重命名 `bin/opencode` → `bin/senlinlon`

- [ ] **Task 10**: 最终验证
  - 运行: `bun install`, `bun run typecheck`, `bun run build`, `bun test`
  - 验证: CLI 命令可用

---

## ✅ 验证命令

```bash
# 1. 安装依赖
bun install

# 2. 类型检查
bun run typecheck

# 3. 构建 CLI
cd packages/opencode && bun run build

# 4. 运行测试
cd packages/opencode && bun test

# 5. 验证 CLI
./packages/opencode/bin/senlinlon --help

# 6. 检查残留
grep -r "opencode" packages/opencode/src/ --include="*.ts" | grep -v "//" | grep -v "senlinlon"
```

---

## ⚠️ 注意事项

1. **VS Code 扩展已排除** - `/sdks/vscode/` 目录不要修改
2. **不要修改图标** - 保持原图标，后续单独处理
3. **不要修改代码逻辑** - 仅做品牌替换
4. **不要格式化代码** - 仅修改必要的行

---

## 📁 相关文件

- **完整计划**: `.sisyphus/plans/senlinlon-rebranding.md`
- **需求记录**: `.sisyphus/archive/senlinlon-rebranding/requirements.md`
- **研究发现**: `.sisyphus/archive/senlinlon-rebranding/research-findings.md`
