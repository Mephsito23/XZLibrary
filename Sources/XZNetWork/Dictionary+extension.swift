//
//  File.swift
//
//
//  Created by Mephisto on 2024/9/1.
//

#if canImport(Foundation)
import Foundation

public extension Dictionary {
    /// SwifterSwift: JSON Data from dictionary.
    ///
    /// - Parameter prettify: set true to prettify data (default is false).
    /// - Returns: optional JSON Data (if applicable).
    func jsonData(prettify: Bool = false) -> Data? {
        guard JSONSerialization.isValidJSONObject(self) else {
            return nil
        }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization
            .WritingOptions()
        return try? JSONSerialization.data(withJSONObject: self, options: options)
    }
}
#endif
