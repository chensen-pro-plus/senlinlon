# 创建 senlinlon-integrated 分支并上传到私有仓库

## Context

### Original Request
在 opencode/packages/oh-my-opencode-senlinlon 创建 git 分支，上传到私有仓库，并创建资料目录记录实现细节方便后续合并官方更新。

### Interview Summary
**Key Discussions**:
- 目标仓库: `https://gitcode.com/senlinlon/oh-my-opencode-senlinlon.git`
- 分支名称: `senlinlon-integrated`
- 创建资料目录记录修改细节

**Background**:
- 刚完成将 oh-my-opencode 集成到 opencode 的工作
- 代码已在 packages/oh-my-opencode-senlinlon/ 目录
- 需要独立维护此分支，方便后续拉取官方更新合并

---

## Work Objectives

### Core Objective
将修改后的 oh-my-opencode-senlinlon 代码上传到私有 git 仓库，并创建完整的资料文档方便后续维护。

### Concrete Deliverables
- 独立的 git 仓库在 packages/oh-my-opencode-senlinlon/
- 推送到 gitcode.com/senlinlon/oh-my-opencode-senlinlon
- 资料/ 目录包含实现细节文档

### Definition of Done
- [ ] 代码推送到 gitcode.com 成功
- [ ] 分支名称为 senlinlon-integrated
- [ ] 资料/ 目录创建且包含完整文档
- [ ] 可以通过 git pull 拉取更新

### Must Have
- 完整的修改记录文档
- 与原版差异说明
- 合并指南

### Must NOT Have (Guardrails)
- 不推送到原作者仓库 (code-yeongyu/oh-my-opencode)
- 不删除原作者信息

---

## Verification Strategy

### Manual Execution Verification
- [ ] `git remote -v` 显示正确的 remote
- [ ] `git branch` 显示 senlinlon-integrated 分支
- [ ] `git push` 成功
- [ ] `ls 资料/` 显示文档文件

---

## Task Flow

```
Task 1 (Git Setup) 
    ↓
Task 2 (Create Branch & Commit)
    ↓
Task 3 (Push to Remote)
    ↓
Task 4 (Create Documentation)
```

---

## TODOs

- [ ] 1. 设置 git 仓库和 remote

  **What to do**:
  1. 进入 `packages/oh-my-opencode-senlinlon/` 目录
  2. 如果有 .git 目录但指向原作者仓库，需要重新配置 remote
  3. 添加或修改 origin remote 为: `https://gitcode.com/senlinlon/oh-my-opencode-senlinlon.git`
  4. 可选：添加 upstream remote 指向原作者仓库用于后续同步

  **Commands**:
  ```bash
  cd packages/oh-my-opencode-senlinlon
  
  # 检查是否有 .git 目录
  ls -la .git
  
  # 如果没有，初始化新仓库
  git init
  
  # 配置 remote
  git remote remove origin 2>/dev/null || true
  git remote add origin https://gitcode.com/senlinlon/oh-my-opencode-senlinlon.git
  
  # 添加 upstream 用于后续同步官方更新
  git remote add upstream https://github.com/code-yeongyu/oh-my-opencode.git
  
  # 验证
  git remote -v
  ```

  **Acceptance Criteria**:
  - [ ] `git remote -v` 显示 origin 指向 gitcode.com
  - [ ] `git remote -v` 显示 upstream 指向 github.com/code-yeongyu

  **Commit**: NO

---

- [ ] 2. 创建分支并提交代码

  **What to do**:
  1. 创建 senlinlon-integrated 分支
  2. 添加所有文件到暂存区
  3. 创建初始提交

  **Commands**:
  ```bash
  cd packages/oh-my-opencode-senlinlon
  
  # 创建并切换到新分支
  git checkout -b senlinlon-integrated
  
  # 添加所有文件
  git add .
  
  # 创建提交
  git commit -m "feat: initial senlinlon-integrated version

  This is a forked and customized version of oh-my-opencode for integration
  into the opencode monorepo as an internal plugin.

  Key changes:
  - Package renamed to @opencode-ai/oh-my-opencode-senlinlon
  - Config file renamed to oh-my-opencode-senlinlon.json
  - CLI components removed (now built-in)
  - Platform binary packages removed
  - GitHub references updated to senlinlon repo
  - Schema URL changed to relative path

  Based on oh-my-opencode v3.1.2
  Original author: YeonGyu-Kim (code-yeongyu)"
  ```

  **Acceptance Criteria**:
  - [ ] `git branch` 显示当前在 senlinlon-integrated 分支
  - [ ] `git log -1` 显示正确的提交信息

  **Commit**: YES (这个任务本身就是创建提交)

---

- [ ] 3. 推送到远程仓库

  **What to do**:
  1. 推送分支到 gitcode.com
  2. 设置上游跟踪

  **Commands**:
  ```bash
  cd packages/oh-my-opencode-senlinlon
  
  # 推送并设置上游
  git push -u origin senlinlon-integrated
  ```

  **Note**: 如果仓库不存在，需要先在 gitcode.com 创建仓库

  **Acceptance Criteria**:
  - [ ] `git push` 成功
  - [ ] `git status` 显示 "Your branch is up to date"

  **Commit**: NO

---

- [ ] 4. 创建资料目录和文档

  **What to do**:
  1. 创建 `资料/` 目录
  2. 创建以下文档:
     - `修改清单.md` - 所有修改的文件和内容
     - `与原版差异.md` - 详细的差异说明
     - `合并指南.md` - 如何从官方拉取更新并合并
     - `版本对应.md` - 本版本对应的原版版本号

  **文档内容模板**:

  ### 修改清单.md
  ```markdown
  # 修改清单

  ## 基于版本
  oh-my-opencode v3.1.2

  ## 修改的文件

  ### package.json
  - name: oh-my-opencode → @opencode-ai/oh-my-opencode-senlinlon
  - 添加 private: true
  - 删除 bin, optionalDependencies, files, trustedDependencies
  - 依赖改为 workspace:* 和 catalog:
  - repository/bugs/homepage URL 更新

  ### 配置相关
  - oh-my-opencode.json → oh-my-opencode-senlinlon.json (所有引用)
  - 缓存目录: oh-my-opencode → oh-my-opencode-senlinlon
  - 日志文件: oh-my-opencode.log → oh-my-opencode-senlinlon.log

  ### Schema
  - URL 改为相对路径 ./oh-my-opencode-senlinlon.schema.json
  - 文件名改为 oh-my-opencode-senlinlon.schema.json

  ### GitHub 引用
  - code-yeongyu/oh-my-opencode → senlinlon/oh-my-opencode-senlinlon
  - 保留了历史 issue 引用（注释中）

  ### 删除的目录/文件
  - src/cli/ (完整删除)
  - bin/ (完整删除)
  - packages/ (平台二进制包)
  - postinstall.mjs
  - bun.lock
  - node_modules/
  - dist/ (构建后重新生成)

  ### 代码修改
  - src/hooks/auto-update-checker/index.ts - 移除 CLI 依赖
  ```

  ### 合并指南.md
  ```markdown
  # 从官方仓库合并更新指南

  ## 设置 upstream (已完成)
  git remote add upstream https://github.com/code-yeongyu/oh-my-opencode.git

  ## 拉取官方更新
  git fetch upstream

  ## 查看差异
  git diff senlinlon-integrated upstream/dev

  ## 合并步骤
  1. 确保在 senlinlon-integrated 分支
  2. git merge upstream/dev
  3. 解决冲突（注意保留我们的定制）
  4. 重新执行字符串替换（如果有新文件）
  5. 测试构建

  ## 需要重点检查的文件
  - package.json (依赖更新)
  - src/index.ts (新功能)
  - src/hooks/ (新 hooks)
  - src/tools/ (新工具)

  ## 合并后验证
  cd /Users/工作2/opencode工作区/opencode
  bun install
  cd packages/oh-my-opencode-senlinlon && bun run build
  ```

  **Acceptance Criteria**:
  - [ ] `ls 资料/` 显示 4 个 .md 文件
  - [ ] 每个文件内容完整

  **Commit**: YES
  - Message: `docs: add migration and maintenance documentation`

---

## Commit Strategy

| After Task | Message | Files |
|------------|---------|-------|
| 2 | `feat: initial senlinlon-integrated version` | 所有源文件 |
| 4 | `docs: add migration and maintenance documentation` | 资料/*.md |

---

## Success Criteria

### Verification Commands
```bash
# 1. 验证 remote 配置
cd packages/oh-my-opencode-senlinlon
git remote -v

# 2. 验证分支
git branch

# 3. 验证推送状态
git status

# 4. 验证资料目录
ls 资料/
```

### Final Checklist
- [ ] 代码已推送到 gitcode.com
- [ ] 分支名为 senlinlon-integrated
- [ ] 资料目录包含完整文档
- [ ] upstream remote 已配置用于后续同步
