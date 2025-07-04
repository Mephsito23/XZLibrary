//
//  Calendar+Extension.swift
//  QizAIFramework
//
//  Created by Mephisto on 2025/6/3.
//

import Foundation

extension Calendar {
    static var main: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        // not working
        calendar.firstWeekday = 2
        return calendar
    }
}
