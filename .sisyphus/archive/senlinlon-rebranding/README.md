# Senlinlon 品牌重塑 - 项目概览

> **创建时间**: 2026-01-29
> **状态**: 待执行
> **计划位置**: `.sisyphus/plans/senlinlon-rebranding.md`

---

## 📋 项目目标

将 OpenCode 项目重塑为 **Senlinlon** 独立产品，使其可与原版 OpenCode 在同一系统上共存。

---

## 🎯 品牌映射速查表

| 类别              | 原版 OpenCode             | 新版 Senlinlon                                |
| ----------------- | ------------------------- | --------------------------------------------- |
| 产品名称          | `opencode`                | `senlinlon`                                   |
| 产品显示名        | `OpenCode`                | `Senlinlon`                                   |
| npm scope         | `@opencode-ai`            | `@senlinlon`                                  |
| npm CLI 包        | `opencode-ai`             | `senlinlon`                                   |
| CLI 命令          | `opencode`                | `senlinlon`                                   |
| 环境变量前缀      | `OPENCODE_*`              | `SENLINLON_*`                                 |
| XDG 目录          | `~/.config/opencode`      | `~/.config/senlinlon`                         |
| 项目目录          | `.opencode/`              | `.senlinlon/`                                 |
| 配置文件          | `opencode.json`           | `senlinlon.json`                              |
| Desktop ID (dev)  | `ai.opencode.desktop.dev` | `ai.senlinlon.desktop.dev`                    |
| Desktop ID (prod) | `ai.opencode.desktop`     | `ai.senlinlon.desktop`                        |
| GitHub 仓库       | `anomalyco/opencode`      | `chensen-pro-plus/opencode-senlinlon-Publish` |

---

## 📁 文档结构

```
.sisyphus/archive/senlinlon-rebranding/
├── README.md                    # 本文件 - 项目概览
├── requirements.md              # 需求和决策记录
├── research-findings.md         # 代码库研究发现
└── execution-guide.md           # 执行指南

.sisyphus/plans/
└── senlinlon-rebranding.md      # 完整的工作计划（10个任务）
```

---

## ⏱️ 预计工作量

| 阶段             | 任务数        | 预计时间    |
| ---------------- | ------------- | ----------- |
| Wave 1: 核心常量 | 3 个任务      | ~15 分钟    |
| Wave 2: 包名修改 | 4 个任务      | ~30 分钟    |
| Wave 3: 外围修改 | 2 个任务      | ~10 分钟    |
| 最终验证         | 1 个任务      | ~10 分钟    |
| **总计**         | **10 个任务** | **~1 小时** |

---

## 🚀 如何开始执行

当您准备好执行此计划时，运行：

```bash
/start-work
```

这将启动 Sisyphus 执行器，按照计划逐步完成所有任务。

---

## 📝 关键注意事项

1. **VS Code 扩展不在本次范围内** - `/sdks/vscode/` 目录将被跳过
2. **图标保持不变** - 如需新图标，需单独处理
3. **代码签名未配置** - 如需发布到商店，需要配置新的签名证书
4. **npm 发布需验证 scope 可用性** - 确保 `@senlinlon` scope 在 npm 上可用
