//
//  XZNetworkingTests.swift
//  XZNetworking
//
//  Created by XZLibrary on 2025/1/26.
//

import XCTest
import XZCore
@testable import XZNetworking

final class XZNetworkingTests: XCTestCase {
    
    func testAPIProtocol() {
        // 测试基本的API协议功能
        XCTAssertNotNil(MyMethod.GET)
        XCTAssertEqual(MyMethod.GET.string(), "GET")
        
        XCTAssertNotNil(ParameterEncoding.JSONEncoding)
        XCTAssertNotNil(ParameterEncoding.URLEncoding)
        XCTAssertNotNil(ParameterEncoding.FileEncoding)
    }
    
    func testRequestManagerInit() {
        // 测试RequestManager可以正常初始化
        struct TestAPI: APIProtocol {
            var baseURL: URL { URL(string: "https://api.example.com")! }
            var path: String { "/test" }
            var method: MyMethod { .GET }
            var parameterEncoding: ParameterEncoding { .JSONEncoding }
            var parameters: [String: Any]? { nil }
            var requiresAnyToken: Bool { false }
            var headers: [String: String]? { nil }
        }
        
        let manager = RequestManager<TestAPI>()
        XCTAssertNotNil(manager)
    }
    
    func testSSEClientInit() {
        let url = URL(string: "https://example.com/events")!
        let request = URLRequest(url: url)
        let client = SSEClient(request: request)
        XCTAssertNotNil(client)
    }
}