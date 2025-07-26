#!/bin/bash

# XZLibrary - 测试所有包的脚本
# 使用方法: ./Scripts/test-all.sh

set -e  # 遇到错误时退出

echo "🧪 开始测试所有XZLibrary包..."

# 定义包列表（按依赖顺序）
PACKAGES=(
    "XZCore"
    "XZNetworking"
    "XZFileUtils"
    "XZFoundationUtils"
    "XZUIKitUtils"
    "XZAppKitUtils"
    "XZUIComponents"
)

# 测试计数器
SUCCESS_COUNT=0
TOTAL_COUNT=${#PACKAGES[@]}

# 测试每个包
for package in "${PACKAGES[@]}"; do
    echo ""
    echo "🔍 测试 $package..."
    
    cd "Packages/$package"
    
    if swift test; then
        echo "✅ $package 测试通过"
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    else
        echo "❌ $package 测试失败"
        exit 1
    fi
    
    cd ../../
done

echo ""
echo "🎊 测试完成！"
echo "✅ 通过: $SUCCESS_COUNT/$TOTAL_COUNT"

if [ $SUCCESS_COUNT -eq $TOTAL_COUNT ]; then
    echo "🚀 所有包测试通过！"
    exit 0
else
    echo "💥 部分包测试失败"
    exit 1
fi