//
//  Int+Core.swift
//  XZCore
//
//  Created by XZLibrary on 2025/1/26.
//

#if canImport(Foundation)
import Foundation

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

// MARK: - Properties

public extension Int {
    /// CountableRange 0..<Int
    var countableRange: CountableRange<Int> {
        return 0..<self
    }
    
    /// 角度转弧度
    var degreesToRadians: Double {
        return Double.pi * Double(self) / 180.0
    }
    
    /// 弧度转角度
    var radiansToDegrees: Double {
        return Double(self) * 180 / Double.pi
    }
    
    /// 转换为UInt
    var uInt: UInt {
        return UInt(self)
    }
    
    /// 转换为Double
    var double: Double {
        return Double(self)
    }
    
    /// 转换为Float
    var float: Float {
        return Float(self)
    }
    
    #if canImport(CoreGraphics)
    /// 转换为CGFloat
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
    #endif
    
    /// 转换为String
    var string: String {
        return "\(self)"
    }
    
    /// 绝对值
    var abs: Int {
        return Swift.abs(self)
    }
    
    /// 是否为偶数
    var isEven: Bool {
        return self % 2 == 0
    }
    
    /// 是否为奇数
    var isOdd: Bool {
        return self % 2 != 0
    }
    
    /// 是否为正数
    var isPositive: Bool {
        return self > 0
    }
    
    /// 是否为负数
    var isNegative: Bool {
        return self < 0
    }
}

// MARK: - Methods

public extension Int {
    /// 限制值在指定范围内
    func clamped(to range: ClosedRange<Int>) -> Int {
        return Swift.max(range.lowerBound, Swift.min(range.upperBound, self))
    }
    
    /// 限制值在最小值和最大值之间
    func clamped(min: Int, max: Int) -> Int {
        return Swift.max(min, Swift.min(max, self))
    }
    
    /// 生成随机数组
    func random() -> Int {
        guard self > 0 else { return 0 }
        return Int.random(in: 0..<self)
    }
    
    /// 计算阶乘
    func factorial() -> Int {
        guard self >= 0 else { return 0 }
        guard self > 1 else { return 1 }
        return self * (self - 1).factorial()
    }
}

#endif