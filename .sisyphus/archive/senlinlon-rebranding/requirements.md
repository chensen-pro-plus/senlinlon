# 需求和决策记录

> **项目**: OpenCode → Senlinlon 品牌重塑
> **创建时间**: 2026-01-29

---

## 用户原始需求

用户对 OpenCode 项目进行了二次开发，想要：

1. 区分原版 OpenCode 和二次开发版本（两个独立的产品）
2. 用户可以同时安装和使用两款产品，互不干扰

---

## 已确认的配置信息

### 品牌标识

| 项目               | 值                                            |
| ------------------ | --------------------------------------------- |
| 新产品名称（小写） | `senlinlon`                                   |
| 产品显示名         | `Senlinlon`                                   |
| npm scope          | `@senlinlon`                                  |
| GitHub 仓库        | `chensen-pro-plus/opencode-senlinlon-Publish` |
| Desktop bundle ID  | `ai.senlinlon.desktop`                        |
| 环境变量前缀       | `SENLINLON_*`                                 |

---

## 技术决策

### Q1: 配置兼容性

- **问题**: 是否需要保持与原版 OpenCode 的配置兼容性？
- **选项**: 完全独立 / 迁移兼容
- **决定**: ✅ **完全独立** - 新产品不读取原版配置，完全隔离

### Q2: 环境变量前缀

- **问题**: 环境变量前缀使用什么？
- **选项**: `SENLINLON_*` / `SLL_*`
- **决定**: ✅ **SENLINLON\_\*** - 使用完整名称，更易识别

### Q3: npm 发布计划

- **问题**: 是否计划将新产品发布到 npm registry？
- **选项**: 计划发布 / 仅内部使用
- **决定**: ✅ **计划发布** - 将发布到公共 npm registry

### Q4: Desktop 分发方式

- **问题**: Desktop 应用如何分发？
- **选项**: GitHub Releases / 离线分发
- **决定**: ✅ **GitHub Releases** - 使用 GitHub Releases 进行更新

### Q5: VS Code 扩展处理

- **问题**: VS Code 扩展如何处理？
- **选项**: 重命名并发布 / 删除 / 后续处理
- **决定**: ⏸️ **后续处理** - 本次不修改，以后单独处理

---

## 范围边界

### IN SCOPE ✅

- 所有源代码中的品牌标识
- package.json 中的包名和 scope（20+ 个文件）
- 环境变量前缀（30+ 个变量）
- XDG 目录名
- 项目级 `.opencode/` 目录名
- 配置文件名 `opencode.json`
- Desktop 应用标识和名称
- 更新端点 URL
- bin 脚本和二进制文件名
- Tauri sidecar 路径

### OUT OF SCOPE ❌

- VS Code 扩展（`/sdks/vscode/` 目录）
- 应用图标设计
- 代码签名证书配置
- 历史 git 提交重写
- 文档内容全面翻译/重写

---

## 验证策略

用户选择了 **端到端验证**，包括：

1. `bun install` - 安装依赖
2. `bun run typecheck` - 类型检查
3. `bun run build` - 构建 CLI
4. `bun test` - 运行测试
5. CLI 命令可执行验证
