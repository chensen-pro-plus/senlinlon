# Senlinlon 一键打包发布 Skill

## 触发条件

当用户说以下任何一种时触发：

- "打包发布"
- "发布新版本"
- "release"
- "构建并发布"
- "一键发布"

## 快速发布流程（TL;DR）

发布新版本（例如 1.0.3）的完整命令：

```bash
# 1. 构建（设置版本号）
cd /Users/工作2/opencode工作区/opencode/packages/opencode
SENLINLON_VERSION=1.0.3 bun run build

# 2. 验证版本号
./dist/senlinlon-darwin-arm64/bin/senlinlon -v
# 应该输出: 1.0.3

# 3. 更新包名（构建输出是 senlinlon-*，npm 需要 senlinlon-cli-*）
cd dist
for dir in senlinlon-darwin-arm64 senlinlon-darwin-x64 senlinlon-linux-arm64 senlinlon-linux-x64 senlinlon-windows-x64; do
  [ -d "$dir" ] && sed -i '' "s/\"name\": \"senlinlon-/\"name\": \"senlinlon-cli-/" "$dir/package.json"
done

# 4. 发布平台子包
for dir in senlinlon-darwin-arm64 senlinlon-darwin-x64 senlinlon-linux-arm64 senlinlon-linux-x64 senlinlon-windows-x64; do
  [ -d "$dir" ] && (cd "$dir" && npm publish --access public)
done

# 5. 更新主包版本和依赖，然后发布
# 编辑 .senlinlon/npm-publish/main/package.json
# - version: "1.0.4" (主包版本 = 二进制版本 + 1)
# - optionalDependencies 所有包版本改为 "1.0.3"
cd /Users/工作2/opencode工作区/opencode/.senlinlon/npm-publish/main
npm publish --access public

# 6. 验证
npm view senlinlon-cli versions --json
```

## 概述

此 skill 用于自动化 Senlinlon 项目的打包和发布流程：

1. 构建所有平台的二进制文件
2. 创建/更新 GitHub 仓库
3. 创建 GitHub Release
4. 上传所有二进制文件
5. 验证发布成功

## 前置条件

确认以下条件满足：

- [ ] 已登录 GitHub CLI (`gh auth status`)
- [ ] 代码已提交到 senlinlon-rebranding 分支
- [ ] 在项目根目录 `/Users/工作2/opencode工作区/opencode`

## 执行步骤

### 步骤 1：收集信息

询问用户以下信息：

1. **版本号**：例如 `v1.0.0`、`v1.1.0`（默认：根据上次版本递增）
2. **GitHub 仓库**：例如 `chensen-pro-plus/senlinlon`（默认：上次使用的仓库）
3. **是否只构建当前平台**：是/否（默认：否，构建所有平台）

### 步骤 2：构建二进制文件

**重要**：必须通过 `SENLINLON_VERSION` 环境变量指定版本号，否则会生成 `0.0.0-senlinlon-rebranding-...` 格式的版本号。

```bash
# 进入构建目录
cd /Users/工作2/opencode工作区/opencode/packages/opencode

# 构建所有平台（完整构建，约 5-10 分钟）
# VERSION 不带 v 前缀，例如 1.0.2
SENLINLON_VERSION=1.0.2 bun run build

# 或者只构建当前平台（快速构建，约 1 分钟）
SENLINLON_VERSION=1.0.2 bun run build --single
```

验证版本号是否正确：

```bash
# macOS ARM64
./dist/senlinlon-darwin-arm64/bin/senlinlon -v
# 应该输出: 1.0.2
```

验证构建结果：

```bash
ls -la dist/
# 应该有 11 个目录（完整构建）或 1 个目录（单平台）
# senlinlon-darwin-arm64, senlinlon-darwin-x64, senlinlon-linux-x64, etc.
```

### 步骤 2.1：更新包名（npm 发布前必须）

构建生成的包名是 `senlinlon-*`，但 npm 上的包名是 `senlinlon-cli-*`。需要更新 package.json：

```bash
cd /Users/工作2/opencode工作区/opencode/packages/opencode/dist

# 更新所有主要平台的包名
for dir in senlinlon-darwin-arm64 senlinlon-darwin-x64 senlinlon-linux-arm64 senlinlon-linux-x64 senlinlon-windows-x64; do
  if [ -d "$dir" ]; then
    platform=${dir#senlinlon-}
    new_name="senlinlon-cli-${platform}"
    echo "Updating $dir -> $new_name"
    sed -i '' "s/\"name\": \"senlinlon-${platform}\"/\"name\": \"${new_name}\"/" "$dir/package.json"
  fi
done
```

### 步骤 3：生成 SHA256 校验和

如果构建脚本没有自动生成，手动生成：

```bash
cd /Users/工作2/opencode工作区/opencode/packages/opencode/dist
shasum -a 256 *.tar.gz *.zip 2>/dev/null > SHA256SUMS.txt
```

### 步骤 4：准备发布文件

创建临时目录存放发布文件：

```bash
mkdir -p /tmp/senlinlon-release
```

创建 README.md：

```markdown
# Senlinlon

Senlinlon 是一个强大的 AI 编程助手。

## 安装

### macOS (Apple Silicon)

\`\`\`bash
curl -L https://github.com/{REPO}/releases/download/{VERSION}/senlinlon-darwin-arm64.tar.gz -o senlinlon.tar.gz
tar -xzf senlinlon.tar.gz
sudo mv senlinlon-darwin-arm64/bin/senlinlon /usr/local/bin/
\`\`\`

### macOS (Intel)

\`\`\`bash
curl -L https://github.com/{REPO}/releases/download/{VERSION}/senlinlon-darwin-x64.tar.gz -o senlinlon.tar.gz
tar -xzf senlinlon.tar.gz
sudo mv senlinlon-darwin-x64/bin/senlinlon /usr/local/bin/
\`\`\`

### Linux (x64)

\`\`\`bash
curl -L https://github.com/{REPO}/releases/download/{VERSION}/senlinlon-linux-x64.tar.gz -o senlinlon.tar.gz
tar -xzf senlinlon.tar.gz
sudo mv senlinlon-linux-x64/bin/senlinlon /usr/local/bin/
\`\`\`

### Windows

1. 下载 `senlinlon-windows-x64.zip`
2. 解压到目标目录
3. 将 bin 目录添加到 PATH

## 许可证

MIT License
```

创建 LICENSE 文件（MIT License）

### 步骤 5：检查/创建 GitHub 仓库

```bash
# 检查仓库是否存在
gh repo view {REPO} 2>/dev/null

# 如果不存在，创建仓库
cd /tmp/senlinlon-release
git init
git add README.md LICENSE
git commit -m "Initial commit"
gh repo create {REPO_NAME} --public --description "Senlinlon - AI 编程助手" --source=. --remote=origin --push
```

### 步骤 6：创建 Release

准备 Release Notes：

```markdown
# 🎉 Senlinlon {VERSION}

## ✨ 主要特性

- 🤖 智能代码补全和生成
- 🔍 代码理解和重构建议
- 🛠️ 多语言支持
- ⚡ 快速响应和高性能

## 📦 支持平台

| 平台    | 架构          | 文件                            |
| ------- | ------------- | ------------------------------- |
| macOS   | Apple Silicon | `senlinlon-darwin-arm64.tar.gz` |
| macOS   | Intel         | `senlinlon-darwin-x64.tar.gz`   |
| Linux   | x64           | `senlinlon-linux-x64.tar.gz`    |
| Linux   | ARM64         | `senlinlon-linux-arm64.tar.gz`  |
| Windows | x64           | `senlinlon-windows-x64.zip`     |

> 💡 旧 CPU 请使用 `baseline` 版本，Alpine Linux 请使用 `musl` 版本。

## 🔐 文件校验

下载 `SHA256SUMS.txt` 验证文件完整性。
```

创建 Release（草稿模式）：

```bash
gh release create {VERSION} \
  --repo {REPO} \
  --title "Senlinlon {VERSION}" \
  --notes-file /tmp/release-notes.md \
  --draft
```

### 步骤 7：上传二进制文件

分批上传（避免超时）：

```bash
cd /Users/工作2/opencode工作区/opencode/packages/opencode/dist

# 批次 1：macOS
gh release upload {VERSION} --repo {REPO} --clobber \
  senlinlon-darwin-arm64.tar.gz \
  senlinlon-darwin-x64.tar.gz \
  senlinlon-darwin-x64-baseline.tar.gz

# 批次 2：Linux x64
gh release upload {VERSION} --repo {REPO} --clobber \
  senlinlon-linux-x64.tar.gz \
  senlinlon-linux-x64-baseline.tar.gz \
  senlinlon-linux-x64-musl.tar.gz \
  senlinlon-linux-x64-baseline-musl.tar.gz

# 批次 3：Linux ARM64
gh release upload {VERSION} --repo {REPO} --clobber \
  senlinlon-linux-arm64.tar.gz \
  senlinlon-linux-arm64-musl.tar.gz

# 批次 4：Windows
gh release upload {VERSION} --repo {REPO} --clobber \
  senlinlon-windows-x64.tar.gz \
  senlinlon-windows-x64.zip \
  senlinlon-windows-x64-baseline.tar.gz \
  senlinlon-windows-x64-baseline.zip

# 批次 5：校验文件
gh release upload {VERSION} --repo {REPO} --clobber SHA256SUMS.txt
```

### 步骤 8：发布 Release

```bash
gh release edit {VERSION} --repo {REPO} --draft=false
```

### 步骤 9：验证发布

```bash
# 查看 Release 详情
gh release view {VERSION} --repo {REPO}

# 测试下载链接
curl -I https://github.com/{REPO}/releases/download/{VERSION}/senlinlon-darwin-arm64.tar.gz

# 完整安装测试
cd /tmp
curl -L https://github.com/{REPO}/releases/download/{VERSION}/senlinlon-darwin-arm64.tar.gz -o test.tar.gz
tar -xzf test.tar.gz
./senlinlon-darwin-arm64/bin/senlinlon --version
```

## 变量说明

| 变量          | 说明                | 示例                         |
| ------------- | ------------------- | ---------------------------- |
| `{VERSION}`   | 版本号（带 v 前缀） | `v1.0.0`                     |
| `{REPO}`      | GitHub 仓库路径     | `chensen-pro-plus/senlinlon` |
| `{REPO_NAME}` | 仓库名称            | `senlinlon`                  |

## 生成的文件清单

完整构建会生成 14 个文件：

### macOS (3 个)

- `senlinlon-darwin-arm64.tar.gz` - Apple Silicon (M1/M2/M3)
- `senlinlon-darwin-x64.tar.gz` - Intel Mac
- `senlinlon-darwin-x64-baseline.tar.gz` - Intel Mac (旧 CPU)

### Linux x64 (4 个)

- `senlinlon-linux-x64.tar.gz` - 标准 glibc
- `senlinlon-linux-x64-baseline.tar.gz` - 旧 CPU
- `senlinlon-linux-x64-musl.tar.gz` - Alpine Linux
- `senlinlon-linux-x64-baseline-musl.tar.gz` - Alpine + 旧 CPU

### Linux ARM64 (2 个)

- `senlinlon-linux-arm64.tar.gz` - 标准 glibc
- `senlinlon-linux-arm64-musl.tar.gz` - Alpine Linux

### Windows (4 个)

- `senlinlon-windows-x64.tar.gz` - tar.gz 格式
- `senlinlon-windows-x64.zip` - zip 格式（推荐）
- `senlinlon-windows-x64-baseline.tar.gz` - 旧 CPU, tar.gz
- `senlinlon-windows-x64-baseline.zip` - 旧 CPU, zip

### 校验 (1 个)

- `SHA256SUMS.txt` - SHA256 校验和

## 错误处理

### 构建失败

```bash
# 清理并重试
cd /Users/工作2/opencode工作区/opencode/packages/opencode
rm -rf dist
bun install
bun run script/build.ts
```

### 上传超时

- 减少每批上传文件数（2-3 个）
- 检查网络连接
- 增加超时时间

### Release 已存在

```bash
# 删除现有 Release 重新创建
gh release delete {VERSION} --repo {REPO} --yes
gh release create {VERSION} ...
```

### 仓库权限问题

```bash
# 重新认证
gh auth login
gh auth status
```

## 完成标志

发布成功的标志：

- [ ] `gh release view` 显示所有 14 个文件
- [ ] 下载链接返回 HTTP 302
- [ ] 安装测试通过（`--version` 正常输出）
- [ ] SHA256 校验匹配

## 步骤 10：发布到 npm（可选）

如果需要让用户通过 npm 安装和更新，运行 npm 发布脚本：

### 前置条件

1. 登录 npm：

```bash
npm login
npm whoami  # 验证登录
```

2. 创建带 "Bypass 2FA" 权限的 Granular Access Token：
   - 访问 https://www.npmjs.com → 头像 → Access Tokens
   - 点击 "Generate New Token"
   - ✅ 勾选 "Bypass two-factor authentication"
   - Permissions: Read and write
   - 复制 token 并运行: `npm config set //registry.npmjs.org/:_authToken=你的token`

### 执行发布

**方式 1：使用脚本（推荐，自动处理版本号和包名）**

```bash
# 运行 npm 发布脚本（版本号不带 v 前缀）
./.senlinlon/scripts/npm-publish.sh 1.0.2
```

**方式 2：手动发布（如果脚本失败）**

```bash
cd /Users/工作2/opencode工作区/opencode/packages/opencode/dist

# 1. 发布各平台子包
for dir in senlinlon-darwin-arm64 senlinlon-darwin-x64 senlinlon-linux-arm64 senlinlon-linux-x64 senlinlon-windows-x64; do
  if [ -d "$dir" ]; then
    echo "Publishing $dir..."
    cd "$dir"
    npm publish --access public
    cd ..
  fi
done

# 2. 更新主包版本和依赖版本
cd /Users/工作2/opencode工作区/opencode/.senlinlon/npm-publish/main
# 编辑 package.json，更新 version 和 optionalDependencies 版本号

# 3. 发布主包
npm publish --access public
```

### 验证发布

```bash
# 检查包是否发布成功
npm view senlinlon-cli versions --json

# 查看最新版本
npm view senlinlon-cli version

# 测试更新
npm update -g senlinlon-cli
senlinlon --version
# 应该显示新版本号（例如 1.0.2）
```

### 用户使用

发布后，用户可以通过以下方式安装和更新：

```bash
# 安装
npm install -g senlinlon-cli

# 更新
npm update -g senlinlon-cli

# 查看版本
senlinlon --version
```

### npm 包结构

| 包名                         | 说明                |
| ---------------------------- | ------------------- |
| `senlinlon-cli`              | 主包（CLI 入口）    |
| `senlinlon-cli-darwin-arm64` | macOS Apple Silicon |
| `senlinlon-cli-darwin-x64`   | macOS Intel         |
| `senlinlon-cli-linux-arm64`  | Linux ARM64         |
| `senlinlon-cli-linux-x64`    | Linux x64           |
| `senlinlon-cli-windows-x64`  | Windows x64         |

## 后续步骤（可选）

1. 更新 README 中的版本号
2. 推送源代码到私有仓库 (gitcode.com)
3. 在社交媒体/技术社区分享发布
4. 收集用户反馈

## 隐私提醒

⚠️ **重要**：

- 源代码仅保存在私有仓库 (gitcode.com)
- 公开仓库只包含 README、LICENSE 和二进制文件
- 永远不要将 senlinlon-rebranding 分支推送到公开仓库
