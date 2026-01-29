#!/bin/bash

# Senlinlon 快速安装脚本
# 用法: ./install-local.sh

set -e

echo "🚀 Senlinlon 本地安装脚本"
echo "=========================="

# 检测平台
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "$ARCH" in
    x86_64) ARCH="x64" ;;
    aarch64) ARCH="arm64" ;;
    arm64) ARCH="arm64" ;;
esac

PLATFORM="${OS}-${ARCH}"
BINARY_DIR="packages/opencode/dist/senlinlon-${PLATFORM}/bin"
BINARY_PATH="$PWD/$BINARY_DIR/senlinlon"

echo "检测到平台: $PLATFORM"

# 检查二进制文件是否存在
if [ ! -f "$BINARY_PATH" ]; then
    echo "❌ 错误: 未找到构建的二进制文件"
    echo "   路径: $BINARY_PATH"
    echo ""
    echo "请先构建:"
    echo "  cd packages/opencode"
    echo "  bun run build --single"
    exit 1
fi

echo "✓ 找到二进制文件: $BINARY_PATH"

# 选择安装方式
echo ""
echo "选择安装方式:"
echo "1) 安装到 ~/.bun/bin (推荐，不需要 sudo)"
echo "2) 安装到 /usr/local/bin (需要 sudo)"
echo "3) 仅显示路径，不安装"
read -p "请选择 [1-3]: " choice

case "$choice" in
    1)
        TARGET="$HOME/.bun/bin/senlinlon"
        mkdir -p "$HOME/.bun/bin"
        ln -sf "$BINARY_PATH" "$TARGET"
        echo "✓ 已创建符号链接: $TARGET"
        
        # 检查 PATH
        if [[ ":$PATH:" != *":$HOME/.bun/bin:"* ]]; then
            echo ""
            echo "⚠️  警告: ~/.bun/bin 不在你的 PATH 中"
            echo "   添加以下行到你的 ~/.zshrc 或 ~/.bashrc:"
            echo "   export PATH=\"\$HOME/.bun/bin:\$PATH\""
        fi
        ;;
    2)
        TARGET="/usr/local/bin/senlinlon"
        echo "需要 sudo 权限..."
        sudo ln -sf "$BINARY_PATH" "$TARGET"
        echo "✓ 已创建符号链接: $TARGET"
        ;;
    3)
        echo ""
        echo "二进制文件路径:"
        echo "  $BINARY_PATH"
        echo ""
        echo "手动创建符号链接:"
        echo "  ln -sf \"$BINARY_PATH\" ~/.bun/bin/senlinlon"
        exit 0
        ;;
    *)
        echo "无效选择"
        exit 1
        ;;
esac

echo ""
echo "✅ 安装完成！"
echo ""

# 验证安装
if command -v senlinlon &> /dev/null; then
    VERSION=$(senlinlon --version 2>&1)
    echo "✓ senlinlon 可用:"
    echo "  版本: $VERSION"
    echo "  路径: $(which senlinlon)"
else
    echo "⚠️  警告: senlinlon 命令未在 PATH 中找到"
    echo "   可能需要重新加载 shell 配置:"
    echo "   source ~/.zshrc  # 或 source ~/.bashrc"
fi

echo ""
echo "快速测试:"
echo "  senlinlon --version"
echo "  senlinlon --help"
