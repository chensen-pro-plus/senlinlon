# 手动完成 Senlinlon v1.0.0 发布

## ✅ 已完成的步骤

1. ✅ 构建所有平台（11 个平台）
2. ✅ 打包所有二进制（13 个文件）
3. ✅ 生成 SHA256 校验和
4. ✅ 创建 git tag v1.0.0
5. ✅ 推送到 gitcode.com/senlinlon/myOpenCode

## 📦 准备好的发布文件

所有文件位于：`packages/opencode/dist/`

```
senlinlon-darwin-arm64.tar.gz           (macOS Apple Silicon)
senlinlon-darwin-x64.tar.gz             (macOS Intel)
senlinlon-darwin-x64-baseline.tar.gz    (macOS Intel 兼容版)
senlinlon-linux-arm64.tar.gz            (Linux ARM64)
senlinlon-linux-x64.tar.gz              (Linux x64)
senlinlon-linux-x64-baseline.tar.gz     (Linux x64 兼容版)
senlinlon-linux-arm64-musl.tar.gz       (Linux ARM64 musl)
senlinlon-linux-x64-musl.tar.gz         (Linux x64 musl)
senlinlon-linux-x64-baseline-musl.tar.gz (Linux x64 baseline musl)
senlinlon-windows-x64.tar.gz            (Windows x64)
senlinlon-windows-x64-baseline.tar.gz   (Windows x64 兼容版)
senlinlon-windows-x64.zip               (Windows x64 ZIP)
senlinlon-windows-x64-baseline.zip      (Windows x64 baseline ZIP)
SHA256SUMS.txt                          (校验和文件)
```

## 🚀 接下来的步骤

### 方式 1: 推送到 GitHub 并创建 Release（推荐）

#### 1. 添加你的 GitHub 仓库为远程

```bash
# 如果还没有添加
git remote add github https://github.com/senlinlon/myOpenCode.git

# 或更新现有的
git remote set-url github https://github.com/senlinlon/myOpenCode.git
```

#### 2. 推送分支和 tag 到 GitHub

```bash
# 推送分支
git push github senlinlon-rebranding --no-verify

# 推送 tag
git push github v1.0.0 --no-verify
```

#### 3. 在 GitHub 网页创建 Release

1. 访问：https://github.com/senlinlon/myOpenCode/releases
2. 点击 "Draft a new release"
3. 选择 tag: `v1.0.0`
4. Release title: `Senlinlon v1.0.0`
5. Description: 复制下面的内容

```markdown
## 🎉 Senlinlon v1.0.0

首个正式版本！这是基于 OpenCode 的品牌重塑版本。

### ✨ 特性
- 完整的 OpenCode 功能
- 独立的品牌标识（Senlinlon）
- 可与原版 OpenCode 共存

### 📦 支持的平台

| 平台 | 文件 | 说明 |
|------|------|------|
| macOS (Apple Silicon) | `senlinlon-darwin-arm64.tar.gz` | M1/M2/M3 Mac |
| macOS (Intel) | `senlinlon-darwin-x64.tar.gz` | Intel Mac |
| Linux (x64) | `senlinlon-linux-x64.tar.gz` | 主流 Linux 发行版 |
| Linux (ARM64) | `senlinlon-linux-arm64.tar.gz` | ARM64 Linux |
| Windows (x64) | `senlinlon-windows-x64.zip` | Windows 10/11 |

*更多平台变体请查看下方的 Assets*

### 📥 快速安装

**macOS (Apple Silicon):**
\`\`\`bash
curl -L https://github.com/senlinlon/myOpenCode/releases/download/v1.0.0/senlinlon-darwin-arm64.tar.gz | tar xz
cd senlinlon-darwin-arm64
sudo ln -sf $(pwd)/bin/senlinlon /usr/local/bin/senlinlon
senlinlon --version
\`\`\`

**macOS (Intel):**
\`\`\`bash
curl -L https://github.com/senlinlon/myOpenCode/releases/download/v1.0.0/senlinlon-darwin-x64.tar.gz | tar xz
cd senlinlon-darwin-x64
sudo ln -sf $(pwd)/bin/senlinlon /usr/local/bin/senlinlon
senlinlon --version
\`\`\`

**Linux (x64):**
\`\`\`bash
curl -L https://github.com/senlinlon/myOpenCode/releases/download/v1.0.0/senlinlon-linux-x64.tar.gz | tar xz
cd senlinlon-linux-x64
sudo ln -sf $(pwd)/bin/senlinlon /usr/local/bin/senlinlon
senlinlon --version
\`\`\`

**Windows:**
1. 下载 `senlinlon-windows-x64.zip`
2. 解压到任意目录
3. 将 `bin` 目录添加到系统 PATH

### 🔒 校验和验证

下载后请验证文件完整性：
\`\`\`bash
shasum -a 256 -c SHA256SUMS.txt
\`\`\`

### 📝 完整更新日志

**品牌重塑完成:**
- ✅ 产品名：OpenCode → Senlinlon
- ✅ CLI 命令：opencode → senlinlon
- ✅ 环境变量：OPENCODE_* → SENLINLON_*
- ✅ 配置目录：~/.config/opencode → ~/.config/senlinlon
- ✅ 项目目录：.opencode/ → .senlinlon/
- ✅ Desktop 标识：ai.opencode.desktop → ai.senlinlon.desktop

**详细报告:** 查看仓库中的 `.sisyphus/notepads/senlinlon-rebranding/COMPLETION_REPORT.md`

### 🆘 获取帮助

- 📖 [构建指南](BUILD_GUIDE.md)
- 📋 [发布指南](RELEASE_GUIDE.md)
- 🐛 [报告问题](https://github.com/senlinlon/myOpenCode/issues)
```

6. 上传文件：
   - 从 `packages/opencode/dist/` 拖拽所有 `.tar.gz` 和 `.zip` 文件
   - 上传 `SHA256SUMS.txt`

7. 点击 "Publish release"

### 方式 2: 使用 GitCode Releases（如果 GitHub 不可用）

1. 访问：https://gitcode.com/senlinlon/myOpenCode/releases
2. 创建新 Release
3. 按照上面相同的步骤操作

---

## 📊 发布状态

```
✅ 代码已推送到 gitcode.com/senlinlon/myOpenCode
✅ Tag v1.0.0 已创建
✅ 所有平台二进制已构建并打包
✅ SHA256 校验和已生成
⏳ 等待：在 GitHub 上创建 Release
```

---

## 🔧 如果需要重新授权 GitHub CLI

```bash
# 1. 重新授权（添加 workflow 权限）
gh auth refresh -h github.com -s workflow

# 2. 复制显示的代码
# 3. 在浏览器中访问 https://github.com/login/device
# 4. 粘贴代码并授权

# 5. 完成后重新运行发布命令
./release.sh 1.0.0
```

---

**所有文件准备就绪，只需要在 GitHub 网页上创建 Release 并上传文件即可！**
