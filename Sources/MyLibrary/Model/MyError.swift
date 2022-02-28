//
//  File.swift
//
//
//  Created by Mephisto on 2022/2/28.
//

import Foundation

enum MyError: Error {
    case errorDesc(String?)
    case netEerrorData(Data)
    case fileError
}

extension MyError: LocalizedError {
    var localizedDescription: String {
        if case let .errorDesc(desc) = self, let message = desc {
            return message
        }
        return ""
    }
}
