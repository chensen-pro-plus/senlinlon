# Senlinlon GitHub Releases 发布指南

本指南将帮你通过 GitHub Releases 发布 Senlinlon。

---

## 📋 发布前准备

### 1. 构建所有平台的二进制文件

```bash
# 进入 CLI 目录
cd packages/opencode

# 清理旧构建
rm -rf dist

# 构建所有平台（这会花费几分钟）
bun run build

# 验证构建产物
ls -lh dist/
```

应该看到以下目录：

```
senlinlon-darwin-arm64/          (macOS Apple Silicon)
senlinlon-darwin-x64/            (macOS Intel)
senlinlon-darwin-x64-baseline/   (macOS Intel 兼容版)
senlinlon-linux-arm64/           (Linux ARM64)
senlinlon-linux-x64/             (Linux x64)
senlinlon-linux-x64-baseline/    (Linux x64 兼容版)
senlinlon-linux-arm64-musl/      (Linux ARM64 musl)
senlinlon-linux-x64-musl/        (Linux x64 musl)
senlinlon-windows-x64/           (Windows x64)
senlinlon-windows-x64-baseline/  (Windows x64 兼容版)
```

### 2. 打包所有平台的二进制

```bash
# 进入 dist 目录
cd dist

# 为每个平台创建压缩包
for dir in senlinlon-*; do
    echo "打包 $dir..."
    tar -czf "${dir}.tar.gz" "$dir/"
done

# 特别处理 Windows（创建 zip）
for dir in senlinlon-windows-*; do
    echo "打包 $dir (zip)..."
    zip -r "${dir}.zip" "$dir/"
done

# 查看生成的压缩包
ls -lh *.tar.gz *.zip 2>/dev/null
```

### 3. 创建 checksums（可选但推荐）

```bash
# 生成 SHA256 校验和
shasum -a 256 *.tar.gz *.zip > SHA256SUMS.txt

# 查看
cat SHA256SUMS.txt
```

---

## 🚀 发布步骤

### 方式 A: 使用 GitHub CLI（推荐）

#### 安装 GitHub CLI（如果还没有）

```bash
# macOS
brew install gh

# 登录
gh auth login
```

#### 推送代码并创建 Release

```bash
# 1. 返回项目根目录
cd ../../..  # 从 packages/opencode/dist 回到根目录

# 2. 确保所有更改已提交
git status

# 3. 推送到你的 GitHub 仓库
git push myorigin senlinlon-rebranding

# 4. 创建并推送 tag
git tag v1.0.0 -m "Senlinlon v1.0.0 - 首个正式版本"
git push myorigin v1.0.0

# 5. 创建 GitHub Release
gh release create v1.0.0 \
  --repo senlinlon/myOpenCode \
  --title "Senlinlon v1.0.0" \
  --notes "## 🎉 Senlinlon v1.0.0

首个正式版本！这是基于 OpenCode 的品牌重塑版本。

### ✨ 特性
- 完整的 OpenCode 功能
- 独立的品牌标识（Senlinlon）
- 可与原版 OpenCode 共存

### 📦 安装方法

#### macOS (Apple Silicon)
\`\`\`bash
curl -L https://github.com/senlinlon/myOpenCode/releases/download/v1.0.0/senlinlon-darwin-arm64.tar.gz | tar xz
cd senlinlon-darwin-arm64
./bin/senlinlon --version
\`\`\`

#### macOS (Intel)
\`\`\`bash
curl -L https://github.com/senlinlon/myOpenCode/releases/download/v1.0.0/senlinlon-darwin-x64.tar.gz | tar xz
cd senlinlon-darwin-x64
./bin/senlinlon --version
\`\`\`

#### Linux (x64)
\`\`\`bash
curl -L https://github.com/senlinlon/myOpenCode/releases/download/v1.0.0/senlinlon-linux-x64.tar.gz | tar xz
cd senlinlon-linux-x64
./bin/senlinlon --version
\`\`\`

### 🔒 校验和
查看 SHA256SUMS.txt 验证下载文件的完整性。

### 📝 更新日志
- 品牌重塑：OpenCode → Senlinlon
- 环境变量前缀：OPENCODE_* → SENLINLON_*
- 配置目录：~/.config/opencode → ~/.config/senlinlon
- 详见仓库中的 COMPLETION_REPORT.md
" \
  packages/opencode/dist/*.tar.gz \
  packages/opencode/dist/*.zip \
  packages/opencode/dist/SHA256SUMS.txt

# 6. 查看创建的 Release
gh release view v1.0.0 --repo senlinlon/myOpenCode
```

---

### 方式 B: 使用 GitHub 网页界面

#### 1. 推送代码和 tag

```bash
# 推送分支
git push myorigin senlinlon-rebranding

# 创建并推送 tag
git tag v1.0.0 -m "Senlinlon v1.0.0"
git push myorigin v1.0.0
```

#### 2. 在 GitHub 创建 Release

1. 访问 `https://github.com/senlinlon/myOpenCode`
2. 点击右侧的 "Releases"
3. 点击 "Draft a new release"
4. 填写信息：
   - **Tag**: 选择 `v1.0.0`（或创建新 tag）
   - **Release title**: `Senlinlon v1.0.0`
   - **Description**: 参考下面的模板
5. 上传文件：
   - 从 `packages/opencode/dist/` 拖拽所有 `.tar.gz` 和 `.zip` 文件
   - 上传 `SHA256SUMS.txt`
6. 点击 "Publish release"

#### Release Description 模板

````markdown
## 🎉 Senlinlon v1.0.0

首个正式版本！这是基于 OpenCode 的品牌重塑版本。

### ✨ 特性

- 完整的 OpenCode 功能
- 独立的品牌标识（Senlinlon）
- 可与原版 OpenCode 共存

### 📦 下载和安装

选择适合你平台的版本下载：

| 平台                  | 文件                            | 说明              |
| --------------------- | ------------------------------- | ----------------- |
| macOS (Apple Silicon) | `senlinlon-darwin-arm64.tar.gz` | M1/M2/M3 Mac      |
| macOS (Intel)         | `senlinlon-darwin-x64.tar.gz`   | Intel Mac         |
| Linux (x64)           | `senlinlon-linux-x64.tar.gz`    | 主流 Linux 发行版 |
| Linux (ARM64)         | `senlinlon-linux-arm64.tar.gz`  | ARM64 Linux       |
| Windows (x64)         | `senlinlon-windows-x64.zip`     | Windows 10/11     |

#### 快速安装

**macOS/Linux:**

```bash
# 1. 下载并解压（替换为你的平台）
curl -L https://github.com/senlinlon/myOpenCode/releases/download/v1.0.0/senlinlon-darwin-arm64.tar.gz | tar xz

# 2. 进入目录
cd senlinlon-darwin-arm64

# 3. 测试
./bin/senlinlon --version

# 4. 全局安装（可选）
sudo ln -sf $(pwd)/bin/senlinlon /usr/local/bin/senlinlon
```
````

**Windows:**

```powershell
# 1. 下载 senlinlon-windows-x64.zip
# 2. 解压到任意目录
# 3. 将 bin 目录添加到 PATH
```

### 🔒 校验和

下载后请验证文件完整性：

```bash
shasum -a 256 -c SHA256SUMS.txt
```

### 📝 完整更新日志

- ✅ 品牌重塑：OpenCode → Senlinlon
- ✅ 环境变量：OPENCODE*\* → SENLINLON*\*
- ✅ 配置目录：~/.config/opencode → ~/.config/senlinlon
- ✅ 项目目录：.opencode/ → .senlinlon/
- ✅ CLI 命令：opencode → senlinlon

详见仓库中的 `.sisyphus/notepads/senlinlon-rebranding/COMPLETION_REPORT.md`

### 🐛 已知问题

- 152 个测试失败（继承自原版 OpenCode，非品牌重塑导致）

### 📚 文档

- [构建指南](BUILD_GUIDE.md)
- [完成报告](.sisyphus/notepads/senlinlon-rebranding/COMPLETION_REPORT.md)

````

---

## 🔄 后续版本发布

### 发布 patch 版本（修复 bug）

```bash
# 1. 修复代码并提交
git add .
git commit -m "fix: 修复某个问题"

# 2. 重新构建
cd packages/opencode
rm -rf dist
bun run build

# 3. 打包
cd dist
for dir in senlinlon-*; do tar -czf "${dir}.tar.gz" "$dir/"; done
shasum -a 256 *.tar.gz > SHA256SUMS.txt

# 4. 创建新 tag 和 release
cd ../../..
git tag v1.0.1 -m "Senlinlon v1.0.1 - Bug 修复"
git push myorigin v1.0.1

gh release create v1.0.1 \
  --repo senlinlon/myOpenCode \
  --title "Senlinlon v1.0.1" \
  --notes "## Bug 修复版本

- 修复了 xxx 问题
- 改进了 yyy 功能
" \
  packages/opencode/dist/*.tar.gz \
  packages/opencode/dist/SHA256SUMS.txt
````

---

## 📊 发布后验证

### 检查 Release

```bash
# 使用 gh CLI
gh release view v1.0.0 --repo senlinlon/myOpenCode

# 或访问网页
# https://github.com/senlinlon/myOpenCode/releases
```

### 测试用户下载体验

```bash
# 模拟用户下载
cd /tmp
curl -L https://github.com/senlinlon/myOpenCode/releases/download/v1.0.0/senlinlon-darwin-arm64.tar.gz | tar xz
cd senlinlon-darwin-arm64
./bin/senlinlon --version
```

---

## 🎯 最佳实践

### 版本号规范（Semantic Versioning）

- **v1.0.0** - 首个稳定版本
- **v1.0.x** - Bug 修复（不破坏兼容性）
- **v1.x.0** - 新功能（不破坏兼容性）
- **v2.0.0** - 重大变更（可能破坏兼容性）

### Release Notes 建议

每个 Release 应包含：

1. 📝 **新功能** - 添加了什么
2. 🐛 **Bug 修复** - 修复了什么
3. 💥 **破坏性变更** - 需要用户注意的变更
4. 📦 **下载说明** - 如何安装
5. 🔒 **校验和** - 安全验证

---

## 🚨 常见问题

### Q: Release 创建后可以修改吗？

A: 可以。使用 `gh release edit v1.0.0` 或在网页界面编辑。

### Q: 如何删除错误的 Release？

```bash
gh release delete v1.0.0 --repo senlinlon/myOpenCode --yes
git push myorigin :refs/tags/v1.0.0  # 同时删除 tag
```

### Q: 如何标记为预发布版（Pre-release）？

```bash
gh release create v1.0.0-beta \
  --prerelease \
  --title "Senlinlon v1.0.0-beta" \
  ...
```

### Q: 文件太大上传失败？

- GitHub 单个文件限制 2GB
- 如果需要分割：`split -b 1900M senlinlon-large.tar.gz senlinlon-large.tar.gz.part-`

---

## ✅ 发布检查清单

- [ ] 所有平台构建成功
- [ ] 打包所有二进制文件（.tar.gz / .zip）
- [ ] 生成 SHA256SUMS.txt
- [ ] 推送代码到 GitHub
- [ ] 创建并推送 tag
- [ ] 创建 GitHub Release
- [ ] 上传所有文件
- [ ] 填写详细的 Release Notes
- [ ] 测试用户下载和安装流程
- [ ] 在 README 中添加安装说明链接

---

**准备好了吗？按照上面的步骤开始发布吧！**
