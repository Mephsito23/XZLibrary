//
//  File.swift
//
//
//  Created by Mephisto on 2022/2/28.
//

import Foundation

public enum MyMethod {
    case GET, POST, PUT, DELETE

    public func string() -> String {
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

public enum ParameterEncoding {
    case URLEncoding, JSONEncoding, FileEncoding
}
