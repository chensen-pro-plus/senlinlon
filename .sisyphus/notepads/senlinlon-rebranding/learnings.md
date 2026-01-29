# Senlinlon Rebranding - Learnings

## Conventions & Patterns

## global/index.ts 应用名修改完成

**修改内容:**

- 第 6 行: `const app = "opencode"` → `const app = "senlinlon"`
- 第 15, 17 行: `OPENCODE_TEST_HOME` → `SENLINLON_TEST_HOME`

**影响范围:**

- XDG 目录路径将从 `~/.local/share/opencode` 变为 `~/.local/share/senlinlon`
- 测试环境变量从 `OPENCODE_TEST_HOME` 更名为 `SENLINLON_TEST_HOME`

**验证结果:**

- ✓ grep 'const app = "senlinlon"' 匹配成功（第 6 行）
- ✓ grep 'SENLINLON_TEST_HOME' 匹配成功（第 15, 17 行）

## flag.ts 环境变量前缀替换

**文件**: packages/opencode/src/flag/flag.ts  
**操作**: 全局替换 OPENCODE* → SENLINLON*  
**结果**: 成功替换所有 35+ 处引用

替换范围:

- 导出常量名称（SENLINLON_AUTO_SHARE 等）
- process.env 键名
- Object.defineProperty 动态 getter
- truthy() 和 number() 函数调用参数

验证通过，无残留 OPENCODE\_ 引用。

## 目录和配置文件重命名完成

### 修改的文件 (9个)

1. packages/opencode/src/config/config.ts
   - 行 84, 116, 125: .opencode → .senlinlon (目录扫描)
   - 行 84, 139, 268, 308, 1115-1116, 1283: opencode.json(c) → senlinlon.json(c)

2. packages/opencode/src/session/index.ts
   - 行 237: .opencode/plans → .senlinlon/plans

3. packages/opencode/src/agent/agent.ts
   - 行 101: .opencode/plans/_.md → .senlinlon/plans/_.md

4. packages/opencode/src/file/ripgrep.ts
   - 行 297: .opencode → .senlinlon (过滤规则)

5. packages/opencode/src/installation/index.ts
   - 行 61: .opencode/bin → .senlinlon/bin

6. packages/opencode/src/cli/cmd/agent.ts
   - 行 101: .opencode → .senlinlon

7. packages/opencode/src/cli/cmd/mcp.ts
   - 行 384-387: .opencode/opencode.json → .senlinlon/senlinlon.json

8. packages/opencode/src/skill/skill.ts
   - 行 113: .opencode/skill/ → .senlinlon/skill/

### 注意事项

- 修改仅涉及项目内部目录引用，未触及 opencode.ai 域名
- 未修改注释内容
- 未修改 x-opencode-\* API headers
- 未格式化代码

### LSP 诊断提示

部分文件存在 Flag 属性名的错误提示，但这些是由于 Flag 定义也在重命名过程中，属于正常现象。

## Wave 1 补充任务 - 源码中的 Flag 引用替换 (2026-01-29)

**问题**: 虽然 `flag.ts` 定义已更名为 `Flag.SENLINLON_*`，但源码中仍使用旧的 `Flag.OPENCODE_*` 访问方式。

**解决方案**:

- 使用 `sed` 批量替换全部 27 个文件的 87 处引用
- 命令: `find packages/opencode/src -type f \( -name "*.ts" -o -name "*.tsx" \) -exec sed -i '' 's/Flag\.OPENCODE_/Flag.SENLINLON_/g' {} +`

**验证**:

- `grep -r "Flag\.OPENCODE_"` 返回 0 处引用
- `grep -r "Flag\.SENLINLON_"` 返回 87 处引用
- 所有属性访问现在指向正确的 `SENLINLON_*` 属性

**工具选择教训**:

- `ast-grep` 不适合简单的属性访问模式替换
- `sed` 配合 `find` 是批量文本替换的最佳方案

## package.json 修改

- 根包名改为 senlinlon
- workspace 依赖 scope 从 @opencode-ai/_ 改为 @senlinlon/_
- GitHub 仓库 URL 更新为 https://github.com/chensen-pro-plus/opencode-senlinlon-Publish
- 验证通过: jq 查询包名正确，grep 确认 3 处 @senlinlon/ 引用

## packages/opencode/package.json 修改

**时间**: $(date '+%Y-%m-%d %H:%M:%S')

**修改内容**:

- 包名: `opencode` → `senlinlon` (第4行)
- bin 命令: `opencode` → `senlinlon` (第20-21行)
- 依赖 scope: `@opencode-ai/*` → `@senlinlon/*` (6处)
  - devDependencies: `@opencode-ai/script` → `@senlinlon/script`
  - dependencies: 5个包全部替换

**验证结果**:

- ✓ jq '.name' 返回 "senlinlon"
- ✓ jq '.bin.senlinlon' 返回 "./bin/senlinlon"
- ✓ grep -c "@senlinlon/" 返回 6 (>= 5)

**工具使用**:

- Edit tool 进行精确替换
- 对于重复的 @opencode-ai/script，使用更大上下文避免误匹配

## Wave 2: 批量修改 workspace package.json scope

**时间**: 2026-01-29 14:43:00

**任务**: 将所有 packages/_/package.json 和 github/package.json 中的 @opencode-ai/_ 依赖替换为 @senlinlon/\*

**修改文件 (19个)**:

1. packages/app/package.json
2. packages/desktop/package.json
3. packages/enterprise/package.json
4. packages/function/package.json
5. packages/opencode/package.json
6. packages/plugin/package.json
7. packages/script/package.json
8. packages/slack/package.json
9. packages/ui/package.json
10. packages/util/package.json
11. packages/web/package.json
12. packages/sdk/js/package.json
13. packages/console/app/package.json
14. packages/console/core/package.json
15. packages/console/function/package.json
16. packages/console/mail/package.json
17. packages/console/resource/package.json
18. packages/oh-my-opencode-senlinlon/package.json
19. packages/oh-my-opencode-senlinlon/.opencode/package.json
20. github/package.json

**操作方式**:

- 使用 Edit tool 的 replaceAll=true 参数
- 全局替换 "@opencode-ai/" → "@senlinlon/"

**验证结果**:

- ✓ 所有 package.json 中无残留 @opencode-ai 引用
- ✓ 所有 workspace 包依赖 scope 已统一为 @senlinlon

**注意事项**:

- 不修改包的 name 字段（已在 Wave 1 完成）
- 仅修改 dependencies/devDependencies 中的 workspace 引用
- 保留原有 JSON 格式

## Tauri 配置修改 (Wave 3)

修改文件:

- `packages/desktop/src-tauri/tauri.conf.json` (dev)
- `packages/desktop/src-tauri/tauri.prod.conf.json` (prod)

### tauri.conf.json (dev) 修改:

- productName: OpenCode Dev → Senlinlon Dev
- identifier: ai.opencode.desktop.dev → ai.senlinlon.desktop.dev
- mainBinaryName: OpenCode → Senlinlon
- windows[0].title: OpenCode → Senlinlon
- bundle.externalBin: sidecars/opencode-cli → sidecars/senlinlon-cli

### tauri.prod.conf.json (prod) 修改:

- productName: OpenCode → Senlinlon
- identifier: ai.opencode.desktop → ai.senlinlon.desktop
- windows[0].title: OpenCode → Senlinlon
- bundle.linux.deb.files: ai.opencode.opencode.metainfo.xml → ai.senlinlon.senlinlon.metainfo.xml
- plugins.updater.endpoints: anomalyco/opencode → chensen-pro-plus/opencode-senlinlon-Publish

验证通过: grep 命令确认所有关键字段已正确更新

## uninstall.ts 包名替换 (Wave 3)

- 文件: `packages/opencode/src/cli/cmd/uninstall.ts`
- 修改内容:
  - 行 57: `Uninstall OpenCode` → `Uninstall Senlinlon`
  - 行 131-137: npm/pnpm/bun/yarn 包名 `opencode-ai` → `senlinlon`
  - 行 131-137: brew/choco/scoop 包名 `opencode` → `senlinlon`
  - 行 182-188: 卸载命令参数中的包名替换
  - 行 196: choco 卸载命令中的包名
  - 行 220, 273, 291, 298, 304-305: 目录引用 `.opencode` → `.senlinlon`
  - 行 234: 感谢信息 `Thank you for using OpenCode!` → `Thank you for using Senlinlon!`
- 验证结果:
  - `opencode-ai` 出现次数: 0
  - `.opencode` 出现次数: 0

## installation/index.ts 包名替换完成

### 修改摘要

- 修改文件: `packages/opencode/src/installation/index.ts`
- 替换项目:
  - 行61: `.senlinlon/bin` (已存在,无需修改)
  - 行84-92: brew/scoop/choco 检测命令中的包名 opencode → senlinlon
  - 行107: 包名检测逻辑 opencode/opencode-ai → senlinlon
  - 行124-128: getBrewFormula() 中的 opencode → senlinlon
  - 行141-147: npm/pnpm/bun 安装包名 opencode-ai@${target} → senlinlon@${target}
  - 行158-161: choco/scoop 升级命令中的 opencode → senlinlon
  - 行184: User-Agent 中的 opencode/${CHANNEL} → senlinlon/${CHANNEL}
  - 行191-197: brew formula 检测中的 opencode → senlinlon
  - 行208: npm registry 路径 /opencode-ai/ → /senlinlon/

### 验证结果

- LSP 诊断: 无错误
- senlinlon 出现次数: 22
- opencode.ai/install 保留: ✓ (第135行)

### 技术细节

- 所有包管理器安装逻辑已更新为 senlinlon
- 保持了原有的逻辑结构,仅替换包名字符串
- opencode.ai 域名作为安装脚本 URL 保持不变

## packages/desktop/src-tauri/src/cli.rs

- 修改常量: `CLI_INSTALL_DIR` → `.senlinlon/bin`, `CLI_BINARY_NAME` → `senlinlon`
- 修改二进制名: `opencode-cli` → `senlinlon-cli` (sidecar路径, 函数调用)
- 修改脚本名: `opencode-install.sh` → `senlinlon-install.sh`
- 修改环境变量: `OPENCODE_*` → `SENLINLON_*` (Windows/Unix两处)
- 共修改7处引用，覆盖CLI安装、Sidecar调用、环境配置

## Wave 3 Task 11: 重命名 packages/opencode/bin/opencode → senlinlon

### 修改内容
- **文件重命名**: `opencode` → `senlinlon` (使用 git mv 保留历史)
- **环境变量**: `OPENCODE_BIN_PATH` → `SENLINLON_BIN_PATH` (line 20)
- **包名前缀**: `opencode-` → `senlinlon-` (line 47)
- **二进制名称**: `opencode.exe` / `opencode` → `senlinlon.exe` / `senlinlon` (line 48)
- **错误消息**: 替换错误提示中的品牌名 (line 77)

### 技术细节
- 使用 `git mv` 而非 `mv` 以保留 git 历史记录
- 脚本逻辑不变，仅修改品牌引用
- 该脚本是 Node.js 包装器，负责查找和执行平台特定的 senlinlon 二进制文件

### 验证结果
✅ 文件重命名成功
✅ 原文件已删除
✅ 所有品牌引用已替换
✅ 环境变量名称已更新

## Wave 3: MCP/Server/CLI 品牌字符串替换

### 修改范围
- **CLI 配置**: `src/index.ts` - scriptName 和日志标识
- **服务器配置**: `src/server/server.ts` - 默认用户名和 API 文档标题
- **MCP 客户端**: `src/mcp/index.ts` - MCP client name 字段
- **CLI 命令**:
  - `src/cli/cmd/serve.ts` - 服务器启动日志
  - `src/cli/cmd/web.ts` - mDNS 域名
  - `src/cli/cmd/pr.ts` - 命令调用
  - `src/cli/cmd/upgrade.ts` - 用户提示消息
- **网络服务**: `src/server/mdns.ts` - mDNS 服务名称和 hostname

### 关键修改点
1. **保留排除项**: 确认保持 `x-opencode-*` headers 和 `opencode.ai` 域名不变
2. **三处 MCP Client**: 行 350, 429, 763 均需修改 name 字段
3. **mDNS 一致性**: mdns.ts 中的服务名 `senlinlon-${port}` 和 hostname `senlinlon.local` 需保持一致

### 验证通过
- `scriptName("senlinlon")` 存在于 index.ts
- `name: "senlinlon"` 在 mcp/index.ts 中出现 3 次（符合预期）
