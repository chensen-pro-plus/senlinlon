# Senlinlon

**Senlinlon** 是一个基于 OpenCode 的强大 AI 编程助手，为开发者提供智能代码生成、调试和优化功能。

## 特性

- 🚀 **智能代码生成** - 基于自然语言描述生成高质量代码
- 🔍 **代码理解与分析** - 深度理解代码库结构和逻辑
- 🛠️ **自动调试与修复** - 自动检测并修复代码问题
- 📝 **文档生成** - 自动生成代码文档和注释
- 🌐 **多语言支持** - 支持主流编程语言

## 安装

### macOS (Apple Silicon)

```bash
curl -L https://github.com/senlinlon/senlinlon/releases/download/v1.0.0/senlinlon-darwin-arm64.tar.gz | tar -xz
sudo mv senlinlon /usr/local/bin/
```

### macOS (Intel)

```bash
curl -L https://github.com/senlinlon/senlinlon/releases/download/v1.0.0/senlinlon-darwin-x64.tar.gz | tar -xz
sudo mv senlinlon /usr/local/bin/
```

### Linux (x64)

```bash
curl -L https://github.com/senlinlon/senlinlon/releases/download/v1.0.0/senlinlon-linux-x64.tar.gz | tar -xz
sudo mv senlinlon /usr/local/bin/
```

### Linux (ARM64)

```bash
curl -L https://github.com/senlinlon/senlinlon/releases/download/v1.0.0/senlinlon-linux-arm64.tar.gz | tar -xz
sudo mv senlinlon /usr/local/bin/
```

### Windows

1. 下载 [senlinlon-windows-x64.zip](https://github.com/senlinlon/senlinlon/releases/download/v1.0.0/senlinlon-windows-x64.zip)
2. 解压到目标目录
3. 将解压目录添加到系统 PATH 环境变量

## 快速开始

安装完成后，在终端中运行：

```bash
senlinlon --version
```

查看帮助信息：

```bash
senlinlon --help
```

## 平台支持

| 平台 | 架构 | 状态 |
|------|------|------|
| macOS | ARM64 (Apple Silicon) | ✅ 支持 |
| macOS | x64 (Intel) | ✅ 支持 |
| Linux | x64 | ✅ 支持 |
| Linux | ARM64 | ✅ 支持 |
| Windows | x64 | ✅ 支持 |

每个平台提供标准版和 baseline/musl 变体以兼容不同环境。

## 系统要求

- macOS 10.15+
- Linux (glibc 2.27+ 或 musl)
- Windows 10+

## 更新日志

查看 [Releases](https://github.com/senlinlon/senlinlon/releases) 页面获取完整的版本历史和更新日志。

## 许可证

详见 [LICENSE](LICENSE) 文件。

## 支持

如有问题或建议，欢迎通过 [Issues](https://github.com/senlinlon/senlinlon/issues) 反馈。

---

© 2026 Senlinlon. All rights reserved.
