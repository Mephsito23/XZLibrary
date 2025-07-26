//
//  XZCoreTests.swift
//  XZCore
//
//  Created by XZLibrary on 2025/1/26.
//

import XCTest
@testable import XZCore

final class XZCoreTests: XCTestCase {
    
    func testXZErrorTypes() {
        let error1 = XZError.errorDesc("Test error")
        let error2 = XZError.fileError
        let error3 = XZError.networkingFailed(NSError(domain: "test", code: 0))
        
        XCTAssertNotNil(error1.errorDescription)
        XCTAssertNotNil(error2.errorDescription)
        XCTAssertNotNil(error3.errorDescription)
    }
    
    func testMyMethod() {
        XCTAssertEqual(MyMethod.GET.string(), "GET")
        XCTAssertEqual(MyMethod.POST.string(), "POST")
        XCTAssertEqual(MyMethod.PUT.string(), "PUT")
        XCTAssertEqual(MyMethod.DELETE.string(), "DELETE")
    }
    
    func testArrayExtensions() {
        struct TestItem: Identifiable {
            let id: Int
            let name: String
        }
        
        var items = [
            TestItem(id: 1, name: "Item 1"),
            TestItem(id: 2, name: "Item 2")
        ]
        
        let updatedItem = TestItem(id: 1, name: "Updated Item 1")
        let result = items.replace(updatedItem)
        
        XCTAssertEqual(result.first?.name, "Updated Item 1")
    }
    
    func testStringExtensions() {
        let testString = "  Hello World  \n"
        let cleaned = testString.removeWhitespacesAndNewlines()
        XCTAssertEqual(cleaned, "HelloWorld")
        
        let numberString = "123.456"
        let formatted = numberString.formatter(integer: 3, decimal: 2)
        XCTAssertEqual(formatted, "123.45")
    }
    
    func testIntExtensions() {
        XCTAssertTrue(4.isEven)
        XCTAssertTrue(3.isOdd)
        XCTAssertTrue(5.isPositive)
        XCTAssertTrue((-3).isNegative)
        
        let clamped = 10.clamped(to: 0...5)
        XCTAssertEqual(clamped, 5)
    }
    
    func testDateExtensions() {
        let date = Date()
        XCTAssertGreaterThan(date.year, 2020)
        XCTAssertGreaterThan(date.month, 0)
        XCTAssertLessThanOrEqual(date.month, 12)
    }
    
    func testDictionaryExtensions() {
        let dict = ["key1": "value1", "key2": "value2"]
        XCTAssertTrue(dict.has(key: "key1"))
        XCTAssertFalse(dict.has(key: "key3"))
        
        let jsonString = dict.jsonString()
        XCTAssertNotNil(jsonString)
    }
}