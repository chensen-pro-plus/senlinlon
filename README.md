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

在项目根目录创建 `senlinlon.json` 配置文件：

```json
{
  "claudeKey": "你的 Claude API 密钥",
  "geminiKey": "你的 Gemini API 密钥",
  "gptKey": "你的 GPT API 密钥"
}
```

> 💡 只需配置你要使用的 Provider 对应的 Key，无需全部配置。

### API Key 获取方式

| 配置项 | Provider | 获取地址 | 密钥格式 |
|--------|----------|----------|----------|
| `claudeKey` | Anthropic Claude | [console.anthropic.com](https://console.anthropic.com/) | `sk-ant-api03-xxx` |
| `geminiKey` | Google Gemini | [aistudio.google.com](https://aistudio.google.com/) | `AIzaxxx` |
| `gptKey` | OpenAI GPT | [platform.openai.com](https://platform.openai.com/) | `sk-xxx` |

### 可用模型

| Provider | 配置项 | 可用模型 |
|----------|--------|----------|
| `my-claude` | `claudeKey` | `claude-sonnet-4-5-thinking`, `claude-opus-4-5-thinking`, `claude-haiku-4-5` |
| `my-gemini` | `geminiKey` | `gemini-3-pro-high`, `gemini-3-flash` |
| `my-gpt` | `gptKey` | `gpt-5.2`, `gpt-5.2-codex` |

### 切换模型

```json
{
  "claudeKey": "sk-xxx",
  "model": "my-claude/claude-sonnet-4-5-thinking"
}
```

### 配置示例

<details>
<summary>只使用 Claude</summary>

```json
{
  "claudeKey": "sk-ant-api03-your-key"
}
```

</details>

<details>
<summary>只使用 Gemini</summary>

```json
{
  "geminiKey": "AIza-your-key",
  "model": "my-gemini/gemini-3-pro-high"
}
```

</details>

<details>
<summary>只使用 GPT</summary>

```json
{
  "gptKey": "sk-your-openai-key",
  "model": "my-gpt/gpt-5.2"
}
```

</details>

<details>
<summary>配置多个 Provider</summary>

```json
{
  "claudeKey": "sk-ant-api03-xxx",
  "geminiKey": "AIza-xxx",
  "gptKey": "sk-xxx",
  "model": "my-claude/claude-opus-4-5-thinking"
}
```

</details>

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
