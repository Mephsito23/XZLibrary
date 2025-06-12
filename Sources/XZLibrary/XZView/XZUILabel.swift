//
//  XZUILabel.swift
//  QizAIFramework
//
//  Created by Mephisto on 2025/4/17.
//
import UIKit

/**
 * `XZUILabel` 是一个增强版的 UILabel，提供以下功能：
 * 1. 通过 `contentEdgeInsets` 属性实现类似 padding 的效果
 * 2. 通过 `canPerformCopyAction` 开启长按复制文本功能
 * 3. 通过 `lineHeight` 设置自定义行高
 * 4. 长按时可通过 `highlightedBackgroundColor` 设置背景色
 */
class XZUILabel: UILabel {

    // MARK: - Public Properties

    /// 控制 label 内容的 padding，默认为 .zero
    public var contentEdgeInsets: UIEdgeInsets = .zero {
        didSet {
            guard oldValue != contentEdgeInsets else { return }
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
        }
    }

    /// 是否开启长按复制功能，默认为 false
    @IBInspectable public var canPerformCopyAction: Bool = false {
        didSet {
            guard oldValue != canPerformCopyAction else { return }
            setupCopyActionIfNeeded()
        }
    }

    /// 长按时的背景色
    @IBInspectable public var highlightedBackgroundColor: UIColor? {
        didSet {
            tempBackgroundColor = backgroundColor
        }
    }

    /// 自定义行高，设置为 0 表示使用默认行高
    public var lineHeight: CGFloat = 0 {
        didSet {
            guard oldValue != lineHeight else { return }
            updateTextWithLineHeight()
        }
    }

    // MARK: - Private Properties

    private var tempBackgroundColor: UIColor?
    private weak var longPressGestureRecognizer: UILongPressGestureRecognizer?

    // MARK: - Lifecycle

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Override Methods

    override var text: String? {
        didSet {
            updateTextWithLineHeight()
        }
    }

    override var attributedText: NSAttributedString? {
        didSet {
            updateTextWithLineHeight()
        }
    }

    override var isHighlighted: Bool {
        didSet {
            updateBackgroundColorForHighlightedState()
        }
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let horizontalInset = contentEdgeInsets.horizontalValue
        let verticalInset = contentEdgeInsets.verticalValue

        let constrainedSize = CGSize(
            width: size.width - horizontalInset,
            height: size.height - verticalInset
        )

        var fittedSize = super.sizeThatFits(constrainedSize)
        fittedSize.width += horizontalInset
        fittedSize.height += verticalInset

        return fittedSize
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentEdgeInsets))
    }

    override var canBecomeFirstResponder: Bool {
        return canPerformCopyAction
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return canPerformCopyAction && action == #selector(copyText)
    }

    // MARK: - Private Methods

    /// 更新带有行高的文本
    private func updateTextWithLineHeight() {
        guard lineHeight > 0 else { return }

        let currentText: String?
        let currentAttributes: [NSAttributedString.Key: Any]?

        if let attributedText = attributedText, attributedText.length > 0 {
            currentText = nil
            currentAttributes = attributedText.attributes(at: 0, effectiveRange: nil)
        } else if let text = text, !text.isEmpty {
            currentText = text
            currentAttributes = nil
        } else {
            return
        }

        let mutableAttributedString: NSMutableAttributedString
        if let currentText = currentText {
            mutableAttributedString = NSMutableAttributedString(string: currentText)
        } else {
            mutableAttributedString = NSMutableAttributedString(attributedString: attributedText!)
        }

        // 检查是否已经设置了行高
        var shouldApplyLineHeight = true
        mutableAttributedString.enumerateAttribute(
            .paragraphStyle,
            in: NSRange(location: 0, length: mutableAttributedString.length),
            options: []
        ) { (value, _, stop) in
            if let paragraphStyle = value as? NSParagraphStyle {
                if paragraphStyle.minimumLineHeight > 0 || paragraphStyle.maximumLineHeight > 0 {
                    shouldApplyLineHeight = false
                    stop.pointee = true
                }
            }
        }

        if shouldApplyLineHeight {
            applyLineHeight(to: mutableAttributedString, existingAttributes: currentAttributes)
            super.attributedText = mutableAttributedString
        }
    }

    /// 应用行高到属性字符串
    private func applyLineHeight(
        to attributedString: NSMutableAttributedString,
        existingAttributes: [NSAttributedString.Key: Any]?
    ) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight

        var attributes: [NSAttributedString.Key: Any] = existingAttributes ?? [:]
        attributes[.paragraphStyle] = paragraphStyle

        attributedString.addAttributes(
            attributes,
            range: NSRange(location: 0, length: attributedString.length)
        )
    }

    /// 更新高亮状态下的背景色
    private func updateBackgroundColorForHighlightedState() {
        guard let highlightedBackgroundColor = highlightedBackgroundColor else { return }
        backgroundColor = isHighlighted ? highlightedBackgroundColor : tempBackgroundColor
    }

    // MARK: - Copy Action

    /// 设置复制功能相关配置
    private func setupCopyActionIfNeeded() {
        if canPerformCopyAction {
            setupCopyAction()
        } else {
            removeCopyAction()
        }
    }

    /// 设置复制功能
    private func setupCopyAction() {
        guard longPressGestureRecognizer == nil else { return }

        isUserInteractionEnabled = true

        let gesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleLongPressGesture(_:))
        )
        addGestureRecognizer(gesture)
        longPressGestureRecognizer = gesture

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleMenuWillHideNotification(_:)),
            name: UIMenuController.willHideMenuNotification,
            object: nil
        )

        if highlightedBackgroundColor == nil {
            highlightedBackgroundColor = .clear
        }
    }

    /// 移除复制功能
    private func removeCopyAction() {
        guard let gesture = longPressGestureRecognizer else { return }

        removeGestureRecognizer(gesture)
        longPressGestureRecognizer = nil
        isUserInteractionEnabled = false

        NotificationCenter.default.removeObserver(
            self,
            name: UIMenuController.willHideMenuNotification,
            object: nil
        )
    }

    @objc private func copyText() {
        guard canPerformCopyAction else { return }
        UIPasteboard.general.string = text
    }

    @objc private func handleLongPressGesture(_ gesture: UIGestureRecognizer) {
        guard canPerformCopyAction, gesture.state == .began else { return }

        becomeFirstResponder()

        let menuController = UIMenuController.shared
        menuController.menuItems = [UIMenuItem(title: "复制", action: #selector(copyText))]
        menuController.showMenu(from: self, rect: bounds)

        tempBackgroundColor = backgroundColor
        backgroundColor = highlightedBackgroundColor
    }

    @objc private func handleMenuWillHideNotification(_ notification: Notification) {
        guard canPerformCopyAction else { return }
        backgroundColor = tempBackgroundColor
    }
}
