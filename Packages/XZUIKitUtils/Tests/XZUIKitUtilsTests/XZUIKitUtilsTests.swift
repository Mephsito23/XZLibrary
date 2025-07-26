//
//  XZUIKitUtilsTests.swift
//  XZUIKitUtils
//
//  Created by XZLibrary on 2025/1/26.
//

import XCTest
@testable import XZUIKitUtils

final class XZUIKitUtilsTests: XCTestCase {
    
    func testPlaceholder() {
        #if canImport(UIKit) && (os(iOS) || os(tvOS))
        XCTAssertEqual(XZUIKitUtils.version, "1.0.0")
        #else
        XCTAssertTrue(true) // 占位测试
        #endif
    }
}