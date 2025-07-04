//
//  UIScrollView+Extension.swift
//  QizAIFramework
//
//  Created by Mephisto on 2025/6/3.
//

import Foundation
import UIKit

extension UIScrollView {

    func screenshotOfScrollView() -> UIImage? {
        let scrollView = self
        let savedContentOffset = scrollView.contentOffset
        let savedFrame = scrollView.frame

        scrollView.contentOffset = .zero
        scrollView.frame = CGRect(
            x: 0,
            y: 0,
            width: scrollView.contentSize.width,
            height: scrollView.contentSize.height
        )

        let renderer = UIGraphicsImageRenderer(size: scrollView.contentSize)
        let image = renderer.image { ctx in
            scrollView.layer.render(in: ctx.cgContext)
        }

        scrollView.contentOffset = savedContentOffset
        scrollView.frame = savedFrame

        return image
    }
}
