//
//  ArrayExtension.swift
//  Reader
//
//  Created by mac on 2021/4/19.
//

import Combine
import Foundation

public extension Array where Element: Identifiable {
    mutating func replace(_ item: Element) -> [Element] {
        return map { $0.id == item.id ? item : $0 }
    }
}

public extension Array {
    var jsonString: String? {
        guard JSONSerialization.isValidJSONObject(self) else {
            return nil
        }

        if let data = try? JSONSerialization.data(withJSONObject: self, options: []) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}

public extension Array where Element: Publisher {
    var zipAll: AnyPublisher<[Element.Output], Element.Failure> {
        let initial = Just([Element.Output]())
            .setFailureType(to: Element.Failure.self)
            .eraseToAnyPublisher()
        return reduce(initial) { result, publisher in
            result.zip(publisher) { $0 + [$1] }.eraseToAnyPublisher()
        }
    }
}
