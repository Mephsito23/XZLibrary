//
//  Array+Core.swift
//  XZCore
//
//  Created by XZLibrary on 2025/1/26.
//

#if canImport(Foundation)
import Foundation

#if canImport(Combine)
import Combine
#endif

extension Array where Element: Identifiable {
    /// 替换数组中具有相同ID的元素
    public mutating func replace(_ item: Element) -> [Element] {
        return map { $0.id == item.id ? item : $0 }
    }
}

extension Array where Element: Encodable {
    /// 将数组编码为JSON字符串
    public func toJsonString(prettyPrinted: Bool = false) -> String? {
        let encoder = JSONEncoder()
        if prettyPrinted {
            encoder.outputFormatting = .prettyPrinted
        }

        do {
            let data = try encoder.encode(self)
            return String(data: data, encoding: .utf8)
        } catch {
            print("JSON 编码失败: \(error)")
            return nil
        }
    }
}

#if canImport(Combine)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Array where Element: Publisher {
    /// 将多个Publisher合并为一个，发出所有结果的数组
    public var zipAll: AnyPublisher<[Element.Output], Element.Failure> {
        let initial = Just([Element.Output]())
            .setFailureType(to: Element.Failure.self)
            .eraseToAnyPublisher()
        return reduce(initial) { result, publisher in
            result.zip(publisher) { $0 + [$1] }.eraseToAnyPublisher()
        }
    }
}
#endif

#endif