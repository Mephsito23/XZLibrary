//
//  Dictionary+Core.swift
//  XZCore
//
//  Created by XZLibrary on 2025/1/26.
//

#if canImport(Foundation)
import Foundation

// MARK: - Methods

public extension Dictionary {
    /// Creates a Dictionary from a given sequence grouped by a given key path.
    init<S: Sequence>(grouping sequence: S, by keyPath: KeyPath<S.Element, Key>) where Value == [S.Element] {
        self.init(grouping: sequence, by: { $0[keyPath: keyPath] })
    }
    
    /// Check if key exists in dictionary.
    func has(key: Key) -> Bool {
        return index(forKey: key) != nil
    }
    
    /// Remove all keys contained in the keys parameter from the dictionary.
    mutating func removeAll(keys: some Sequence<Key>) {
        keys.forEach { removeValue(forKey: $0) }
    }
    
    /// Remove a value for a random key from the dictionary.
    @discardableResult
    mutating func removeValueForRandomKey() -> Value? {
        guard let randomKey = keys.randomElement() else { return nil }
        return removeValue(forKey: randomKey)
    }
    
    /// JSON String from dictionary.
    func jsonString(prettify: Bool = false) -> String? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        let options = prettify ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
    
    /// Returns a dictionary containing the results of mapping the given closure over the sequence's elements.
    func mapKeysAndValues<K, V>(_ transform: ((key: Key, value: Value)) throws -> (K, V)) rethrows -> [K: V] {
        return try [K: V](uniqueKeysWithValues: map(transform))
    }
    
    /// Returns a dictionary containing the non-nil results of calling the given transformation.
    func compactMapKeysAndValues<K, V>(_ transform: ((key: Key, value: Value)) throws -> (K, V)?) rethrows -> [K: V] {
        return try [K: V](uniqueKeysWithValues: compactMap(transform))
    }
}

#endif