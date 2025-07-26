//
//  Decodable+Core.swift
//  XZCore
//
//  Created by XZLibrary on 2025/1/26.
//

#if canImport(Foundation)
import Foundation

public extension Decodable {
    /// 从Data初始化Decodable对象，提供详细的错误信息
    init(data: Data, using decoder: JSONDecoder = .init()) throws {
        do {
            self = try decoder.decode(Self.self, from: data)
        } catch let DecodingError.dataCorrupted(context) {
            print("数据损坏:\(context.debugDescription)")
            throw XZError.decodableError(data, context.debugDescription)
        } catch let DecodingError.keyNotFound(key, context) {
            let keyPath = context.codingPath.map { $0.stringValue }.joined(separator: ".")
            print("找不到键: \(key.stringValue), 路径: \(keyPath), 上下文: \(context.debugDescription)")
            throw XZError.decodableError(data, "Missing key: \(key.stringValue) at path: \(keyPath)")
        } catch let DecodingError.typeMismatch(type, context) {
            let keyPath = context.codingPath.map { $0.stringValue }.joined(separator: ".")
            print("类型不匹配: \(type), 路径: \(keyPath), 上下文: \(context.debugDescription)")
            throw XZError.decodableError(data, "Type mismatch for \(keyPath): expected \(type)")
        } catch let DecodingError.valueNotFound(type, context) {
            let keyPath = context.codingPath.map { $0.stringValue }.joined(separator: ".")
            print("值找不到: \(type), 路径: \(keyPath), 上下文: \(context.debugDescription)")
            throw XZError.decodableError(data, "Value not found for \(keyPath): expected \(type)")
        } catch {
            print("其他错误: \(error.localizedDescription)")
            throw XZError.decodableError(data, error.localizedDescription)
        }
    }
}

#endif