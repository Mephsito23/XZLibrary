//
//  File.swift
//
//
//  Created by Mephisto on 2022/2/28.
//

import Foundation

protocol APIProtocol {
    var baseURL: URL { get }

    var path: String { get }

    var method: Method { get }

    var parameterEncoding: ParameterEncoding { get }

    var parameters: [String: Any?]? { get }

    var requiresAnyToken: Bool { get }

    var headers: [String: String]? { get }
}

enum Method {
    case GET, POST, PUT, DELETE

    func string() -> String {
        switch self {
        case .GET:
            return "GET"
        case .POST:
            return "POST"
        case .DELETE:
            return "DELETE"
        case .PUT:
            return "PUT"
        }
    }
}

enum ParameterEncoding {
    case URLEncoding, JSONEncoding, FileEncoding
}
