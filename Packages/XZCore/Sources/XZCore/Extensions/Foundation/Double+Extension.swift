//
//  Double+Extension.swift
//  QizAIFramework
//
//  Created by Mephisto on 2025/6/3.
//

#if canImport(CoreGraphics)
import CoreGraphics
#endif

#if os(macOS) || os(iOS)
import Darwin
#elseif canImport(Android)
import Android
#elseif os(Linux)
import Glibc
#endif
import Foundation

extension Double {

    func money(_ digits: Int = 4) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal  // 设置为十进制格式
        formatter.maximumFractionDigits = digits  // 设置最多两位小数
        formatter.minimumFractionDigits = digits  // 设置最少两位小数
        formatter.groupingSeparator = ","  // 设置数字分组分隔符为逗号
        formatter.locale = Locale(identifier: "en_US")  // 设置为美国英语的本地化设置，确保使用逗号和小数点的格式
        if let money = formatter.string(from: NSNumber(value: self)) {
            return money
        }
        return self.string
    }

    func formatter(digits: Int = 1) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0  // 最少 0 位小数（整数不显示 .0）
        formatter.maximumFractionDigits = digits  // 最多 1 位小数
        let formattedString = formatter.string(from: NSNumber(value: self)) ?? "\(self)"
        return formattedString
    }

}

// MARK: - Properties

public extension Double {
    /// SwifterSwift: Int.
    var int: Int {
        return Int(self)
    }

    /// SwifterSwift: Float.
    var float: Float {
        return Float(self)
    }

    #if canImport(CoreGraphics)
    /// SwifterSwift: CGFloat.
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
    #endif
}

// MARK: - Operators

precedencegroup PowerPrecedence {
    higherThan: MultiplicationPrecedence
}
infix operator ** : PowerPrecedence
/// SwifterSwift: Value of exponentiation.
///
/// - Parameters:
///   - lhs: base double.
///   - rhs: exponent double.
/// - Returns: exponentiation result (example: 4.4 ** 0.5 = 2.0976176963).
public func ** (lhs: Double, rhs: Double) -> Double {
    // http://nshipster.com/swift-operators/
    return pow(lhs, rhs)
}
