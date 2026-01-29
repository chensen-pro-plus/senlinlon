#!/bin/bash
# Senlinlon 一键打包发布脚本
# 用法: ./release.sh [VERSION] [--single]
# 示例: ./release.sh v1.1.0
#       ./release.sh v1.1.0 --single  # 只构建当前平台

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置
GITHUB_REPO="chensen-pro-plus/senlinlon"
PROJECT_ROOT="/Users/工作2/opencode工作区/opencode"
BUILD_DIR="$PROJECT_ROOT/packages/opencode"
DIST_DIR="$BUILD_DIR/dist"

# 参数解析
VERSION="${1:-}"
SINGLE_FLAG=""
if [[ "$*" == *"--single"* ]]; then
    SINGLE_FLAG="--single"
fi

echo -e "${BLUE}======================================${NC}"
echo -e "${BLUE}   Senlinlon 一键打包发布工具${NC}"
echo -e "${BLUE}======================================${NC}"
echo ""

# 检查版本号
if [ -z "$VERSION" ]; then
    echo -e "${YELLOW}请输入版本号 (例如 v1.1.0):${NC}"
    read VERSION
fi

if [[ ! "$VERSION" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo -e "${RED}错误: 版本号格式不正确，应为 vX.Y.Z${NC}"
    exit 1
fi

echo -e "${GREEN}版本号: $VERSION${NC}"
echo -e "${GREEN}仓库: $GITHUB_REPO${NC}"
echo ""

# 步骤 1: 检查 GitHub CLI
echo -e "${BLUE}[1/7] 检查 GitHub CLI 认证...${NC}"
if ! gh auth status &>/dev/null; then
    echo -e "${RED}错误: 请先运行 'gh auth login' 登录 GitHub${NC}"
    exit 1
fi
echo -e "${GREEN}✓ GitHub CLI 已认证${NC}"
echo ""

# 步骤 2: 构建
echo -e "${BLUE}[2/7] 构建二进制文件...${NC}"
cd "$BUILD_DIR"
rm -rf dist

if [ -n "$SINGLE_FLAG" ]; then
    echo "只构建当前平台..."
    bun run script/build.ts --single
else
    echo "构建所有平台（可能需要 5-10 分钟）..."
    bun run script/build.ts
fi

# 检查构建结果
FILE_COUNT=$(ls "$DIST_DIR"/*.tar.gz "$DIST_DIR"/*.zip 2>/dev/null | wc -l | tr -d ' ')
echo -e "${GREEN}✓ 构建完成，共 $FILE_COUNT 个文件${NC}"
echo ""

# 步骤 3: 生成 SHA256
echo -e "${BLUE}[3/7] 生成 SHA256 校验和...${NC}"
cd "$DIST_DIR"
shasum -a 256 *.tar.gz *.zip 2>/dev/null > SHA256SUMS.txt
echo -e "${GREEN}✓ SHA256SUMS.txt 已生成${NC}"
echo ""

# 步骤 4: 检查仓库
echo -e "${BLUE}[4/7] 检查 GitHub 仓库...${NC}"
if gh repo view "$GITHUB_REPO" &>/dev/null; then
    echo -e "${GREEN}✓ 仓库已存在${NC}"
else
    echo -e "${YELLOW}仓库不存在，正在创建...${NC}"
    # 创建临时目录
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    echo "# Senlinlon\n\nSenlinlon 是一个强大的 AI 编程助手。" > README.md
    echo "MIT License" > LICENSE
    git init
    git add .
    git commit -m "Initial commit"
    gh repo create "${GITHUB_REPO##*/}" --public --description "Senlinlon - AI 编程助手" --source=. --push
    cd "$DIST_DIR"
    rm -rf "$TEMP_DIR"
    echo -e "${GREEN}✓ 仓库已创建${NC}"
fi
echo ""

# 步骤 5: 创建 Release
echo -e "${BLUE}[5/7] 创建 Release...${NC}"

# 准备 release notes
NOTES_FILE=$(mktemp)
cat > "$NOTES_FILE" << EOF
# 🎉 Senlinlon $VERSION

## ✨ 主要特性

- 🤖 智能代码补全和生成
- 🔍 代码理解和重构建议
- 🛠️ 多语言支持（TypeScript、Python、Java、Go 等）
- ⚡ 快速响应和高性能

## 📦 下载

请根据您的系统选择对应的文件：

| 平台 | 架构 | 文件 |
|------|------|------|
| macOS | Apple Silicon | \`senlinlon-darwin-arm64.tar.gz\` |
| macOS | Intel | \`senlinlon-darwin-x64.tar.gz\` |
| Linux | x64 | \`senlinlon-linux-x64.tar.gz\` |
| Linux | ARM64 | \`senlinlon-linux-arm64.tar.gz\` |
| Windows | x64 | \`senlinlon-windows-x64.zip\` |

> 💡 旧 CPU 请使用 \`baseline\` 版本，Alpine Linux 请使用 \`musl\` 版本。
EOF

# 检查是否已存在该版本
if gh release view "$VERSION" --repo "$GITHUB_REPO" &>/dev/null; then
    echo -e "${YELLOW}Release $VERSION 已存在，删除重建...${NC}"
    gh release delete "$VERSION" --repo "$GITHUB_REPO" --yes
fi

gh release create "$VERSION" \
    --repo "$GITHUB_REPO" \
    --title "Senlinlon $VERSION" \
    --notes-file "$NOTES_FILE" \
    --draft

rm "$NOTES_FILE"
echo -e "${GREEN}✓ Release 草稿已创建${NC}"
echo ""

# 步骤 6: 上传文件
echo -e "${BLUE}[6/7] 上传二进制文件...${NC}"
cd "$DIST_DIR"

# 获取所有文件
FILES=(*.tar.gz *.zip SHA256SUMS.txt)
TOTAL=${#FILES[@]}
CURRENT=0

for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        CURRENT=$((CURRENT + 1))
        echo "  上传 ($CURRENT/$TOTAL): $file"
        gh release upload "$VERSION" --repo "$GITHUB_REPO" --clobber "$file"
    fi
done

echo -e "${GREEN}✓ 所有文件已上传${NC}"
echo ""

# 步骤 7: 发布
echo -e "${BLUE}[7/7] 发布 Release...${NC}"
gh release edit "$VERSION" --repo "$GITHUB_REPO" --draft=false
echo -e "${GREEN}✓ Release 已发布${NC}"
echo ""

# 完成
echo -e "${BLUE}======================================${NC}"
echo -e "${GREEN}   🎉 发布完成！${NC}"
echo -e "${BLUE}======================================${NC}"
echo ""
echo -e "仓库: https://github.com/$GITHUB_REPO"
echo -e "Release: https://github.com/$GITHUB_REPO/releases/tag/$VERSION"
echo ""

# 验证
echo -e "${BLUE}验证下载链接...${NC}"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "https://github.com/$GITHUB_REPO/releases/download/$VERSION/senlinlon-darwin-arm64.tar.gz")
if [ "$HTTP_CODE" = "302" ]; then
    echo -e "${GREEN}✓ 下载链接正常 (HTTP $HTTP_CODE)${NC}"
else
    echo -e "${YELLOW}⚠ 下载链接返回 HTTP $HTTP_CODE，请手动检查${NC}"
fi

echo ""
echo -e "${GREEN}完成！${NC}"
