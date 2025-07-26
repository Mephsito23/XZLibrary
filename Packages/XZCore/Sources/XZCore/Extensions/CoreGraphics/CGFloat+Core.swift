//
//  CGFloat+Core.swift
//  XZCore
//
//  Created by XZLibrary on 2025/1/26.
//

#if canImport(CoreGraphics)
import CoreGraphics
import Foundation

// MARK: - Properties

public extension CGFloat {
    /// 绝对值
    var abs: CGFloat {
        return Swift.abs(self)
    }
    
    /// 向上取整
    var ceil: CGFloat {
        return CoreGraphics.ceil(self)
    }
    
    /// 向下取整
    var floor: CGFloat {
        return CoreGraphics.floor(self)
    }
    
    /// 四舍五入
    var round: CGFloat {
        return CoreGraphics.round(self)
    }
    
    /// 转换为Int
    var int: Int {
        return Int(self)
    }
    
    /// 转换为Float
    var float: Float {
        return Float(self)
    }
    
    /// 转换为Double
    var double: Double {
        return Double(self)
    }
    
    /// 转换为String
    var string: String {
        return "\(self)"
    }
}

// MARK: - Methods

public extension CGFloat {
    /// 限制值在指定范围内
    func clamped(to range: ClosedRange<CGFloat>) -> CGFloat {
        return Swift.max(range.lowerBound, Swift.min(range.upperBound, self))
    }
    
    /// 限制值在最小值和最大值之间
    func clamped(min: CGFloat, max: CGFloat) -> CGFloat {
        return Swift.max(min, Swift.min(max, self))
    }
    
    /// 计算两个值之间的线性插值
    func lerp(to value: CGFloat, t: CGFloat) -> CGFloat {
        return self + (value - self) * t
    }
}

#endif