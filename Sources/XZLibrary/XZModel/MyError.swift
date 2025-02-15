//
//  File.swift
//
//
//  Created by Mephisto on 2022/2/28.
//

import Foundation

public enum MyError: Error, Equatable {
    public static func == (lhs: MyError, rhs: MyError) -> Bool {
        lhs.id == rhs.id
    }

    var id: UUID { UUID() }
    case errorDesc(String?)
    case netEerrorData(Data, Int)
    case fileError
    case networkingFailed(Error)
    case decodableError(Data)
}

extension MyError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .errorDesc(desc):
            return desc ?? ""
        case let .netEerrorData(data, code):
            return "httpResponseCode=>\(code)\n"
                + (String(data: data, encoding: .utf8)
                    ?? "network business error")
        case .fileError:
            return "file Error"
        case let .networkingFailed(error):
            return error.localizedDescription
        case let .decodableError(data):
            let str = String(data: data, encoding: .utf8)
            return "decodable Error, original data is:\(str)"
        }
    }
}
