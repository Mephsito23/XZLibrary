//
//  XZUIComponentsTests.swift
//  XZUIComponents
//
//  Created by XZLibrary on 2025/1/26.
//

import XCTest
@testable import XZUIComponents

final class XZUIComponentsTests: XCTestCase {
    
    func testPlaceholder() {
        #if canImport(UIKit) && (os(iOS) || os(tvOS))
        XCTAssertEqual(XZUIComponents.version, "1.0.0")
        #else
        XCTAssertTrue(true) // 占位测试
        #endif
    }
}