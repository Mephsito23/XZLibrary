//
//  XZAppKitUtilsTests.swift
//  XZAppKitUtils
//
//  Created by XZLibrary on 2025/1/26.
//

import XCTest
@testable import XZAppKitUtils

final class XZAppKitUtilsTests: XCTestCase {
    
    func testPlaceholder() {
        #if canImport(AppKit) && os(macOS)
        XCTAssertEqual(XZAppKitUtils.version, "1.0.0")
        #else
        XCTAssertTrue(true) // 占位测试
        #endif
    }
}