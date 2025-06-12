//
//  XZUIButton.swift
//  QizAIFramework
//
//  Created by Mephisto on 2025/5/14.
//

import UIKit

// MARK: - Constants

private struct ButtonConstants {
    static let tintColor = UIColor.black
    static let highlightedAlpha: CGFloat = 1.0
    static let disabledAlpha: CGFloat = 1.0
    static let minimumContentEdgeInsets = UIEdgeInsets(
        top: CGFloat.leastNormalMagnitude,
        left: 0,
        bottom: CGFloat.leastNormalMagnitude,
        right: 0
    )
}

// MARK: - Image Position

enum XZUIButtonImagePosition {
    case top  // Image above title
    case left  // Image to the left of title (default)
    case bottom  // Image below title
    case right  // Image to the right of title
}

// MARK: - Main Button Class

class XZUIButton: UIButton {

    // MARK: - Public Properties

    /// Automatically adjusts title color to match tintColor
    @IBInspectable var adjustsTitleTintColorAutomatically: Bool = false {
        didSet {
            guard adjustsTitleTintColorAutomatically != oldValue else { return }
            updateTitleColor()
        }
    }

    /// Automatically adjusts image color to match tintColor
    @IBInspectable var adjustsImageTintColorAutomatically: Bool = false {
        didSet {
            guard adjustsImageTintColorAutomatically != oldValue else { return }
            updateImageRenderingMode()
        }
    }

    /// Convenience property to set both title and image tint adjustment
    @IBInspectable var tintColorAdjustsTitleAndImage: UIColor {
        get { return tintColor }
        set {
            tintColor = newValue
            adjustsTitleTintColorAutomatically = true
            adjustsImageTintColorAutomatically = true
        }
    }

    /// Adjusts alpha when highlighted
    @IBInspectable var adjustsButtonWhenHighlighted: Bool = true

    /// Adjusts alpha when disabled
    @IBInspectable var adjustsButtonWhenDisabled: Bool = true

    /// Background color when highlighted
    @IBInspectable var highlightedBackgroundColor: UIColor? {
        didSet {
            if highlightedBackgroundColor != nil {
                adjustsButtonWhenHighlighted = false
            }
        }
    }

    /// Border color when highlighted
    @IBInspectable var highlightedBorderColor: UIColor? {
        didSet {
            if highlightedBorderColor != nil {
                adjustsButtonWhenHighlighted = false
            }
        }
    }

    /// Position of image relative to title
    var imagePosition: XZUIButtonImagePosition = .left {
        didSet {
            guard imagePosition != oldValue else { return }
            setNeedsLayout()
        }
    }

    /// Spacing between image and title
    @IBInspectable var spacingBetweenImageAndTitle: CGFloat = 0 {
        didSet {
            guard spacingBetweenImageAndTitle != oldValue else { return }
            setNeedsLayout()
        }
    }

    // MARK: - Private Properties

    private var highlightedBackgroundLayer = CALayer()
    private var originalBorderColor: UIColor?

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    convenience init(title: String?, image: UIImage?) {
        self.init()
        setTitle(title, for: .normal)
        setImage(image, for: .normal)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        // Default settings
        adjustsTitleTintColorAutomatically = false
        adjustsImageTintColorAutomatically = false
        adjustsImageWhenHighlighted = false
        adjustsImageWhenDisabled = false
        adjustsButtonWhenHighlighted = true
        adjustsButtonWhenDisabled = true

        // Visual setup
        tintColor = ButtonConstants.tintColor
        contentEdgeInsets = ButtonConstants.minimumContentEdgeInsets

        if !adjustsTitleTintColorAutomatically {
            setTitleColor(ButtonConstants.tintColor, for: .normal)
        }
    }

    // MARK: - Layout

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let isImageViewVisible = imageView?.isHidden == false
        let isTitleLabelVisible = titleLabel?.isHidden == false

        // Calculate content size without edge insets
        let contentSize = CGSize(
            width: size.width - contentEdgeInsets.horizontalValue,
            height: size.height - contentEdgeInsets.verticalValue
        )

        // Calculate image and title sizes
        let imageSize = isImageViewVisible ? calculateImageSize(for: contentSize) : .zero
        let titleSize = isTitleLabelVisible ? calculateTitleSize(for: contentSize, imageSize: imageSize) : .zero

        // Calculate total size based on image position
        let totalSize: CGSize
        switch imagePosition {
        case .top, .bottom:
            totalSize = CGSize(
                width: max(imageSize.width, titleSize.width),
                height: imageSize.height + (isImageViewVisible && isTitleLabelVisible ? spacingBetweenImageAndTitle : 0)
                    + titleSize.height
            )
        case .left, .right:
            totalSize = CGSize(
                width: imageSize.width + (isImageViewVisible && isTitleLabelVisible ? spacingBetweenImageAndTitle : 0)
                    + titleSize.width,
                height: max(imageSize.height, titleSize.height)
            )
        }

        // Add edge insets back
        return CGSize(
            width: totalSize.width + contentEdgeInsets.horizontalValue,
            height: totalSize.height + contentEdgeInsets.verticalValue
        )
    }

    override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard !bounds.isEmpty else { return }

        let isImageViewVisible = imageView?.isHidden == false
        let isTitleLabelVisible = titleLabel?.isHidden == false

        // Calculate available content size
        let contentSize = CGSize(
            width: bounds.width - contentEdgeInsets.horizontalValue,
            height: bounds.height - contentEdgeInsets.verticalValue
        )

        // Calculate image and title sizes
        let imageSize = isImageViewVisible ? calculateImageSize(for: contentSize) : .zero
        let titleSize = isTitleLabelVisible ? calculateTitleSize(for: contentSize, imageSize: imageSize) : .zero

        // Position views based on image position
        switch imagePosition {
        case .top, .bottom:
            layoutVertical(imageSize: imageSize, titleSize: titleSize, contentSize: contentSize)
        case .left, .right:
            layoutHorizontal(imageSize: imageSize, titleSize: titleSize, contentSize: contentSize)
        }
    }

    // MARK: - State Handling

    override var isHighlighted: Bool {
        didSet {
            guard isHighlighted != oldValue else { return }

            // Store original border color if needed
            if isHighlighted && originalBorderColor == nil {
                originalBorderColor = UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor)
            }

            // Update highlighted appearance
            updateHighlightedAppearance()

            // Skip if disabled (disabled state takes precedence)
            guard isEnabled else { return }

            // Apply alpha changes if needed
            if adjustsButtonWhenHighlighted {
                alpha = isHighlighted ? ButtonConstants.highlightedAlpha : 1.0
                if !isHighlighted {
                    UIView.animate(withDuration: 0.25) {
                        self.alpha = 1.0
                    }
                }
            }
        }
    }

    override var isEnabled: Bool {
        didSet {
            guard isEnabled != oldValue else { return }

            if !isEnabled && adjustsButtonWhenDisabled {
                alpha = ButtonConstants.disabledAlpha
            } else {
                UIView.animate(withDuration: 0.25) {
                    self.alpha = 1.0
                }
            }
        }
    }

    // MARK: - Image Handling

    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        let renderedImage =
            adjustsImageTintColorAutomatically
            ? image?.withRenderingMode(.alwaysTemplate) : image?.withRenderingMode(.alwaysOriginal)
        super.setImage(renderedImage, for: state)
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()

        if adjustsTitleTintColorAutomatically {
            updateTitleColor()
        }

        if adjustsImageTintColorAutomatically {
            updateImageRenderingMode()
        }
    }

    // MARK: - Private Methods

    private func calculateImageSize(for contentSize: CGSize) -> CGSize {
        guard let imageView = imageView else { return .zero }

        let availableSize = CGSize(
            width: contentSize.width - imageEdgeInsets.horizontalValue,
            height: contentSize.height - imageEdgeInsets.verticalValue
        )

        var imageSize = imageView.sizeThatFits(availableSize)
        imageSize.width = min(imageSize.width, availableSize.width)
        imageSize.height = min(imageSize.height, availableSize.height)

        return CGSize(
            width: imageSize.width + imageEdgeInsets.horizontalValue,
            height: imageSize.height + imageEdgeInsets.verticalValue
        )
    }

    private func calculateTitleSize(for contentSize: CGSize, imageSize: CGSize) -> CGSize {
        guard let titleLabel = titleLabel else { return .zero }

        let availableSize: CGSize
        switch imagePosition {
        case .top, .bottom:
            availableSize = CGSize(
                width: contentSize.width - titleEdgeInsets.horizontalValue,
                height: contentSize.height - imageSize.height
                    - (imageView?.isHidden == false ? spacingBetweenImageAndTitle : 0) - titleEdgeInsets.verticalValue
            )
        case .left, .right:
            availableSize = CGSize(
                width: contentSize.width - titleEdgeInsets.horizontalValue - imageSize.width
                    - (imageView?.isHidden == false ? spacingBetweenImageAndTitle : 0),
                height: contentSize.height - titleEdgeInsets.verticalValue
            )
        }

        var titleSize = titleLabel.sizeThatFits(availableSize)
        titleSize.width = min(titleSize.width, availableSize.width)
        titleSize.height = min(titleSize.height, availableSize.height)

        return CGSize(
            width: titleSize.width + titleEdgeInsets.horizontalValue,
            height: titleSize.height + titleEdgeInsets.verticalValue
        )
    }

    private func layoutVertical(imageSize: CGSize, titleSize: CGSize, contentSize: CGSize) {
        guard let imageView = imageView, let titleLabel = titleLabel else { return }

        let isImageViewVisible = !imageView.isHidden
        let isTitleLabelVisible = !titleLabel.isHidden

        // Calculate frames
        var imageFrame = CGRect(origin: .zero, size: imageSize)
        var titleFrame = CGRect(origin: .zero, size: titleSize)

        // Horizontal alignment
        switch contentHorizontalAlignment {
        case .left:
            imageFrame.origin.x = contentEdgeInsets.left + imageEdgeInsets.left
            titleFrame.origin.x = contentEdgeInsets.left + titleEdgeInsets.left
        case .center:
            imageFrame.origin.x =
                contentEdgeInsets.left + imageEdgeInsets.left + (contentSize.width - imageSize.width) / 2
            titleFrame.origin.x =
                contentEdgeInsets.left + titleEdgeInsets.left + (contentSize.width - titleSize.width) / 2
        case .right:
            imageFrame.origin.x = bounds.width - contentEdgeInsets.right - imageEdgeInsets.right - imageSize.width
            titleFrame.origin.x = bounds.width - contentEdgeInsets.right - titleEdgeInsets.right - titleSize.width
        case .fill:
            if isImageViewVisible {
                imageFrame.origin.x = contentEdgeInsets.left + imageEdgeInsets.left
                imageFrame.size.width = contentSize.width - imageEdgeInsets.horizontalValue
            }
            if isTitleLabelVisible {
                titleFrame.origin.x = contentEdgeInsets.left + titleEdgeInsets.left
                titleFrame.size.width = contentSize.width - titleEdgeInsets.horizontalValue
            }
        default:
            break
        }

        // Vertical alignment
        if imagePosition == .top {
            switch contentVerticalAlignment {
            case .top:
                imageFrame.origin.y = contentEdgeInsets.top + imageEdgeInsets.top
                if isTitleLabelVisible {
                    titleFrame.origin.y = imageFrame.maxY + spacingBetweenImageAndTitle + titleEdgeInsets.top
                }
            case .center:
                let totalHeight =
                    imageSize.height + (isImageViewVisible && isTitleLabelVisible ? spacingBetweenImageAndTitle : 0)
                    + titleSize.height
                let startY = contentEdgeInsets.top + (contentSize.height - totalHeight) / 2

                imageFrame.origin.y = startY + imageEdgeInsets.top
                if isTitleLabelVisible {
                    titleFrame.origin.y = imageFrame.maxY + spacingBetweenImageAndTitle + titleEdgeInsets.top
                }
            case .bottom:
                if isTitleLabelVisible {
                    titleFrame.origin.y =
                        bounds.height - contentEdgeInsets.bottom - titleEdgeInsets.bottom - titleSize.height
                    imageFrame.origin.y =
                        titleFrame.minY - spacingBetweenImageAndTitle - imageEdgeInsets.bottom - imageSize.height
                } else {
                    imageFrame.origin.y =
                        bounds.height - contentEdgeInsets.bottom - imageEdgeInsets.bottom - imageSize.height
                }
            case .fill:
                if isImageViewVisible && isTitleLabelVisible {
                    imageFrame.origin.y = contentEdgeInsets.top + imageEdgeInsets.top
                    titleFrame.origin.y = imageFrame.maxY + spacingBetweenImageAndTitle + titleEdgeInsets.top
                    titleFrame.size.height =
                        bounds.height - contentEdgeInsets.bottom - titleEdgeInsets.bottom - titleFrame.minY
                } else if isImageViewVisible {
                    imageFrame.origin.y = contentEdgeInsets.top + imageEdgeInsets.top
                    imageFrame.size.height = contentSize.height - imageEdgeInsets.verticalValue
                } else if isTitleLabelVisible {
                    titleFrame.origin.y = contentEdgeInsets.top + titleEdgeInsets.top
                    titleFrame.size.height = contentSize.height - titleEdgeInsets.verticalValue
                }
            @unknown default:
                break
            }
        } else {  // .bottom
            switch contentVerticalAlignment {
            case .top:
                if isTitleLabelVisible {
                    titleFrame.origin.y = contentEdgeInsets.top + titleEdgeInsets.top
                    imageFrame.origin.y = titleFrame.maxY + spacingBetweenImageAndTitle + imageEdgeInsets.top
                } else {
                    imageFrame.origin.y = contentEdgeInsets.top + imageEdgeInsets.top
                }
            case .center:
                let totalHeight =
                    imageSize.height + (isImageViewVisible && isTitleLabelVisible ? spacingBetweenImageAndTitle : 0)
                    + titleSize.height
                let startY = contentEdgeInsets.top + (contentSize.height - totalHeight) / 2

                if isTitleLabelVisible {
                    titleFrame.origin.y = startY + titleEdgeInsets.top
                    imageFrame.origin.y = titleFrame.maxY + spacingBetweenImageAndTitle + imageEdgeInsets.top
                } else {
                    imageFrame.origin.y = startY + imageEdgeInsets.top
                }
            case .bottom:
                imageFrame.origin.y =
                    bounds.height - contentEdgeInsets.bottom - imageEdgeInsets.bottom - imageSize.height
                if isTitleLabelVisible {
                    titleFrame.origin.y =
                        imageFrame.minY - spacingBetweenImageAndTitle - titleEdgeInsets.bottom - titleSize.height
                }
            case .fill:
                if isImageViewVisible && isTitleLabelVisible {
                    imageFrame.origin.y =
                        bounds.height - contentEdgeInsets.bottom - imageEdgeInsets.bottom - imageSize.height
                    titleFrame.origin.y = contentEdgeInsets.top + titleEdgeInsets.top
                    titleFrame.size.height =
                        imageFrame.minY - spacingBetweenImageAndTitle - titleEdgeInsets.bottom - titleFrame.minY
                } else if isImageViewVisible {
                    imageFrame.origin.y = contentEdgeInsets.top + imageEdgeInsets.top
                    imageFrame.size.height = contentSize.height - imageEdgeInsets.verticalValue
                } else if isTitleLabelVisible {
                    titleFrame.origin.y = contentEdgeInsets.top + titleEdgeInsets.top
                    titleFrame.size.height = contentSize.height - titleEdgeInsets.verticalValue
                }
            @unknown default:
                break
            }
        }

        // Apply frames
        imageView.frame = imageFrame.flatted
        titleLabel.frame = titleFrame.flatted
    }

    private func layoutHorizontal(imageSize: CGSize, titleSize: CGSize, contentSize: CGSize) {
        guard let imageView = imageView, let titleLabel = titleLabel else { return }

        let isImageViewVisible = !imageView.isHidden
        let isTitleLabelVisible = !titleLabel.isHidden

        // Calculate frames
        var imageFrame = CGRect(origin: .zero, size: imageSize)
        var titleFrame = CGRect(origin: .zero, size: titleSize)

        // Vertical alignment
        switch contentVerticalAlignment {
        case .top:
            imageFrame.origin.y = contentEdgeInsets.top + imageEdgeInsets.top
            titleFrame.origin.y = contentEdgeInsets.top + titleEdgeInsets.top
        case .center:
            imageFrame.origin.y =
                contentEdgeInsets.top + (contentSize.height - imageSize.height) / 2 + imageEdgeInsets.top
            titleFrame.origin.y =
                contentEdgeInsets.top + (contentSize.height - titleSize.height) / 2 + titleEdgeInsets.top
        case .bottom:
            imageFrame.origin.y = bounds.height - contentEdgeInsets.bottom - imageEdgeInsets.bottom - imageSize.height
            titleFrame.origin.y = bounds.height - contentEdgeInsets.bottom - titleEdgeInsets.bottom - titleSize.height
        case .fill:
            if isImageViewVisible {
                imageFrame.origin.y = contentEdgeInsets.top + imageEdgeInsets.top
                imageFrame.size.height = contentSize.height - imageEdgeInsets.verticalValue
            }
            if isTitleLabelVisible {
                titleFrame.origin.y = contentEdgeInsets.top + titleEdgeInsets.top
                titleFrame.size.height = contentSize.height - titleEdgeInsets.verticalValue
            }
        @unknown default:
            break
        }

        // Horizontal alignment
        if imagePosition == .left {
            switch contentHorizontalAlignment {
            case .left:
                imageFrame.origin.x = contentEdgeInsets.left + imageEdgeInsets.left
                if isTitleLabelVisible {
                    titleFrame.origin.x = imageFrame.maxX + spacingBetweenImageAndTitle + titleEdgeInsets.left
                }
            case .center:
                let totalWidth =
                    imageSize.width + (isImageViewVisible && isTitleLabelVisible ? spacingBetweenImageAndTitle : 0)
                    + titleSize.width
                let startX = contentEdgeInsets.left + (contentSize.width - totalWidth) / 2

                imageFrame.origin.x = startX + imageEdgeInsets.left
                if isTitleLabelVisible {
                    titleFrame.origin.x = imageFrame.maxX + spacingBetweenImageAndTitle + titleEdgeInsets.left
                }
            case .right:
                if imageSize.width + spacingBetweenImageAndTitle + titleSize.width > contentSize.width {
                    // Content too wide - prioritize image
                    imageFrame.origin.x = contentEdgeInsets.left + imageEdgeInsets.left
                    if isTitleLabelVisible {
                        titleFrame.origin.x = imageFrame.maxX + spacingBetweenImageAndTitle + titleEdgeInsets.left
                    }
                } else {
                    // Fit content to right
                    imageFrame.origin.x =
                        bounds.width - contentEdgeInsets.right - titleSize.width - spacingBetweenImageAndTitle
                        - imageSize.width + imageEdgeInsets.left
                    titleFrame.origin.x =
                        bounds.width - contentEdgeInsets.right - titleEdgeInsets.right - titleSize.width
                }
            case .fill:
                if isImageViewVisible && isTitleLabelVisible {
                    imageFrame.origin.x = contentEdgeInsets.left + imageEdgeInsets.left
                    titleFrame.origin.x = imageFrame.maxX + spacingBetweenImageAndTitle + titleEdgeInsets.left
                    titleFrame.size.width =
                        bounds.width - contentEdgeInsets.right - titleEdgeInsets.right - titleFrame.minX
                } else if isImageViewVisible {
                    imageFrame.origin.x = contentEdgeInsets.left + imageEdgeInsets.left
                    imageFrame.size.width = contentSize.width - imageEdgeInsets.horizontalValue
                } else if isTitleLabelVisible {
                    titleFrame.origin.x = contentEdgeInsets.left + titleEdgeInsets.left
                    titleFrame.size.width = contentSize.width - titleEdgeInsets.horizontalValue
                }
            default:
                break
            }
        } else {  // .right
            switch contentHorizontalAlignment {
            case .left:
                if imageSize.width + spacingBetweenImageAndTitle + titleSize.width > contentSize.width {
                    // Content too wide - prioritize image
                    imageFrame.origin.x =
                        bounds.width - contentEdgeInsets.right - imageEdgeInsets.right - imageSize.width
                    titleFrame.origin.x =
                        imageFrame.minX - spacingBetweenImageAndTitle - titleSize.width + titleEdgeInsets.left
                } else {
                    // Fit content to left
                    titleFrame.origin.x = contentEdgeInsets.left + titleEdgeInsets.left
                    imageFrame.origin.x = titleFrame.maxX + spacingBetweenImageAndTitle + imageEdgeInsets.left
                }
            case .center:
                let totalWidth =
                    imageSize.width + (isImageViewVisible && isTitleLabelVisible ? spacingBetweenImageAndTitle : 0)
                    + titleSize.width
                let startX = contentEdgeInsets.left + (contentSize.width - totalWidth) / 2

                titleFrame.origin.x = startX + titleEdgeInsets.left
                imageFrame.origin.x = titleFrame.maxX + spacingBetweenImageAndTitle + imageEdgeInsets.left
            case .right:
                imageFrame.origin.x = bounds.width - contentEdgeInsets.right - imageEdgeInsets.right - imageSize.width
                if isTitleLabelVisible {
                    titleFrame.origin.x =
                        imageFrame.minX - spacingBetweenImageAndTitle - titleEdgeInsets.right - titleSize.width
                }
            case .fill:
                if isImageViewVisible && isTitleLabelVisible {
                    imageFrame.origin.x =
                        bounds.width - contentEdgeInsets.right - imageEdgeInsets.right - imageSize.width
                    titleFrame.origin.x = contentEdgeInsets.left + titleEdgeInsets.left
                    titleFrame.size.width =
                        imageFrame.minX - spacingBetweenImageAndTitle - titleEdgeInsets.right - titleFrame.minX
                } else if isImageViewVisible {
                    imageFrame.origin.x = contentEdgeInsets.left + imageEdgeInsets.left
                    imageFrame.size.width = contentSize.width - imageEdgeInsets.horizontalValue
                } else if isTitleLabelVisible {
                    titleFrame.origin.x = contentEdgeInsets.left + titleEdgeInsets.left
                    titleFrame.size.width = contentSize.width - titleEdgeInsets.horizontalValue
                }
            default:
                break
            }
        }

        // Apply frames
        imageView.frame = imageFrame.flatted
        titleLabel.frame = titleFrame.flatted
    }

    private func updateHighlightedAppearance() {
        guard highlightedBackgroundColor != nil || highlightedBorderColor != nil else { return }

        highlightedBackgroundLayer.removeAllAnimations()
        layer.insertSublayer(highlightedBackgroundLayer, at: 0)

        highlightedBackgroundLayer.frame = bounds
        highlightedBackgroundLayer.cornerRadius = layer.cornerRadius
        highlightedBackgroundLayer.backgroundColor =
            isHighlighted ? highlightedBackgroundColor?.cgColor : UIColor.clear.cgColor

        if let highlightedBorderColor = highlightedBorderColor {
            layer.borderColor = isHighlighted ? highlightedBorderColor.cgColor : originalBorderColor?.cgColor
        }
    }

    private func updateTitleColor() {
        guard adjustsTitleTintColorAutomatically else { return }

        setTitleColor(tintColor, for: .normal)

        if let currentAttributedTitle = currentAttributedTitle {
            let attributedString = NSMutableAttributedString(attributedString: currentAttributedTitle)
            let range = NSRange(location: 0, length: attributedString.length)
            attributedString.addAttribute(
                .foregroundColor,
                value: tintColor,
                range: range
            )
            setAttributedTitle(attributedString, for: .normal)
        }
    }

    private func updateImageRenderingMode() {
        let states: [UIControl.State] = [
            .normal,
            .highlighted,
            .selected,
            [.selected, .highlighted],
            .disabled,
        ]

        for state in states {
            // Skip if this state has a custom image set
            if state != .normal && hasCustomImage(for: state) {
                continue
            }

            let image = self.image(for: state)
            let renderingMode: UIImage.RenderingMode =
                adjustsImageTintColorAutomatically ? .alwaysTemplate : .alwaysOriginal
            setImage(image?.withRenderingMode(renderingMode), for: state)
        }
    }

    private func hasCustomImage(for state: UIControl.State) -> Bool {
        // Check if a custom image has been set for this state
        // Implementation depends on your specific needs
        // This is a placeholder for the actual implementation
        return false
    }
}
