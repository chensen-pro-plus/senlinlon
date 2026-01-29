# Senlinlon 本地测试构建指南

## ✅ 当前状态

构建脚本已修复，现在可以正确生成 `senlinlon` 二进制文件。

---

## 📦 本地构建步骤

### 1. 清理并重新构建

```bash
# 进入 CLI 包目录
cd packages/opencode

# 清理旧的构建产物
rm -rf dist

# 选项 A: 只构建当前平台（推荐，更快）
bun run build --single

# 选项 B: 构建所有平台（需要时间较长）
bun run build
```

### 2. 验证构建产物

```bash
# 查看生成的二进制文件
ls -lh dist/senlinlon-darwin-arm64/bin/

# 应该看到:
# -rwxr-xr-x  1 user  staff   101M Jan 29 15:22 senlinlon

# 测试版本
./dist/senlinlon-darwin-arm64/bin/senlinlon --version
# 输出: 0.0.0-senlinlon-rebranding-202601290721

# 测试帮助
./dist/senlinlon-darwin-arm64/bin/senlinlon --help
```

### 3. 本地安装测试

```bash
# 返回项目根目录
cd ../..

# 方式 A: 创建符号链接到 bun bin 目录（推荐）
ln -sf "/Users/工作2/opencode工作区/opencode/packages/opencode/dist/senlinlon-darwin-arm64/bin/senlinlon" ~/.bun/bin/senlinlon

# 验证安装
which senlinlon
# 应该输出: /Users/chensen/.bun/bin/senlinlon

senlinlon --version
# 输出: 0.0.0-senlinlon-rebranding-202601290724
```

```bash
# 方式 B: 使用绝对路径（替换为你的实际路径）
SENLINLON_PATH="/Users/工作2/opencode工作区/opencode/packages/opencode/dist/senlinlon-darwin-arm64/bin/senlinlon"
ln -sf "$SENLINLON_PATH" ~/.bun/bin/senlinlon

# 验证
senlinlon --version
```

```bash
# 方式 C: 安装到系统路径（需要 sudo）
sudo ln -sf "/Users/工作2/opencode工作区/opencode/packages/opencode/dist/senlinlon-darwin-arm64/bin/senlinlon" /usr/local/bin/senlinlon

# 验证
senlinlon --version
```

**注意**:

- 方式 A 和 B 需要确保 `~/.bun/bin` 在你的 `$PATH` 中
- 方式 C 需要 sudo 权限，但任何用户都可以使用
- ⚠️ `bun install -g .` 不适用于 monorepo，需要使用符号链接

---

## 🧪 测试清单

### 基本功能测试

```bash
# ✅ 1. 版本信息
senlinlon --version

# ✅ 2. 帮助信息
senlinlon --help

# ✅ 3. 列出模型
senlinlon models

# ✅ 4. 认证测试（如果有 API key）
senlinlon auth

# ✅ 5. 运行简单命令
echo "console.log('hello')" > test.js
senlinlon run "检查这个文件"
```

### 数据目录验证

```bash
# 检查配置目录是否正确
ls -la ~/.config/senlinlon/

# 检查项目目录（如果在项目中运行）
ls -la .senlinlon/
```

---

## 📤 创建发布包（可选）

如果你想分享给其他人：

```bash
# 1. 打包当前平台的二进制
cd packages/opencode/dist
tar -czf senlinlon-darwin-arm64.tar.gz senlinlon-darwin-arm64/

# 2. 查看压缩包
ls -lh senlinlon-darwin-arm64.tar.gz

# 3. 其他人可以这样安装：
# tar -xzf senlinlon-darwin-arm64.tar.gz
# cd senlinlon-darwin-arm64
# ./bin/senlinlon --version
```

---

## 🔧 常见问题

### Q: 提示 "permission denied"

```bash
# 添加执行权限
chmod +x packages/opencode/dist/senlinlon-darwin-arm64/bin/senlinlon
```

### Q: 运行时提示找不到模块

```bash
# 确保在项目根目录安装了依赖
bun install
```

### Q: 版本号看起来很奇怪 (0.0.0-senlinlon-rebranding-...)

这是因为你在 `senlinlon-rebranding` 分支上。正式发布时：

1. 合并到 `dev` 或 `main` 分支
2. 打 tag: `git tag v1.0.0`
3. 重新构建

---

## 🚀 下一步（正式发布）

### 选项 1: 发布到 npm

```bash
# 1. 登录 npm（需要 npm 账号）
npm login

# 2. 创建 @senlinlon organization（在 npm 网站上）

# 3. 发布主包
cd packages/opencode
npm publish --access public

# 4. 其他人可以这样安装：
# npm install -g senlinlon
```

### 选项 2: GitHub Releases

1. 推送所有更改到 GitHub
2. 创建 Release 并上传构建的二进制文件
3. 用户可以下载 tar.gz 并解压使用

### 选项 3: 配置 GitHub Actions 自动发布

需要修改 `.github/workflows/publish.yml`，但这需要：

- npm token
- GitHub secrets 配置
- 修改 workflow 中的仓库检查

---

## ✅ 当前构建产物

```
dist/
├── senlinlon-darwin-arm64/        (macOS Apple Silicon)
├── senlinlon-darwin-x64/          (macOS Intel)
├── senlinlon-linux-arm64/         (Linux ARM64)
├── senlinlon-linux-x64/           (Linux x64)
├── senlinlon-windows-x64/         (Windows x64)
└── ... (其他平台变体)
```

每个目录包含：

- `bin/senlinlon` - 可执行二进制
- `package.json` - 包元数据

---

**构建时间**: 2026-01-29  
**版本**: 0.0.0-senlinlon-rebranding-202601290721  
**平台**: macOS ARM64 (darwin-arm64)
