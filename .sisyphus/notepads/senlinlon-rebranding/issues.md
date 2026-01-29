# Senlinlon Rebranding - Issues

## Problems & Gotchas

## [2026-01-29 Wave 1] 发现遗漏的 Flag 引用

发现遗漏：虽然 flag.ts 中环境变量定义已更名，但代码中使用 Flag.OPENCODE*\* 的地方（87 处，27 个文件）仍需替换为 Flag.SENLINLON*\*。

需要补充任务：全局替换 Flag.OPENCODE* → Flag.SENLINLON*

受影响文件列表：

- packages/opencode/src/cli/cmd/run.ts
- packages/opencode/src/cli/cmd/serve.ts
- packages/opencode/src/cli/cmd/session.ts
- packages/opencode/src/cli/cmd/tui/app.tsx
- packages/opencode/src/cli/cmd/tui/worker.ts
- packages/opencode/src/cli/cmd/web.ts
- packages/opencode/src/cli/upgrade.ts
- packages/opencode/src/config/config.ts
- packages/opencode/src/file/time.ts
- packages/opencode/src/file/watcher.ts
- packages/opencode/src/format/formatter.ts
- packages/opencode/src/installation/index.ts
- packages/opencode/src/lsp/index.ts
- packages/opencode/src/lsp/server.ts
- packages/opencode/src/plugin/index.ts
- packages/opencode/src/project/project.ts
- packages/opencode/src/provider/models.ts
- packages/opencode/src/provider/provider.ts
- packages/opencode/src/server/server.ts
- packages/opencode/src/session/index.ts
- packages/opencode/src/session/llm.ts
- packages/opencode/src/session/prompt.ts
- packages/opencode/src/session/system.ts
- packages/opencode/src/shell/shell.ts
- packages/opencode/src/skill/skill.ts
- packages/opencode/src/tool/bash.ts
- packages/opencode/src/tool/registry.ts
