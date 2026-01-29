# Senlinlon

**Senlinlon** 是一个强大的 AI 编程助手，为开发者提供智能代码生成、调试和优化功能。

[![Release](https://img.shields.io/github/v/release/chensen-pro-plus/senlinlon?style=flat-square)](https://github.com/chensen-pro-plus/senlinlon/releases)
[![npm](https://img.shields.io/npm/v/senlinlon-cli?style=flat-square)](https://www.npmjs.com/package/senlinlon-cli)
[![License](https://img.shields.io/badge/license-MIT-blue?style=flat-square)](LICENSE)

## 📥 安装

### 方式 1：npm 安装（推荐）

```bash
npm install -g senlinlon-cli
senlinlon --version
```

更新到最新版：

```bash
npm update -g senlinlon-cli
```

### 方式 2：直接下载

👉 **[点击这里下载最新版本](https://github.com/chensen-pro-plus/senlinlon/releases/latest)**

<details>
<summary>macOS (Apple Silicon M1/M2/M3)</summary>

```bash
curl -L https://github.com/chensen-pro-plus/senlinlon/releases/download/v1.0.0/senlinlon-darwin-arm64.tar.gz -o senlinlon.tar.gz
tar -xzf senlinlon.tar.gz
sudo mv senlinlon-darwin-arm64/bin/senlinlon /usr/local/bin/
senlinlon --version
```

</details>

<details>
<summary>macOS (Intel)</summary>

```bash
curl -L https://github.com/chensen-pro-plus/senlinlon/releases/download/v1.0.0/senlinlon-darwin-x64.tar.gz -o senlinlon.tar.gz
tar -xzf senlinlon.tar.gz
sudo mv senlinlon-darwin-x64/bin/senlinlon /usr/local/bin/
senlinlon --version
```

</details>

<details>
<summary>Linux (x64)</summary>

```bash
curl -L https://github.com/chensen-pro-plus/senlinlon/releases/download/v1.0.0/senlinlon-linux-x64.tar.gz -o senlinlon.tar.gz
tar -xzf senlinlon.tar.gz
sudo mv senlinlon-linux-x64/bin/senlinlon /usr/local/bin/
senlinlon --version
```

</details>

<details>
<summary>Linux (ARM64)</summary>

```bash
curl -L https://github.com/chensen-pro-plus/senlinlon/releases/download/v1.0.0/senlinlon-linux-arm64.tar.gz -o senlinlon.tar.gz
tar -xzf senlinlon.tar.gz
sudo mv senlinlon-linux-arm64/bin/senlinlon /usr/local/bin/
senlinlon --version
```

</details>

<details>
<summary>Windows</summary>

1. 下载 [senlinlon-windows-x64.zip](https://github.com/chensen-pro-plus/senlinlon/releases/download/v1.0.0/senlinlon-windows-x64.zip)
2. 解压到 `C:\Program Files\Senlinlon\`
3. 将 `C:\Program Files\Senlinlon\bin\` 添加到系统 PATH
4. 打开命令提示符，运行 `senlinlon --version`

</details>

## 🔑 配置 API Key

创建配置文件 `senlinlon.json`：

```json
{
  "claudeKey": "你的 Claude API 密钥",
  "geminiKey": "你的 Gemini API 密钥",
  "gptKey": "你的 GPT API 密钥"
}
```

> ⚠️ **重要说明**：这些 API Key 是由 **Senlinlon 作者提供的专用密钥**，不是官方平台（Anthropic、Google、OpenAI）的 API Key。请联系作者获取密钥。

> 💡 只需配置你要使用的 Provider 对应的 Key，无需全部配置。

### 配置文件路径

配置文件可以放在以下位置（按优先级从低到高）：

#### macOS / Linux

| 位置 | 路径 | 说明 |
|------|------|------|
| 全局配置 | `~/.config/senlinlon/senlinlon.json` | 所有项目共享 |
| 用户目录 | `~/.senlinlon/senlinlon.json` | 用户级配置 |
| 项目根目录 | `./senlinlon.json` | 当前项目专用 |
| 项目配置目录 | `./.senlinlon/senlinlon.json` | 当前项目专用 |

#### Windows

| 位置 | 路径 | 说明 |
|------|------|------|
| 全局配置 | `%APPDATA%\senlinlon\senlinlon.json` | 所有项目共享 |
| 用户目录 | `%USERPROFILE%\.senlinlon\senlinlon.json` | 用户级配置 |
| 项目根目录 | `.\senlinlon.json` | 当前项目专用 |
| 项目配置目录 | `.\.senlinlon\senlinlon.json` | 当前项目专用 |

> 📝 **优先级说明**：项目配置 > 用户目录配置 > 全局配置。高优先级的配置会覆盖低优先级的同名设置。

### 快速配置示例

<details>
<summary>macOS / Linux</summary>

```bash
# 创建全局配置目录
mkdir -p ~/.config/senlinlon

# 创建配置文件
cat > ~/.config/senlinlon/senlinlon.json << 'EOF'
{
  "claudeKey": "sk-ant-api03-your-key-here"
}
EOF
```

</details>

<details>
<summary>Windows (PowerShell)</summary>

```powershell
# 创建全局配置目录
New-Item -ItemType Directory -Force -Path "$env:APPDATA\senlinlon"

# 创建配置文件
Set-Content -Path "$env:APPDATA\senlinlon\senlinlon.json" -Value '{
  "claudeKey": "sk-ant-api03-your-key-here"
}'
```

</details>

### 禁用 oh-my-opencode 插件

默认情况下，Senlinlon 内置了 `oh-my-opencode` 插件，该插件限制只能使用白名单内的 Provider（`my-claude`、`my-gemini`、`my-gpt`）。

如果你需要使用其他 Provider（如官方的 `anthropic`、`openai`、`google` 等），可以在配置文件中禁用此限制：

```json
{
  "ohMyOpencode": false
}
```

禁用后，你可以使用任何标准 Provider 配置。

## 🚀 使用方法

### 启动 Senlinlon

在项目目录中运行：

```bash
senlinlon
```

Senlinlon 会自动检测项目类型并进入交互模式。

### 常用命令

| 命令 | 说明 |
|------|------|
| `senlinlon` | 启动交互式 AI 助手 |
| `senlinlon --version` | 查看版本号 |
| `senlinlon --help` | 查看帮助信息 |

### 交互模式使用

启动后，你可以直接用自然语言与 AI 对话：

```
> 帮我创建一个 React 组件，显示用户列表

> 解释一下这段代码是做什么的

> 帮我修复这个 TypeScript 类型错误

> 给这个函数添加单元测试
```

## ✨ 特性

- 🤖 **智能代码生成** - 基于自然语言描述生成高质量代码
- 🔍 **代码理解与分析** - 深度理解代码库结构和逻辑
- 🛠️ **自动调试与修复** - 自动检测并修复代码问题
- 📝 **文档生成** - 自动生成代码文档和注释
- 🌐 **多语言支持** - 支持 TypeScript、Python、Java、Go 等主流编程语言
- ⚡ **快速响应** - 高性能设计，响应迅速

## 📦 平台支持

| 平台 | 架构 | npm 包 |
|------|------|--------|
| macOS | Apple Silicon (M1/M2/M3) | `senlinlon-cli-darwin-arm64` |
| macOS | Intel | `senlinlon-cli-darwin-x64` |
| Linux | x64 | `senlinlon-cli-linux-x64` |
| Linux | ARM64 | `senlinlon-cli-linux-arm64` |
| Windows | x64 | `senlinlon-cli-windows-x64` |

> 💡 **提示**：如果您的 CPU 较老，请选择 `baseline` 版本；Alpine Linux 用户请选择 `musl` 版本。

## 💻 系统要求

- **macOS**: macOS 10.15+ (Catalina 或更新)
- **Linux**: glibc 2.27+ 或 musl libc (Alpine Linux)
- **Windows**: Windows 10/11 (64-bit)
- **Node.js**: 16+ (npm 安装方式)
- **内存**: 至少 2GB RAM
- **磁盘**: 约 150MB 可用空间

## 🔐 安全提示

- API 密钥请妥善保管，不要提交到版本控制
- 建议将 `senlinlon.json` 添加到 `.gitignore`

## 📜 更新日志

查看 [Releases](https://github.com/chensen-pro-plus/senlinlon/releases) 页面获取完整的版本历史。

## 📄 许可证

本项目采用 MIT 许可证。详见 [LICENSE](LICENSE) 文件。

---

© 2026 Senlinlon
