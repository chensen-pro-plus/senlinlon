# Senlinlon

**Senlinlon** 是一个强大的 AI 编程助手，为开发者提供智能代码生成、调试和优化功能。

[![Release](https://img.shields.io/github/v/release/chensen-pro-plus/senlinlon?style=flat-square)](https://github.com/chensen-pro-plus/senlinlon/releases)
[![License](https://img.shields.io/badge/license-MIT-blue?style=flat-square)](LICENSE)

## 📥 下载安装

👉 **[点击这里下载最新版本](https://github.com/chensen-pro-plus/senlinlon/releases/latest)**

### macOS (Apple Silicon M1/M2/M3)

```bash
curl -L https://github.com/chensen-pro-plus/senlinlon/releases/download/v1.0.0/senlinlon-darwin-arm64.tar.gz -o senlinlon.tar.gz
tar -xzf senlinlon.tar.gz
sudo mv senlinlon-darwin-arm64/bin/senlinlon /usr/local/bin/
senlinlon --version
```

### macOS (Intel)

```bash
curl -L https://github.com/chensen-pro-plus/senlinlon/releases/download/v1.0.0/senlinlon-darwin-x64.tar.gz -o senlinlon.tar.gz
tar -xzf senlinlon.tar.gz
sudo mv senlinlon-darwin-x64/bin/senlinlon /usr/local/bin/
senlinlon --version
```

### Linux (x64)

```bash
curl -L https://github.com/chensen-pro-plus/senlinlon/releases/download/v1.0.0/senlinlon-linux-x64.tar.gz -o senlinlon.tar.gz
tar -xzf senlinlon.tar.gz
sudo mv senlinlon-linux-x64/bin/senlinlon /usr/local/bin/
senlinlon --version
```

### Linux (ARM64)

```bash
curl -L https://github.com/chensen-pro-plus/senlinlon/releases/download/v1.0.0/senlinlon-linux-arm64.tar.gz -o senlinlon.tar.gz
tar -xzf senlinlon.tar.gz
sudo mv senlinlon-linux-arm64/bin/senlinlon /usr/local/bin/
senlinlon --version
```

### Windows

1. 下载 [senlinlon-windows-x64.zip](https://github.com/chensen-pro-plus/senlinlon/releases/download/v1.0.0/senlinlon-windows-x64.zip)
2. 解压到 `C:\Program Files\Senlinlon\`
3. 将 `C:\Program Files\Senlinlon\bin\` 添加到系统 PATH
4. 打开命令提示符，运行 `senlinlon --version`

## ✨ 特性

- 🤖 **智能代码生成** - 基于自然语言描述生成高质量代码
- 🔍 **代码理解与分析** - 深度理解代码库结构和逻辑
- 🛠️ **自动调试与修复** - 自动检测并修复代码问题
- 📝 **文档生成** - 自动生成代码文档和注释
- 🌐 **多语言支持** - 支持 TypeScript、Python、Java、Go 等主流编程语言
- ⚡ **快速响应** - 高性能设计，响应迅速

## 📦 平台支持

| 平台 | 架构 | 下载文件 |
|------|------|----------|
| macOS | Apple Silicon (M1/M2/M3) | [`senlinlon-darwin-arm64.tar.gz`](https://github.com/chensen-pro-plus/senlinlon/releases/download/v1.0.0/senlinlon-darwin-arm64.tar.gz) |
| macOS | Intel | [`senlinlon-darwin-x64.tar.gz`](https://github.com/chensen-pro-plus/senlinlon/releases/download/v1.0.0/senlinlon-darwin-x64.tar.gz) |
| Linux | x64 | [`senlinlon-linux-x64.tar.gz`](https://github.com/chensen-pro-plus/senlinlon/releases/download/v1.0.0/senlinlon-linux-x64.tar.gz) |
| Linux | ARM64 | [`senlinlon-linux-arm64.tar.gz`](https://github.com/chensen-pro-plus/senlinlon/releases/download/v1.0.0/senlinlon-linux-arm64.tar.gz) |
| Windows | x64 | [`senlinlon-windows-x64.zip`](https://github.com/chensen-pro-plus/senlinlon/releases/download/v1.0.0/senlinlon-windows-x64.zip) |

> 💡 **提示**：如果您的 CPU 较老，请选择 `baseline` 版本；Alpine Linux 用户请选择 `musl` 版本。
> 
> 📋 **所有版本**：[查看全部下载](https://github.com/chensen-pro-plus/senlinlon/releases/latest)

## 💻 系统要求

- **macOS**: macOS 10.15+ (Catalina 或更新)
- **Linux**: glibc 2.27+ 或 musl libc (Alpine Linux)
- **Windows**: Windows 10/11 (64-bit)
- **内存**: 至少 2GB RAM
- **磁盘**: 约 150MB 可用空间

## 🔐 文件校验

下载 [`SHA256SUMS.txt`](https://github.com/chensen-pro-plus/senlinlon/releases/download/v1.0.0/SHA256SUMS.txt) 验证文件完整性：

```bash
# macOS / Linux
shasum -a 256 -c SHA256SUMS.txt

# Windows PowerShell
Get-FileHash senlinlon-windows-x64.zip -Algorithm SHA256
```

## 📜 更新日志

查看 [Releases](https://github.com/chensen-pro-plus/senlinlon/releases) 页面获取完整的版本历史。

## 📄 许可证

本项目采用 MIT 许可证。详见 [LICENSE](LICENSE) 文件。

---

© 2026 Senlinlon
