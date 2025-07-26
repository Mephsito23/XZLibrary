//
//  Date+Core.swift
//  XZCore
//
//  Created by XZLibrary on 2025/1/26.
//

#if canImport(Foundation)
import Foundation

#if os(macOS) || os(iOS)
import Darwin
#elseif canImport(Android)
import Android
#elseif os(Linux)
import Glibc
#endif

// MARK: - Enums

public extension Date {
    /// Day name format.
    enum DayNameStyle {
        /// 3 letter day abbreviation of day name.
        case threeLetters
        
        /// 1 letter day abbreviation of day name.
        case oneLetter
        
        /// Full day name.
        case full
    }
    
    /// Month name format.
    enum MonthNameStyle {
        /// 3 letter month abbreviation of month name.
        case threeLetters
        
        /// 1 letter month abbreviation of month name.
        case oneLetter
        
        /// Full month name.
        case full
    }
}

// MARK: - Properties

public extension Date {
    /// User's current calendar.
    var calendar: Calendar { Calendar.current }
    
    /// Era.
    var era: Int {
        return calendar.component(.era, from: self)
    }
    
    #if !os(Linux) && !os(Android)
    /// Quarter.
    var quarter: Int {
        let month = Double(calendar.component(.month, from: self))
        let numberOfMonths = Double(calendar.monthSymbols.count)
        let numberOfMonthsInQuarter = numberOfMonths / 4
        return Int(ceil(month / numberOfMonthsInQuarter))
    }
    #endif
    
    /// Week of year.
    var weekOfYear: Int {
        return calendar.component(.weekOfYear, from: self)
    }
    
    /// Week of month.
    var weekOfMonth: Int {
        return calendar.component(.weekOfMonth, from: self)
    }
    
    /// Year.
    var year: Int {
        get {
            return calendar.component(.year, from: self)
        }
        set {
            guard newValue > 0 else { return }
            let currentYear = calendar.component(.year, from: self)
            let yearsToAdd = newValue - currentYear
            if let date = calendar.date(byAdding: .year, value: yearsToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// Month.
    var month: Int {
        get {
            return calendar.component(.month, from: self)
        }
        set {
            let allowedRange = calendar.range(of: .month, in: .year, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentMonth = calendar.component(.month, from: self)
            let monthsToAdd = newValue - currentMonth
            if let date = calendar.date(byAdding: .month, value: monthsToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// Day.
    var day: Int {
        get {
            return calendar.component(.day, from: self)
        }
        set {
            let allowedRange = calendar.range(of: .day, in: .month, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentDay = calendar.component(.day, from: self)
            let daysToAdd = newValue - currentDay
            if let date = calendar.date(byAdding: .day, value: daysToAdd, to: self) {
                self = date
            }
        }
    }
}

#endif