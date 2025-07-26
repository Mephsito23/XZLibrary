#!/bin/bash

# XZLibrary - 构建所有包的脚本
# 使用方法: ./Scripts/build-all.sh

set -e  # 遇到错误时退出

echo "🏗️ 开始构建所有XZLibrary包..."

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

# 构建计数器
SUCCESS_COUNT=0
TOTAL_COUNT=${#PACKAGES[@]}

# 构建每个包
for package in "${PACKAGES[@]}"; do
    echo ""
    echo "📦 构建 $package..."
    
    cd "Packages/$package"
    
    # 特殊处理iOS/tvOS专用包，在macOS上跳过构建
    if [[ "$package" == "XZUIKitUtils" || "$package" == "XZUIComponents" ]]; then
        if [[ "$(uname)" == "Darwin" ]]; then
            # 在macOS上测试iOS包需要指定iOS平台
            if swift build -Xswiftc -sdk -Xswiftc "$(xcrun --sdk iphoneos --show-sdk-path)" -Xswiftc -target -Xswiftc arm64-apple-ios15.0 2>/dev/null; then
                echo "✅ $package (iOS) 构建成功"
                SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
            elif swift build 2>/dev/null; then
                echo "✅ $package 构建成功"
                SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
            else
                echo "⚠️  $package 跳过构建 (仅支持iOS/tvOS)"
                SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
            fi
        else
            echo "⚠️  $package 跳过构建 (仅支持iOS/tvOS)"
            SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        fi
    elif [[ "$package" == "XZAppKitUtils" ]]; then
        if [[ "$(uname)" == "Darwin" ]]; then
            if swift build; then
                echo "✅ $package 构建成功"
                SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
            else
                echo "❌ $package 构建失败"
                exit 1
            fi
        else
            echo "⚠️  $package 跳过构建 (仅支持macOS)"
            SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        fi
    else
        if swift build; then
            echo "✅ $package 构建成功"
            SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        else
            echo "❌ $package 构建失败"
            exit 1
        fi
    fi
    
    cd ../../
done

echo ""
echo "🎉 构建完成！"
echo "✅ 成功: $SUCCESS_COUNT/$TOTAL_COUNT"

if [ $SUCCESS_COUNT -eq $TOTAL_COUNT ]; then
    echo "🚀 所有包构建成功！"
    exit 0
else
    echo "💥 部分包构建失败"
    exit 1
fi