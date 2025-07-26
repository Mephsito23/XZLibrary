# XZLibrary - iOS 跨平台Swift工具库集合

[![Swift 5.9+](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![iOS 15.0+](https://img.shields.io/badge/iOS-15.0+-blue.svg)](https://developer.apple.com/ios/)
[![macOS 12.0+](https://img.shields.io/badge/macOS-12.0+-blue.svg)](https://developer.apple.com/macos/)
[![watchOS 8.0+](https://img.shields.io/badge/watchOS-8.0+-blue.svg)](https://developer.apple.com/watchos/)
[![tvOS 15.0+](https://img.shields.io/badge/tvOS-15.0+-blue.svg)](https://developer.apple.com/tvos/)

XZLibrary是一个模块化的Swift工具库集合，采用Monorepo架构管理，为iOS、macOS、watchOS和tvOS开发提供全面的跨平台解决方案。

## 🏗️ 架构概览

本项目采用**Monorepo**架构，将功能相关的代码组织成独立的Swift Package模块：

```
XZLibrary/
├── Packages/                     # 所有Swift包
│   ├── XZCore/                  # 核心包 - 基础功能
│   ├── XZNetworking/            # 网络包 - HTTP请求和SSE
│   ├── XZUIKitUtils/            # iOS UI工具包 - UIKit扩展
│   └── XZUIComponents/          # UI组件包 - 自定义组件
├── .github/                     # CI/CD配置
│   └── workflows/
├── Scripts/                     # 构建和测试脚本
└── README.md                    # 本文件
```

## 📦 包说明

### 🔧 XZCore (核心包)
**平台支持**: iOS 15+, macOS 12+, watchOS 8+, tvOS 15+  
**依赖**: 无

**包含功能**:
- 错误处理 (`XZError`)
- 基础枚举 (`MyMethod`, `ParameterEncoding`)
- Foundation扩展 (Array, String, Date, Dictionary等)
- CoreGraphics扩展 (CGFloat, 数值类型等)

```swift
import XZCore
```

### 🌐 XZNetworking (网络包)
**平台支持**: iOS 15+, macOS 12+, watchOS 8+, tvOS 15+  
**依赖**: XZCore

**包含功能**:
- `APIProtocol`: 统一API协议定义
- `RequestManager`: 基于Combine的网络请求管理器
- `SSEClient`: Server-Sent Events客户端
- `NWPathMonitor+Combine`: 网络状态监控

```swift
import XZNetworking
```

### 📱 XZUIKitUtils (iOS UI工具包)
**平台支持**: iOS 15+, tvOS 15+  
**依赖**: XZCore, XZFoundationUtils

**包含功能**:
- UIKit扩展 (UIView, UIButton, UIScrollView等)
- 设备检测和系统工具
- iOS特定的UI辅助工具

```swift
import XZUIKitUtils
```

### 🎨 XZUIComponents (UI组件包)
**平台支持**: iOS 15+, tvOS 15+  
**依赖**: XZCore, XZUIKitUtils

**包含功能**:
- `XZProgressHUD`: 进度指示器组件
- `XZUIButton`: 自定义按钮组件
- `XZUILabel`: 自定义标签组件
- `XZFPSLabel`: FPS显示组件

```swift
import XZUIComponents
```

## 🚀 快速开始

### 在Package.swift中使用

```swift
// Package.swift
let package = Package(
    name: "YourProject",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    dependencies: [
        .package(path: "path/to/XZLibrary/Packages/XZCore"),
        .package(path: "path/to/XZLibrary/Packages/XZNetworking"),
        .package(path: "path/to/XZLibrary/Packages/XZUIKitUtils")
    ],
    targets: [
        .target(
            name: "YourTarget",
            dependencies: [
                "XZCore",
                "XZNetworking", 
                "XZUIKitUtils"
            ]
        )
    ]
)
```

### 在Xcode项目中使用

1. File → Add Package Dependencies
2. 输入包路径: `path/to/XZLibrary/Packages/XZCore`
3. 选择所需的包
4. 在代码中导入使用

## 🔗 依赖关系图

```
XZCore (基础包)
├── XZNetworking (网络)
├── XZUIKitUtils (iOS UI工具)
│   └── XZUIComponents (UI组件)
```

## 🧪 构建和测试

### 单包构建和测试

```bash
# 构建核心包
cd Packages/XZCore && swift build

# 测试核心包
cd Packages/XZCore && swift test

# 构建网络包
cd Packages/XZNetworking && swift build && swift test

```

### 批量构建脚本

```bash
# 构建所有包
./Scripts/build-all.sh

# 测试所有包
./Scripts/test-all.sh
```

## 📋 开发状态

- ✅ **XZCore**: 完成迁移和测试
- ✅ **XZNetworking**: 完成迁移和测试  
-  **XZUIKitUtils**: 结构已创建，待迁移代码
- 🔄 **XZUIComponents**: 结构已创建，待迁移代码

## 🤝 贡献指南

1. Fork本仓库
2. 创建feature分支: `git checkout -b feature/your-feature`
3. 提交更改: `git commit -am 'Add some feature'`
4. 推送分支: `git push origin feature/your-feature`
5. 提交Pull Request

## 📄 许可证

本项目采用MIT许可证 - 查看 [LICENSE](LICENSE) 文件了解详情

## 📞 支持

如有问题或建议，请通过以下方式联系：

- 创建 [Issue](../../issues)
- 提交 [Pull Request](../../pulls)

---

**XZLibrary** - 让跨平台Swift开发更简单 🚀
