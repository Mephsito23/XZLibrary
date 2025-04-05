//
//  String+Extension.swift
//  TimeManager
//
//  Created by Mephisto on 2021/3/18.
//  Copyright © 2021 Mephisto. All rights reserved.
//

import Foundation
import UIKit

public extension String {
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
public extension String {
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
