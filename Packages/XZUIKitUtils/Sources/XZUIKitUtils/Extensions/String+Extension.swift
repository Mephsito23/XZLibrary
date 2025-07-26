//
//  String+Extension.swift
//  TimeManager
//
//  Created by Mephisto on 2021/3/18.
//  Copyright © 2021 Mephisto. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func getClass() -> AnyClass? {
        guard let spaceName = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            print("获取命名空间失败")
            return nil
        }
        let cellClass: AnyClass? = NSClassFromString("\(spaceName).\(self)")
        return cellClass
    }

    func findSubStr(str: String) -> NSRange? {
        if let range = self.range(of: str) {
            let location = distance(from: startIndex, to: range.lowerBound)
            let keyLength: Int = distance(from: range.lowerBound, to: range.upperBound)
            return NSRange(location: location, length: keyLength)
        }
        return nil
    }

    func removeWhitespacesAndNewlines() -> String {
        self
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: " ", with: "")
    }
}

// swiftformat:disable redundantSelf
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont, lineHeight: CGFloat = 0) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)

        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineHeight

        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: style],
            context: nil
        )

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil
        )

        return ceil(boundingBox.width)
    }
}

extension String {

    func date(withFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }

    func formatter(integer: Int, decimal: Int) -> String {
        // 允许数字和小数点
        let filteredText = self.filter { "0123456789.".contains($0) }
        // 验证格式: 最多7位整数 + 可选的小数点 + 最多4位小数
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
    /// - Returns: 返回小数点个数
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

}
