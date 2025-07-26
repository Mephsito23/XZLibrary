//
//  String+Core.swift
//  XZCore
//
//  Created by XZLibrary on 2025/1/26.
//

#if canImport(Foundation)
import Foundation

public extension String {
    /// 移除字符串中的空格和换行符
    func removeWhitespacesAndNewlines() -> String {
        self
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: " ", with: "")
    }
    
    /// 根据指定格式创建Date对象
    func date(withFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
    
    /// 格式化数字字符串（整数位和小数位限制）
    func formatter(integer: Int, decimal: Int) -> String {
        // 允许数字和小数点
        let filteredText = self.filter { "0123456789.".contains($0) }
        // 验证格式: 最多指定位整数 + 可选的小数点 + 最多指定位小数
        let pattern = "^\\d{0,\(integer)}(\\.\\d{0,\(decimal)})?$"
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: filteredText.utf16.count)
        if regex.firstMatch(in: filteredText, range: range) != nil {
            if !filteredText.isEmpty, filteredText.replacingOccurrences(of: "0", with: "").isEmpty {
                return "0"
            }
            return filteredText
        } else {
            // 尝试修正格式
            let components = filteredText.components(separatedBy: ".")
            let integerPart = String(components[0].prefix(integer))
            let hasDecimal = components.count > 1

            var decimalPart = ""
            if hasDecimal {
                decimalPart = String((components.count > 1 ? components[1] : "").prefix(decimal))
            }

            let newText = hasDecimal ? "\(integerPart).\(decimalPart)" : integerPart
            return newText
        }
    }
    
    /// 获取数字字符串小数点位数
    func getDecimalPlacesByString() -> Int {
        // 查找小数点的位置
        if let decimalPointIndex = self.firstIndex(of: ".") {
            let fractionPart = self[self.index(after: decimalPointIndex)...]
            // 过滤掉小数点后尾部的零 (如果有的话)
            let trimmedFractionPart = fractionPart.reversed().drop(while: { $0 == "0" }).reversed()
            return trimmedFractionPart.count
        }
        return 0  // 整数没有小数位
    }
    
    /// 在字符串中查找子字符串的NSRange
    func findSubStr(str: String) -> NSRange? {
        if let range = self.range(of: str) {
            let location = distance(from: startIndex, to: range.lowerBound)
            let keyLength: Int = distance(from: range.lowerBound, to: range.upperBound)
            return NSRange(location: location, length: keyLength)
        }
        return nil
    }
    
    /// 转换为Double
    func double() -> Double? {
        return Double(self)
    }
    
    /// 格式化为货币显示
    func money(_ digits: Int = 4) -> String {
        return self.double()?.money(digits) ?? self
    }
}

// MARK: - Double Extension for Money Formatting
extension Double {
    /// 格式化为货币显示
    func money(_ digits: Int = 4) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = digits
        formatter.minimumFractionDigits = 0
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

#endif