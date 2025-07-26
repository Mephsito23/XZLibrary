//
//  UIView+Extension.swift
//  QizAIFramework
//
//  Created by Mephisto on 2025/6/3.
//

#if os(iOS)

import Foundation
import UIKit

extension UIView {

    func takeScreenshot() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        return renderer.image { ctx in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
    }

    /// 判断视图是否在屏幕可见范围内
    var isVisibleInScreen: Bool {
        guard let window = self.window else { return false }

        // 将视图的frame转换为窗口坐标系
        let viewFrameInWindow = convert(bounds, to: window)

        // 获取窗口的可见bounds
        let windowBounds = window.bounds

        // 检查两个矩形是否有交集
        let isVisible = viewFrameInWindow.intersects(windowBounds)

        return isVisible && !isHidden && alpha > 0 && window.isKeyWindow
    }

}

extension UIView {

    func qmui_removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }

    func roundCorners(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {
        let path = UIBezierPath()

        // 开始于左上角 (通常是0,0)
        path.move(to: CGPoint(x: bounds.minX + topLeft, y: bounds.minY))

        // 添加顶部边线和右上角弧度
        path.addLine(to: CGPoint(x: bounds.maxX - topRight, y: bounds.minY))
        path.addArc(
            withCenter: CGPoint(x: bounds.maxX - topRight, y: bounds.minY + topRight),
            radius: topRight,
            startAngle: .pi * 1.5,
            endAngle: .pi * 2,
            clockwise: true
        )

        // 添加右侧边线和右下角弧度
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY - bottomRight))
        path.addArc(
            withCenter: CGPoint(x: bounds.maxX - bottomRight, y: bounds.maxY - bottomRight),
            radius: bottomRight,
            startAngle: 0,
            endAngle: .pi * 0.5,
            clockwise: true
        )

        // 添加底部边线和左下角弧度
        path.addLine(to: CGPoint(x: bounds.minX + bottomLeft, y: bounds.maxY))
        path.addArc(
            withCenter: CGPoint(x: bounds.minX + bottomLeft, y: bounds.maxY - bottomLeft),
            radius: bottomLeft,
            startAngle: .pi * 0.5,
            endAngle: .pi,
            clockwise: true
        )

        // 添加左侧边线和左上角弧度
        path.addLine(to: CGPoint(x: bounds.minX, y: bounds.minY + topLeft))
        path.addArc(
            withCenter: CGPoint(x: bounds.minX + topLeft, y: bounds.minY + topLeft),
            radius: topLeft,
            startAngle: .pi,
            endAngle: .pi * 1.5,
            clockwise: true
        )

        path.close()

        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }

}
#endif
