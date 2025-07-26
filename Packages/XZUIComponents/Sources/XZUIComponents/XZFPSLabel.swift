//
//  SwiftFPSLabel.swift
//  QizAIFramework_Example
//
//  Created by Mephisto on 2025/6/13.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class XZFPSLabel: UILabel {
    private var displayLink: CADisplayLink?
    private var lastTimestamp: TimeInterval = 0
    private var frameCount: Int = 0

    static func show() {
        let fpsLabel = XZFPSLabel(frame: .init(x: 5, y: 80, width: 60, height: 20))
        fpsLabel.font = .systemFont(ofSize: 12)
        fpsLabel.layer.cornerRadius = 10
        fpsLabel.layer.masksToBounds = true
        fpsLabel.backgroundColor = .black.withAlphaComponent(0.5)
        fpsLabel.textColor = .white
        fpsLabel.textAlignment = .center
        UIApplication.shared.keyWindow?.addSubview(fpsLabel)
        fpsLabel.start()
    }

    func start() {
        displayLink = CADisplayLink(target: self, selector: #selector(update(link:)))
        displayLink?.add(to: .main, forMode: .common)
    }

    @objc private func update(link: CADisplayLink) {
        if lastTimestamp == 0 {
            lastTimestamp = link.timestamp
            return
        }
        frameCount += 1
        let delta = link.timestamp - lastTimestamp
        if delta >= 1 {
            let fps = Int(round(Double(frameCount) / delta))
            text = "\(fps) FPS"
            frameCount = 0
            lastTimestamp = link.timestamp
        }
    }
}
