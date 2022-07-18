//
//  File.swift
//
//
//  Created by Mephisto on 2022/2/28.
//

import Foundation
import MyModel

public protocol APIProtocol {
    var baseURL: URL { get }

    var path: String { get }

    var method: MyMethod { get }

    var parameterEncoding: ParameterEncoding { get }

    var parameters: [String: Any]? { get }

    var requiresAnyToken: Bool { get }

    var headers: [String: String]? { get }
}
