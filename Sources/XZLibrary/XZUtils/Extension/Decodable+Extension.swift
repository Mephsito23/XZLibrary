//
//  File.swift
//
//
//  Created by Mephisto on 2023/5/17.
//

import Foundation

public extension Decodable {
    init(data: Data, using decoder: JSONDecoder = .init()) throws {
        do {
            self = try decoder.decode(Self.self, from: data)
        } catch let DecodingError.dataCorrupted(context) {
            print("数据损坏:", context)
            throw XZError.decodableError(data, context.debugDescription)
        } catch let DecodingError.keyNotFound(key, context) {
            print("找不到键:", key.stringValue, "上下文:", context.debugDescription)
            throw XZError.decodableError(data, "Missing key: \(key.stringValue)")
        } catch let DecodingError.typeMismatch(type, context) {
            print("类型不匹配:", type, "上下文:", context.debugDescription)
            let path = context.codingPath.map { $0.stringValue }.joined(separator: ".")
            throw XZError.decodableError(data, "Type mismatch for \(path): expected \(type)")
        } catch let DecodingError.valueNotFound(type, context) {
            print("值找不到:", type, "上下文:", context.debugDescription)
            let path = context.codingPath.map { $0.stringValue }.joined(separator: ".")
            throw XZError.decodableError(data, "Value not found for \(path): expected \(type)")
        } catch {
            print("其他错误:", error.localizedDescription)
            throw XZError.decodableError(data, error.localizedDescription)
        }
    }
}
