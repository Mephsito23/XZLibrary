//
//  ArrayExtension.swift
//  Reader
//
//  Created by mac on 2021/4/19.
//

import Combine
import Foundation

extension Array where Element: Identifiable {
    mutating func replace(_ item: Element) -> [Element] {
        return map { $0.id == item.id ? item : $0 }
    }
}

//extension Array {
//    var jsonString: String? {
//        guard JSONSerialization.isValidJSONObject(self) else {
//            return nil
//        }
//
//        if let data = try? JSONSerialization.data(withJSONObject: self, options: []) {
//            return String(data: data, encoding: .utf8)
//        }
//        return nil
//    }
//
//}

extension Array where Element: Encodable {
    func toJsonString(prettyPrinted: Bool = false) -> String? {
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

extension Array where Element: Publisher {
    var zipAll: AnyPublisher<[Element.Output], Element.Failure> {
        let initial = Just([Element.Output]())
            .setFailureType(to: Element.Failure.self)
            .eraseToAnyPublisher()
        return reduce(initial) { result, publisher in
            result.zip(publisher) { $0 + [$1] }.eraseToAnyPublisher()
        }
    }
}
