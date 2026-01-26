# OpenCode 打包分发指南

## 项目概述

**OpenCode** 是一个开源的 AI 编程助手，类似于 Claude Code，但完全开源且不绑定任何特定的 AI 提供商。支持 CLI、TUI（终端用户界面）、Web 应用和桌面应用多种形式。

- **GitHub**: https://github.com/anomalyco/opencode
- **官网**: https://opencode.ai
- **文档**: https://opencode.ai/docs

---

## 技术栈

| 层级 | 技术 |
|------|------|
| **语言** | TypeScript 5.8.2 |
| **运行时** | Bun 1.3.5 |
| **Monorepo** | Turborepo + Bun Workspaces |
| **前端** | SolidJS + TailwindCSS |
| **后端** | Hono (REST/SSE API) |
| **桌面** | Tauri v2 |
| **AI SDK** | Vercel AI SDK |

---

## 分发方式概览

| 方式 | 适用场景 | 产物 |
|------|----------|------|
| **CLI 二进制** | 开发者 / 服务器 | 单个可执行文件 |
| **桌面应用** | 普通用户 | .dmg / .exe / .deb / .rpm |
| **npm 包** | Node.js 生态 | npm install |
| **安装脚本** | 快速部署 | curl 一行安装 |

---

## 环境准备

### 基础要求

```bash
# 安装 Bun (1.3+)
curl -fsSL https://bun.sh/install | bash

# 克隆项目
git clone https://github.com/anomalyco/opencode.git
cd opencode

# 安装依赖
bun install
```

### 桌面应用额外要求

```bash
# 安装 Rust 工具链
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# 平台特定依赖请参考:
# https://v2.tauri.app/start/prerequisites/
```

---

## 打包方式详解

### 1. 构建 CLI 二进制

CLI 二进制是最核心的分发方式，其他方式都依赖于它。

```bash
cd packages/opencode

# 构建当前平台（开发/测试用）
bun run build --single

# 构建所有平台（发布用）
bun run build
```

**输出位置**: `packages/opencode/dist/`

```
dist/
├── opencode-darwin-arm64/       # macOS Apple Silicon
│   ├── bin/opencode
│   └── package.json
├── opencode-darwin-x64/         # macOS Intel
├── opencode-darwin-x64-baseline/# macOS Intel (无 AVX2)
├── opencode-linux-arm64/        # Linux ARM64
├── opencode-linux-x64/          # Linux x64
├── opencode-linux-x64-baseline/ # Linux x64 (无 AVX2)
├── opencode-linux-arm64-musl/   # Alpine Linux ARM64
├── opencode-linux-x64-musl/     # Alpine Linux x64
├── opencode-windows-x64/        # Windows x64
└── opencode-windows-x64-baseline/
```

**支持的平台**:

| 平台 | 架构 | 变体 |
|------|------|------|
| macOS (darwin) | arm64, x64 | baseline (无 AVX2) |
| Linux | arm64, x64 | baseline, musl |
| Windows | x64 | baseline |

---

### 2. 构建桌面应用 (Tauri)

```bash
cd packages/desktop

# 开发模式
bun run tauri dev

# 生产构建
bun run tauri build
```

**输出位置**: `packages/desktop/src-tauri/target/release/bundle/`

| 平台 | 产物 | 说明 |
|------|------|------|
| macOS | `.dmg`, `.app` | 拖拽安装 |
| Windows | `.exe` (NSIS) | 安装向导 |
| Linux | `.deb`, `.rpm`, `.AppImage` | 包管理器安装 |

**注意**: 桌面应用内嵌了 CLI 二进制作为 sidecar，构建前会自动执行 `predev.ts` 来构建 CLI。

---

### 3. 发布到 npm

```bash
cd packages/opencode

# 构建所有平台
bun run build

# 发布到 npm
bun run script/publish.ts
```

用户安装方式:
```bash
npm i -g opencode-ai@latest
# 或
bun add -g opencode-ai@latest
# 或
pnpm add -g opencode-ai@latest
```

---

### 4. 制作压缩包分发

```bash
cd packages/opencode/dist

# 打包所有平台
for dir in opencode-*/; do
  name="${dir%/}"
  if [[ "$name" == *"windows"* ]]; then
    zip -r "${name}.zip" "$dir"
  else
    tar -czvf "${name}.tar.gz" "$dir"
  fi
done
```

产物:
- `opencode-darwin-arm64.tar.gz`
- `opencode-darwin-x64.tar.gz`
- `opencode-linux-x64.tar.gz`
- `opencode-windows-x64.zip`
- ...

---

## 完整打包流程（生产环境）

```bash
#!/bin/bash
set -e

# 1. 确保在项目根目录
cd /path/to/opencode

# 2. 安装依赖
bun install

# 3. 构建 CLI 二进制（所有平台）
echo "Building CLI binaries..."
cd packages/opencode
bun run build

# 4. 打包为压缩文件
echo "Creating archives..."
cd dist
for dir in opencode-*/; do
  name="${dir%/}"
  if [[ "$name" == *"windows"* ]]; then
    zip -r "${name}.zip" "$dir"
    echo "Created ${name}.zip"
  else
    tar -czvf "${name}.tar.gz" "$dir"
    echo "Created ${name}.tar.gz"
  fi
done

# 5. 构建桌面应用（当前平台）
echo "Building desktop app..."
cd ../../packages/desktop
bun run tauri build

echo "Build complete!"
```

---

## 客户安装方式

### 方式 A - 一键安装脚本（推荐）

```bash
# 官方源
curl -fsSL https://opencode.ai/install | bash

# 指定版本
curl -fsSL https://opencode.ai/install | bash -s -- --version 1.0.180

# 自托管源
curl -fsSL https://your-domain.com/install | bash
```

### 方式 B - 直接下载二进制

1. 从 [Releases 页面](https://github.com/anomalyco/opencode/releases) 下载对应平台的压缩包
2. 解压到任意目录
3. 将 `bin/opencode` 添加到 PATH

```bash
# macOS/Linux 示例
tar -xzf opencode-darwin-arm64.tar.gz
sudo mv opencode-darwin-arm64/bin/opencode /usr/local/bin/

# 或添加到用户目录
mkdir -p ~/.opencode/bin
mv opencode-darwin-arm64/bin/opencode ~/.opencode/bin/
echo 'export PATH="$HOME/.opencode/bin:$PATH"' >> ~/.zshrc
```

### 方式 C - 桌面应用

| 平台 | 安装方式 |
|------|----------|
| macOS | 下载 `.dmg`，双击打开，拖入 Applications |
| Windows | 下载 `.exe`，双击运行安装向导 |
| Linux (Debian/Ubuntu) | `sudo dpkg -i opencode-desktop_*.deb` |
| Linux (Fedora/RHEL) | `sudo rpm -i opencode-desktop-*.rpm` |
| Linux (通用) | 下载 `.AppImage`，添加执行权限后运行 |

### 方式 D - 包管理器

```bash
# npm
npm i -g opencode-ai@latest

# Homebrew (macOS/Linux)
brew install anomalyco/tap/opencode

# Scoop (Windows)
scoop install opencode

# Chocolatey (Windows)
choco install opencode

# Arch Linux
paru -S opencode-bin

# Nix
nix run nixpkgs#opencode
```

---

## 自托管分发

如果需要自托管分发（内网环境或私有化部署）：

### 1. 修改安装脚本

编辑项目根目录的 `install` 脚本，修改下载 URL：

```bash
# 原始
url="https://github.com/anomalyco/opencode/releases/latest/download/$filename"

# 修改为
url="https://your-internal-server.com/opencode/releases/$filename"
```

### 2. 搭建文件服务器

将构建产物上传到内部服务器，目录结构：

```
/opencode/releases/
├── opencode-darwin-arm64.tar.gz
├── opencode-darwin-x64.tar.gz
├── opencode-linux-x64.tar.gz
├── opencode-windows-x64.zip
└── ...
```

### 3. 客户安装

```bash
curl -fsSL https://your-internal-server.com/opencode/install | bash
```

---

## 代码签名（生产环境必需）

### macOS 签名

需要 Apple Developer ID：

```bash
# 设置环境变量
export APPLE_SIGNING_IDENTITY="Developer ID Application: Your Company (XXXXXXXXXX)"
export APPLE_ID="your-apple-id@example.com"
export APPLE_PASSWORD="app-specific-password"
export APPLE_TEAM_ID="XXXXXXXXXX"

# Tauri 会自动签名
bun run tauri build
```

### Windows 签名

需要代码签名证书：

```bash
# 设置环境变量
export TAURI_SIGNING_PRIVATE_KEY="path/to/key.pem"
export TAURI_SIGNING_PRIVATE_KEY_PASSWORD="password"

bun run tauri build
```

---

## 版本管理

版本号定义在 `packages/opencode/package.json`：

```json
{
  "version": "1.1.36"
}
```

发布新版本时：

1. 更新 `package.json` 中的版本号
2. 提交更改
3. 创建 Git tag: `git tag v1.1.37`
4. 推送: `git push && git push --tags`

---

## 常见问题

### Q: 构建桌面应用时卡在 "Waiting for frontend dev server"

A: 这是因为 Tauri 在等待 Vite 前端服务器启动。可以分步运行：

```bash
# 终端 1: 启动前端
cd packages/desktop
bun run dev

# 终端 2: 启动 Tauri
cd packages/desktop
bun run tauri dev
```

### Q: Linux 上运行提示 GLIBC 版本不兼容

A: 使用 musl 版本或 baseline 版本：

```bash
# 下载 musl 版本（适用于 Alpine 等）
opencode-linux-x64-musl.tar.gz

# 或 baseline 版本（无 AVX2 要求）
opencode-linux-x64-baseline.tar.gz
```

### Q: macOS 提示 "无法验证开发者"

A: 需要进行代码签名，或者用户手动允许：

```bash
# 用户可以运行
xattr -cr /path/to/opencode
```

---

## 项目结构参考

```
opencode/
├── packages/
│   ├── opencode/          # 核心 CLI 逻辑
│   │   ├── src/           # 源代码
│   │   ├── script/        # 构建脚本
│   │   └── dist/          # 构建产物
│   ├── desktop/           # Tauri 桌面应用
│   │   ├── src/           # 前端代码
│   │   └── src-tauri/     # Rust 后端
│   ├── app/               # Web 应用
│   └── ...
├── install                 # 安装脚本
└── package.json           # 根配置
```

---

## 相关链接

- [Tauri 打包文档](https://v2.tauri.app/distribute/)
- [Bun 编译文档](https://bun.sh/docs/bundler/executables)
- [OpenCode 官方文档](https://opencode.ai/docs)
- [GitHub Releases](https://github.com/anomalyco/opencode/releases)
