//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

///
/// Example:
/// ```
/// let contentStateView = ContentStateView()
///
/// contentStateView.loadingView.configure(spinnerColor: .red)
///
/// contentStateView.emptyView.configure(
///     image: UIImage(named: "Empty"),
///     title: "Empty Title",
///     message: "This is a message",
///     buttonTitle: nil)
///
/// contentStateView.errorView.configure(
///     image: UIImage(named: "Error"),
///     title: "Error Title",
///     message: "This is a message",
///     buttonTitle: "Retry")
///
/// view.addSubview(contentStateView)
///
/// contentStateView.contentState = .empty
///
/// contentStateView.animate(to: .error)
/// ```
public class ContentStateView: UIView {

    public enum ContentState {
        case content
        case loading
        case empty
        case error
    }

    public var contentState: ContentState = .content {
        didSet {
            isHidden = (contentState == .content)
            loadingView.isHidden = (contentState != .loading)
            emptyView.isHidden = (contentState != .empty)
            errorView.isHidden = (contentState != .error)
            alpha = 1.0
            loadingView.alpha = 1.0
            emptyView.alpha = 1.0
            errorView.alpha = 1.0
        }
    }

    public let loadingView = ContentStateBaseView()
    public let emptyView = ContentStateBaseView()
    public let errorView = ContentStateBaseView()

    public init(style: ContentStateViewStyle? = nil) {
        super.init(frame: CGRect.zero)
        commonSetUp()
        if let style = style {
            apply(style: style)
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetUp()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetUp()
    }

    private func commonSetUp() {
        isHidden = true
        autoresizingMask = [.flexibleWidth, .flexibleHeight]

        addSubview(loadingView)
        addSubview(emptyView)
        addSubview(errorView)
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let superview = superview {
            frame = superview.bounds
        }
    }

    public func apply(style: ContentStateViewStyle) {
        loadingView.apply(style: style)
        emptyView.apply(style: style)
        errorView.apply(style: style)
    }

    public func animate(to newContentState: ContentState, duration: TimeInterval = 0.4) {
        guard contentState != newContentState else {
            return
        }

        if newContentState == .content {
            guard let fadeOutView = stateView(for: contentState) else {
                contentState = newContentState
                return
            }
            UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut, animations: {
                fadeOutView.alpha = 0.0
                }, completion: { [weak self] complete in
                    self?.contentState = newContentState
                })
        } else {
            guard let fadeInView = stateView(for: newContentState) else {
                contentState = newContentState
                return
            }
            fadeInView.alpha = 0.0
            fadeInView.isHidden = false
            bringSubviewToFront(fadeInView)
            UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut, animations: {
                fadeInView.alpha = 1.0
                }, completion: { [weak self] complete in
                    self?.contentState = newContentState
                })
        }
    }

    private func stateView(for state: ContentState) -> ContentStateBaseView? {
        switch state {
        case .loading: return loadingView
        case .empty: return emptyView
        case .error: return errorView
        default: return nil
        }
    }
}

public struct ContentStateViewStyle {
    public var backgroundColor: UIColor?
    public var spinnerStyle: UIActivityIndicatorView.Style?
    public var spinnerColor: UIColor?
    public var verticalSpacing: CGFloat?
    public var extraImagePadding: CGFloat?
    public var titleFont: UIFont?
    public var titleColor: UIColor?
    public var messageFont: UIFont?
    public var messageColor: UIColor?
    public var buttonFont: UIFont?
    public var buttonColor: UIColor?

    public init() {}

    public init(backgroundColor: UIColor? = nil,
                spinnerStyle: UIActivityIndicatorView.Style? = nil,
                spinnerColor: UIColor? = nil,
                verticalSpacing: CGFloat? = nil,
                extraImagePadding: CGFloat? = nil,
                titleFont: UIFont? = nil,
                titleColor: UIColor? = nil,
                messageFont: UIFont? = nil,
                messageColor: UIColor? = nil,
                buttonFont: UIFont? = nil,
                buttonColor: UIColor? = nil) {
        self.backgroundColor = backgroundColor
        self.spinnerStyle = spinnerStyle
        self.spinnerColor = spinnerColor
        self.verticalSpacing = verticalSpacing
        self.extraImagePadding = extraImagePadding
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.messageFont = messageFont
        self.messageColor = messageColor
        self.buttonFont = buttonFont
        self.buttonColor = buttonColor
    }
}


public class ContentStateSpacerView: UIView {

    public var horizontalSpacing: CGFloat = 1.0 {
        didSet {
            frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: horizontalSpacing, height: frame.size.height)
        }
    }

    public var verticalSpacing: CGFloat = 1.0 {
        didSet {
            frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: verticalSpacing)
        }
    }

    public override var intrinsicContentSize: CGSize {
        return CGSize(width: horizontalSpacing, height: verticalSpacing)
    }

    public init(horizontal: CGFloat = 1.0, vertical: CGFloat = 1.0) {
        super.init(frame: CGRect(x: 0, y: 0, width: horizontal, height: vertical))
        self.horizontalSpacing = horizontal
        self.verticalSpacing = vertical
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}


public class ContentStateBaseView: UIView {

    public var contentWidth: CGFloat = 280 {
        didSet {
            stackViewWidthConstraint?.constant = contentWidth
            setNeedsUpdateConstraints()
        }
    }

    public let spinnerView = UIActivityIndicatorView()

    public let imageView = UIImageView()

    public let imageSpacerView = ContentStateSpacerView(vertical: 0)

    public let titleLabel = UILabel()

    public let messageLabel = UILabel()

    public let button = UIButton(type: UIButton.ButtonType.system)

    public let stackView = UIStackView()

    public var buttonAction: (() -> Void)? = nil

    public override var isHidden: Bool {
        didSet {
            if !isHidden && !spinnerView.isHidden {
                spinnerView.startAnimating()
            } else if spinnerView.isAnimating {
                spinnerView.stopAnimating()
            }
        }
    }

    private var stackViewWidthConstraint: NSLayoutConstraint?

    public init() {
        super.init(frame: CGRect.zero)
        commonSetUp()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetUp()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetUp()
    }

    private func commonSetUp() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundColor = .white

        setUp(stackView: stackView)
        setUp(spinnerView: spinnerView, in: stackView)
        setUp(imageView: imageView, in: stackView)
        setUp(titleLabel: titleLabel, in: stackView)
        setUp(messageLabel: messageLabel, in: stackView)
        setUp(button: button, in: stackView)
    }

    private func setUp(stackView: UIStackView) {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 20

        addSubview(stackView)

        // Center stack view.
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        stackViewWidthConstraint = stackView.widthAnchor.constraint(equalToConstant: contentWidth)
        stackViewWidthConstraint?.isActive = true
    }

    private func setUp(spinnerView: UIActivityIndicatorView, in stackView: UIStackView) {
        stackView.addArrangedSubview(spinnerView)
    }

    private func setUp(imageView: UIImageView, in stackView: UIStackView) {
        imageView.sizeToFit()
        stackView.addArrangedSubview(imageView)
        imageSpacerView.isHidden = true
        stackView.addArrangedSubview(imageSpacerView)
    }

    private func setUp(titleLabel: UILabel, in stackView: UIStackView) {
        titleLabel.textAlignment = .center
        stackView.addArrangedSubview(titleLabel)
    }

    private func setUp(messageLabel: UILabel, in stackView: UIStackView) {
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        stackView.addArrangedSubview(messageLabel)
    }

    private func setUp(button: UIButton, in stackView: UIStackView) {
        button.addTarget(self, action: #selector(actionButtonPressed(_:)), for: .touchUpInside)
        stackView.addArrangedSubview(button)
    }

    @objc func actionButtonPressed(_ sender: Any?) {
        buttonAction?()
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let superview = superview {
            frame = superview.bounds
        }
    }

    public override func layoutSubviews() {
        spinnerView.sizeToFit()
        imageView.sizeToFit()
        titleLabel.sizeToFit()
        messageLabel.sizeToFit()
        button.sizeToFit()
        super.layoutSubviews()
    }

    private func allVisible(views: UIView...) -> Bool {
        for view in views {
            if view.isHidden {
                return false
            }
        }
        return true
    }

    private func anyVisible(views: UIView...) -> Bool {
        for view in views {
            if !view.isHidden {
                return true
            }
        }
        return false
    }

    public func updateSpacerViews() {
        imageSpacerView.isHidden = !(allVisible(views: imageView) && anyVisible(views: titleLabel, messageLabel, button))
    }

    // MARK: - Configuration

    public func configure(attributedTitle: NSAttributedString?,
                          attributedMessage: NSAttributedString? = nil) {
        spinnerView.isHidden = false
        imageView.image = nil
        imageView.isHidden = true
        titleLabel.attributedText = attributedTitle
        titleLabel.isHidden = (attributedTitle == nil)
        messageLabel.attributedText = attributedMessage
        messageLabel.isHidden = (attributedMessage == nil)
        button.isHidden = true
        updateSpacerViews()
        setNeedsLayout()
    }

    public func configure(spinnerColor: UIColor,
                          title: String? = nil,
                          message: String? = nil) {
        spinnerView.color = spinnerColor
        spinnerView.isHidden = false
        imageView.image = nil
        imageView.isHidden = true
        titleLabel.text = title
        titleLabel.isHidden = (title == nil)
        messageLabel.text = message
        messageLabel.isHidden = (message == nil)
        button.isHidden = true
        updateSpacerViews()
        setNeedsLayout()
    }

    public func configure(image: UIImage?,
                          attributedTitle: NSAttributedString?,
                          attributedMessage: NSAttributedString?,
                          buttonTitle: String? = nil,
                          buttonAction: @escaping () -> Void = {}) {
        spinnerView.isHidden = true
        imageView.image = image
        imageView.isHidden = (image == nil)
        titleLabel.attributedText = attributedTitle
        titleLabel.isHidden = (attributedTitle == nil)
        messageLabel.attributedText = attributedMessage
        messageLabel.isHidden = (attributedMessage == nil)
        button.setTitle(buttonTitle, for: .normal)
        button.isHidden = (buttonTitle == nil)
        self.buttonAction = buttonAction
        updateSpacerViews()
        setNeedsLayout()
    }

    public func configure(image: UIImage?,
                          title: String?,
                          message: String?,
                          buttonTitle: String? = nil,
                          buttonAction: @escaping () -> Void = {}) {
        spinnerView.isHidden = true
        imageView.image = image
        imageView.isHidden = (image == nil)
        titleLabel.text = title
        titleLabel.isHidden = (title == nil)
        messageLabel.text = message
        messageLabel.isHidden = (message == nil)
        button.setTitle(buttonTitle, for: .normal)
        button.isHidden = (buttonTitle == nil)
        self.buttonAction = buttonAction
        updateSpacerViews()
        setNeedsLayout()
    }

    public func apply(style: ContentStateViewStyle) {
        backgroundColor = style.backgroundColor ?? backgroundColor
        spinnerView.style = style.spinnerStyle ?? spinnerView.style
        spinnerView.color = style.spinnerColor ?? spinnerView.color
        stackView.spacing = style.verticalSpacing ?? stackView.spacing
        imageSpacerView.verticalSpacing = style.extraImagePadding ?? imageSpacerView.verticalSpacing
        titleLabel.font = style.titleFont ?? titleLabel.font
        titleLabel.textColor = style.titleColor ?? titleLabel.textColor
        messageLabel.font = style.messageFont ?? messageLabel.font
        messageLabel.textColor = style.messageColor ?? messageLabel.textColor
        button.titleLabel?.font = style.buttonFont ?? button.titleLabel?.font
        button.tintColor = style.buttonColor ?? button.tintColor
    }
}

#endif
