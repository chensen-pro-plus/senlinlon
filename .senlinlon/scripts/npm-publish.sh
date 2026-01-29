#!/bin/bash
# Senlinlon npm 发布脚本
# 用法: ./npm-publish.sh [VERSION]
# 示例: ./npm-publish.sh 1.0.0

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 配置
PROJECT_ROOT="/Users/工作2/opencode工作区/opencode"
DIST_DIR="$PROJECT_ROOT/packages/opencode/dist"
NPM_PUBLISH_DIR="$PROJECT_ROOT/.senlinlon/npm-publish"
TEMP_DIR="/tmp/senlinlon-npm-publish"

# 版本号（不带 v 前缀）
VERSION="${1:-1.0.0}"

echo -e "${BLUE}======================================${NC}"
echo -e "${BLUE}   Senlinlon npm 发布工具${NC}"
echo -e "${BLUE}======================================${NC}"
echo ""
echo -e "${GREEN}版本号: $VERSION${NC}"
echo -e "${GREEN}主包名: senlinlon-cli${NC}"
echo ""

# 检查 npm 登录
echo -e "${BLUE}[1/5] 检查 npm 登录状态...${NC}"
if ! npm whoami &>/dev/null; then
    echo -e "${RED}错误: 请先运行 'npm login' 登录 npm${NC}"
    exit 1
fi
NPM_USER=$(npm whoami)
echo -e "${GREEN}✓ 已登录: $NPM_USER${NC}"
echo ""

# 检查构建文件
echo -e "${BLUE}[2/5] 检查构建文件...${NC}"
if [ ! -d "$DIST_DIR" ]; then
    echo -e "${RED}错误: 构建目录不存在，请先运行构建脚本${NC}"
    exit 1
fi
echo -e "${GREEN}✓ 构建目录存在${NC}"
echo ""

# 准备发布目录
echo -e "${BLUE}[3/5] 准备发布目录...${NC}"
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"

# 复制主包
echo "  复制主包 senlinlon-cli..."
cp -r "$NPM_PUBLISH_DIR/main" "$TEMP_DIR/senlinlon-cli"
chmod +x "$TEMP_DIR/senlinlon-cli/bin/senlinlon"

# 更新版本号
sed -i '' "s/\"version\": \".*\"/\"version\": \"$VERSION\"/" "$TEMP_DIR/senlinlon-cli/package.json"
# 更新 optionalDependencies 版本
sed -i '' "s/senlinlon-cli-\([^\"]*\)\": \"[^\"]*\"/senlinlon-cli-\1\": \"$VERSION\"/g" "$TEMP_DIR/senlinlon-cli/package.json"

# 准备各平台包
PLATFORMS=(
    "darwin-arm64:senlinlon-darwin-arm64"
    "darwin-x64:senlinlon-darwin-x64"
    "linux-arm64:senlinlon-linux-arm64"
    "linux-x64:senlinlon-linux-x64"
    "win32-x64:senlinlon-windows-x64"
)

for platform_info in "${PLATFORMS[@]}"; do
    IFS=':' read -r platform dist_name <<< "$platform_info"
    echo "  准备 senlinlon-cli-$platform..."
    
    pkg_dir="$TEMP_DIR/senlinlon-cli-$platform"
    mkdir -p "$pkg_dir/bin"
    
    # 复制 package.json
    cp "$NPM_PUBLISH_DIR/platforms/$platform/package.json" "$pkg_dir/"
    
    # 更新版本号
    sed -i '' "s/\"version\": \".*\"/\"version\": \"$VERSION\"/" "$pkg_dir/package.json"
    
    # 解压并复制二进制文件
    if [ -d "$DIST_DIR/$dist_name" ]; then
        cp -r "$DIST_DIR/$dist_name/bin/"* "$pkg_dir/bin/"
    elif [ -f "$DIST_DIR/$dist_name.tar.gz" ]; then
        tar -xzf "$DIST_DIR/$dist_name.tar.gz" -C "/tmp/"
        cp -r "/tmp/$dist_name/bin/"* "$pkg_dir/bin/"
    else
        echo -e "${YELLOW}  警告: 找不到 $dist_name 的构建文件${NC}"
        continue
    fi
    
    # 设置执行权限
    if [ "$platform" != "win32-x64" ]; then
        chmod +x "$pkg_dir/bin/"*
    fi
done

echo -e "${GREEN}✓ 发布目录准备完成${NC}"
echo ""

# 发布各平台包
echo -e "${BLUE}[4/5] 发布平台包到 npm...${NC}"
for platform_info in "${PLATFORMS[@]}"; do
    IFS=':' read -r platform dist_name <<< "$platform_info"
    pkg_dir="$TEMP_DIR/senlinlon-cli-$platform"
    
    if [ -d "$pkg_dir" ]; then
        echo "  发布 senlinlon-cli-$platform@$VERSION..."
        cd "$pkg_dir"
        npm publish --access public 2>&1 || echo -e "${YELLOW}  警告: 发布失败，可能已存在${NC}"
    fi
done
echo ""

# 发布主包
echo -e "${BLUE}[5/5] 发布主包到 npm...${NC}"
cd "$TEMP_DIR/senlinlon-cli"
npm publish --access public

echo ""
echo -e "${BLUE}======================================${NC}"
echo -e "${GREEN}   🎉 npm 发布完成！${NC}"
echo -e "${BLUE}======================================${NC}"
echo ""
echo -e "安装: ${GREEN}npm install -g senlinlon-cli${NC}"
echo -e "更新: ${GREEN}npm update -g senlinlon-cli${NC}"
echo -e "运行: ${GREEN}senlinlon --version${NC}"
echo ""

# 清理
rm -rf "$TEMP_DIR"
echo -e "${GREEN}✓ 临时文件已清理${NC}"
