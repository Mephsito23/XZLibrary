//
//  File.swift
//
//
//  Created by Mephisto on 2022/2/28.
//

import Foundation

public enum XZError: Error, Equatable {
    public static func == (lhs: XZError, rhs: XZError) -> Bool {
        lhs.id == rhs.id
    }

    var id: UUID { UUID() }
    case errorDesc(String?)
    case netEerrorData(Data, Int)
    case fileError
    case networkingFailed(Error)
    case decodableError(Data, String)
}

extension XZError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .errorDesc(desc):
            return desc ?? ""
        case let .netEerrorData(data, code):
            return String(data: data, encoding: .utf8)
        //            return "httpResponseCode=>\(code)\n"
        //                + (String(data: data, encoding: .utf8)
        //                    ?? "network business error")
        case .fileError:
            return "file Error"
        case let .networkingFailed(error):
            return error.localizedDescription
        case .decodableError(let data, let desc):
//            let str = String(data: data, encoding: .utf8)
            return desc
        }
    }
}
