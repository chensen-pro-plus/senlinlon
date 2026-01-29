#!/bin/bash

# Senlinlon 自动发布脚本
# 用法: ./release.sh <version> [--dry-run]
#
# 示例:
#   ./release.sh 1.0.0          # 发布 v1.0.0
#   ./release.sh 1.0.1 --dry-run  # 预览但不实际发布

set -e

VERSION="$1"
DRY_RUN=""

if [ -z "$VERSION" ]; then
    echo "❌ 错误: 请提供版本号"
    echo "用法: ./release.sh <version> [--dry-run]"
    echo "示例: ./release.sh 1.0.0"
    exit 1
fi

if [ "$2" == "--dry-run" ]; then
    DRY_RUN="true"
    echo "🔍 预览模式（不会实际发布）"
fi

TAG="v${VERSION}"
REPO="senlinlon/myOpenCode"

echo "📦 Senlinlon 发布脚本"
echo "===================="
echo "版本: ${TAG}"
echo "仓库: ${REPO}"
echo ""

# 检查 gh CLI
if ! command -v gh &> /dev/null; then
    echo "❌ 错误: 未安装 GitHub CLI (gh)"
    echo "安装方法: brew install gh"
    exit 1
fi

# 检查是否登录
if ! gh auth status &> /dev/null; then
    echo "❌ 错误: 未登录 GitHub CLI"
    echo "运行: gh auth login"
    exit 1
fi

# 检查工作目录是否干净
if [ -z "$DRY_RUN" ]; then
    if [ -n "$(git status --porcelain)" ]; then
        echo "⚠️  警告: 工作目录有未提交的更改"
        read -p "是否继续? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
fi

echo ""
echo "📝 步骤 1/6: 构建所有平台"
echo "========================"

cd packages/opencode

if [ -d "dist" ]; then
    echo "清理旧构建..."
    rm -rf dist
fi

echo "开始构建（这可能需要几分钟）..."
bun run build

if [ ! -d "dist" ]; then
    echo "❌ 错误: 构建失败"
    exit 1
fi

BUILT_PLATFORMS=$(ls dist | wc -l)
echo "✓ 成功构建 ${BUILT_PLATFORMS} 个平台"

echo ""
echo "📦 步骤 2/6: 打包二进制文件"
echo "=========================="

cd dist

# 计数器
PACKED=0

# 打包 tar.gz
for dir in senlinlon-*; do
    if [ -d "$dir" ]; then
        echo "打包 ${dir}.tar.gz..."
        tar -czf "${dir}.tar.gz" "$dir/"
        PACKED=$((PACKED + 1))
    fi
done

# 特别处理 Windows (zip)
for dir in senlinlon-windows-*; do
    if [ -d "$dir" ]; then
        if command -v zip &> /dev/null; then
            echo "打包 ${dir}.zip..."
            zip -r -q "${dir}.zip" "$dir/"
            PACKED=$((PACKED + 1))
        fi
    fi
done

echo "✓ 打包完成: ${PACKED} 个文件"

echo ""
echo "🔒 步骤 3/6: 生成校验和"
echo "======================"

if command -v shasum &> /dev/null; then
    shasum -a 256 *.tar.gz *.zip 2>/dev/null > SHA256SUMS.txt
    echo "✓ 已生成 SHA256SUMS.txt"
    echo ""
    cat SHA256SUMS.txt
else
    echo "⚠️  警告: shasum 不可用，跳过校验和生成"
fi

# 回到项目根目录
cd ../../..

if [ -n "$DRY_RUN" ]; then
    echo ""
    echo "🔍 预览模式 - 以下是将要执行的操作:"
    echo ""
    echo "1. git tag ${TAG} -m \"Senlinlon ${TAG}\""
    echo "2. git push myorigin ${TAG}"
    echo "3. gh release create ${TAG} --repo ${REPO}"
    echo "4. 上传以下文件:"
    ls -1 packages/opencode/dist/*.tar.gz packages/opencode/dist/*.zip packages/opencode/dist/SHA256SUMS.txt 2>/dev/null | sed 's/^/   - /'
    echo ""
    echo "运行不带 --dry-run 参数来实际发布"
    exit 0
fi

echo ""
echo "🏷️  步骤 4/6: 创建 Git Tag"
echo "========================"

# 检查 tag 是否已存在
if git rev-parse "$TAG" >/dev/null 2>&1; then
    echo "⚠️  警告: Tag ${TAG} 已存在"
    read -p "是否删除并重新创建? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git tag -d "$TAG"
        git push myorigin ":refs/tags/$TAG" 2>/dev/null || true
    else
        exit 1
    fi
fi

git tag "$TAG" -m "Senlinlon ${TAG}"
echo "✓ 创建 tag: ${TAG}"

echo ""
echo "⬆️  步骤 5/6: 推送到 GitHub"
echo "========================"

git push myorigin senlinlon-rebranding
git push myorigin "$TAG"
echo "✓ 已推送代码和 tag"

echo ""
echo "🚀 步骤 6/6: 创建 GitHub Release"
echo "=============================="

# Release notes
RELEASE_NOTES="## 🎉 Senlinlon ${TAG}

基于 OpenCode 的品牌重塑版本。

### ✨ 特性
- 完整的 OpenCode 功能
- 独立的品牌标识（Senlinlon）
- 可与原版 OpenCode 共存

### 📦 快速安装

**macOS (Apple Silicon):**
\`\`\`bash
curl -L https://github.com/${REPO}/releases/download/${TAG}/senlinlon-darwin-arm64.tar.gz | tar xz
cd senlinlon-darwin-arm64
sudo ln -sf \$(pwd)/bin/senlinlon /usr/local/bin/senlinlon
senlinlon --version
\`\`\`

**macOS (Intel):**
\`\`\`bash
curl -L https://github.com/${REPO}/releases/download/${TAG}/senlinlon-darwin-x64.tar.gz | tar xz
cd senlinlon-darwin-x64
sudo ln -sf \$(pwd)/bin/senlinlon /usr/local/bin/senlinlon
senlinlon --version
\`\`\`

**Linux (x64):**
\`\`\`bash
curl -L https://github.com/${REPO}/releases/download/${TAG}/senlinlon-linux-x64.tar.gz | tar xz
cd senlinlon-linux-x64
sudo ln -sf \$(pwd)/bin/senlinlon /usr/local/bin/senlinlon
senlinlon --version
\`\`\`

### 🔒 校验和
请查看 SHA256SUMS.txt 验证文件完整性：
\`\`\`bash
shasum -a 256 -c SHA256SUMS.txt
\`\`\`

### 📝 更新日志
详见 [COMPLETION_REPORT.md](.sisyphus/notepads/senlinlon-rebranding/COMPLETION_REPORT.md)
"

# 创建 Release
gh release create "$TAG" \
  --repo "$REPO" \
  --title "Senlinlon ${TAG}" \
  --notes "$RELEASE_NOTES" \
  packages/opencode/dist/*.tar.gz \
  packages/opencode/dist/*.zip \
  packages/opencode/dist/SHA256SUMS.txt

echo ""
echo "✅ 发布成功！"
echo ""
echo "Release URL:"
gh release view "$TAG" --repo "$REPO" --web || echo "https://github.com/${REPO}/releases/tag/${TAG}"

echo ""
echo "🎉 完成！Senlinlon ${TAG} 已发布到 GitHub Releases"
