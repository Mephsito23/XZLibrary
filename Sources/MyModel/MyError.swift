//
//  File.swift
//
//
//  Created by Mephisto on 2022/2/28.
//

import Foundation

public enum MyError: Error {
    case errorDesc(String?)
    case netEerrorData(Data, Int)
    case fileError
    case networkingFailed(Error)
}

extension MyError: LocalizedError {
    public var myLocalizedDescription: String {
        switch self {
        case let .errorDesc(desc):
            return desc ?? ""
        case let .netEerrorData(data, code):
            return "httpResponseCode=>\(code)\n" + (String(data: data, encoding: .utf8) ?? "network business error")
        case .fileError:
            return "file Error"
        case let .networkingFailed(error):
            return error.localizedDescription
        }
    }
}
