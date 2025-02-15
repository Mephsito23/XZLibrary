//
//  File.swift
//
//
//  Created by Mephisto on 2023/5/17.
//

import Foundation

public extension Decodable {
    init(data: Data, using decoder: JSONDecoder = .init()) throws {
        guard let parsed = try? decoder.decode(Self.self, from: data) else {
            throw MyError.decodableError(data)
        }
        self = parsed
    }
}
