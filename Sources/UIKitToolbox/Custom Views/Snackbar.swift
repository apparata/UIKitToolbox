//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

/// Android-like `Snackbar` that slides into the view for a period of time.
/// Sometimes it only contains a message, sometimes it contains an action.
/// The message label may show one or two lines of text.
public final class Snackbar {
    
    fileprivate enum Direction {
        case up
        case down
        case left
        case right
    }
    
    /// How long the `Snackbar` stays on screen.
    public enum Duration {
        case indefinite
        case long
        case short
        case time(interval: TimeInterval)
    }
    
    /// Display state of the `Snackbar`.
    public enum State {
        case ready
        case shown
        case queued
        case dismissed
    }
    
    /// Is true if the current state is .ready
    public var isReady: Bool {
        return state == .ready
    }
    
    /// Is true if the current state is .queued
    public var isQueued: Bool {
        return state == .queued
    }
    
    /// Is true if the current state is .shown
    public var isShown: Bool {
        return state == .shown
    }
    
    /// Is true if the current state is .dismissed
    public var isDismissed: Bool {
        return state == .dismissed
    }
    
    /// The text message shown in the `Snackbar`.
    public var text: String?
    
    /// The color of the text message shown in the `Snackbar`.
    /// Defaults to white.
    public var textColor: UIColor = UIColor.white
    
    /// Text of the action button.
    public var actionText: String?
    
    /// Color of the action button color.
    /// If not set, the tint color of the superview will be used.
    public var actionColor: UIColor?
    
    /// `Snackbar` background color. Defaults to dark grey.
    public var backgroundColor: UIColor = UIColor(white: 0.2, alpha: 1.0)
    
    /// Closure to run if the action button is tapped.
    public var action: (() -> Void)?
    
    /// Vertical offset of `Snackbar` view from the bottom of the view.
    public var offsetFromBottom: CGFloat = 0.0
    
    /// Height of the `Snackbar`. Defaults to 64 points.
    public var height: CGFloat = 64.0
    
    /// Called when the state changes.
    public var stateDidChange: ((Snackbar) -> Void)?
    
    /// How long the `Snackbar` stays on screen.
    public let duration: Duration
    
    /// The superview of the `Snackbar`.
    public private(set) weak var inView: UIView?
    
    fileprivate weak var operation: SnackbarAsyncOperation?
    
    /// Current display state of the `Snackbar`.
    public internal(set) var state: State = .ready {
        didSet {
            stateDidChange?(self)
        }
    }
    
    /// `Snackbar` will be shown in a view.
    public init(inView: UIView, text: String, duration: Duration) {
        self.text = text
        self.inView = inView
        self.duration = duration
    }
    
    /// `Snackbar` will be shown in a view.
    public convenience init(inView: UIView, text: String, duration: TimeInterval) {
        self.init(inView: inView, text: text, duration: Duration.time(interval: duration))
    }
    
    
    /// `Snackbar` will be shown in a view.
    public init(inView: UIView, duration: Duration) {
        self.inView = inView
        self.duration = duration
    }
    
    /// `Snackbar` will be shown in a view.
    public convenience init(inView: UIView, duration: TimeInterval) {
        self.init(inView: inView, duration: .time(interval: duration))
    }
    
    /// Update the `Snackbar` text.
    public func text(_ text: String) -> Snackbar {
        self.text = text
        return self
    }
    
    /// Set the action to be displayed in the `Snackbar`.
    public func action(_ text: String, action: @escaping () -> Void) -> Snackbar {
        self.actionText = text
        self.action = action
        return self
    }
    
    /// Set the `Snackbar` colors. `nil` indicates the default color.
    public func color(_ background: UIColor? = nil, text: UIColor? = nil, action: UIColor? = nil) -> Snackbar {
        backgroundColor = background ?? UIColor(white: 0.2, alpha: 1.0)
        textColor = text ?? textColor
        actionColor = action
        return self
    }
    
    /// Set vertical offset of `Snackbar` view from the bottom of the screen.
    public func offset(fromBottom offset: CGFloat) -> Snackbar {
        offsetFromBottom = offset
        return self
    }
    
    /// Set a state change handler closure.
    public func stateDidChange(handler: @escaping (Snackbar) -> Void) -> Snackbar {
        stateDidChange = handler
        return self
    }
    
    /// Show the `Snackbar`.
    public func show() {
        SnackbarManager.sharedInstance.enqueue(self)
    }
    
    /// Dismiss the `Snackbar`.
    public func dismiss() {
        SnackbarManager.sharedInstance.dismiss(self, direction: .down)
    }
    
    @objc func dismissOnSwipeDown(_ recognizer: UISwipeGestureRecognizer) {
        SnackbarManager.sharedInstance.dismiss(self, direction: .down)
    }
    
    @objc func dismissOnSwipeLeft(_ recognizer: UISwipeGestureRecognizer) {
        SnackbarManager.sharedInstance.dismiss(self, direction: .left)
    }
    
    @objc func dismissOnSwipeRight(_ recognizer: UISwipeGestureRecognizer) {
        SnackbarManager.sharedInstance.dismiss(self, direction: .right)
    }
}

private final class SnackbarManager {
    
    static let sharedInstance: SnackbarManager = SnackbarManager()
    
    var snackbarContainerView: SnackbarContainerView!
    var stackView: UIStackView!
    var snackbarView: UIView!
    
    private weak var currentSnackbar: Snackbar?
    
    private var dismissSemaphore: DispatchSemaphore
    
    private let queue: OperationQueue
    
    init() {
        queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        dismissSemaphore = DispatchSemaphore(value: 1)
    }
    
    @objc private func actionTriggered(_ actionButton: UIButton) {
        if let snackbar = currentSnackbar, let action = snackbar.action {
            if snackbar.isShown {
                action()
            }
            dismiss(snackbar, direction: .down)
        }
    }
    
    func enqueue(_ snackbar: Snackbar) {
        
        snackbar.state = .queued
        
        var duration = 0.0
        switch snackbar.duration {
        case .indefinite: duration = -1.0
        case .long: duration = 4.0
        case .short: duration = 2.0
        case .time(let snackbarDuration): duration = max(snackbarDuration, 0.0)
        }
        
        let operation = SnackbarAsyncOperation()
        operation.executionBlock = { (finalize) in
            self.show(snackbar) {
                if snackbar.operation != nil {
                    if case .indefinite = snackbar.duration {
                        // Don't do anything.
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(Int(duration * 1000.0))) {
                            self.hide(snackbar, completion: finalize)
                        }
                    }
                } else {
                    self.hide(snackbar, completion: finalize)
                }
            }
        }
        operation.cancelBlock = {
            snackbar.operation = nil
        }
        
        snackbar.operation = operation
        
        queue.addOperation(operation)
    }
    
    func dismiss(_ snackbar: Snackbar, direction: Snackbar.Direction) {
        guard let operation = snackbar.operation else {
            return
        }
        snackbar.operation = nil
        hide(snackbar, direction: direction) {
            operation.cancel()
        }
    }
    
    func show(_ snackbar: Snackbar, completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            self.showOnMain(snackbar, completion: completion)
        }
    }
    
    func showOnMain(_ snackbar: Snackbar, completion: @escaping () -> Void) {
        
        currentSnackbar = snackbar
        snackbar.state = .shown
        
        let inView = snackbar.inView!
        
        snackbarView = createSnackbarView(snackbar: snackbar)
        snackbarContainerView = createSnackbarContainerView(snackbar: snackbar)
        stackView = createStackView()
        
        if let text = snackbar.text {
            let textLabel = createTextLabel(text: text, color: snackbar.textColor)
            stackView.addArrangedSubview(textLabel)
        }
        
        if let actionText = snackbar.actionText {
            let actionButton = createActionButton(text: actionText, color: (snackbar.actionColor ?? inView.tintColor))
            stackView.addArrangedSubview(actionButton)
        }
        
        stackView.frame = snackbarView.bounds.inset(by: UIEdgeInsets.init(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0))
        
        snackbarView.addSubview(stackView)
        snackbarContainerView.addSubview(snackbarView)
        inView.addSubview(snackbarContainerView)
        
        snackbarView.transform = CGAffineTransform(translationX: 0.0, y: snackbar.height)
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] () -> Void in
            self?.snackbarView.transform = CGAffineTransform.identity
            }, completion: { (completed) -> Void in
                completion()
        })
    }
    
    func hide(_ snackbar: Snackbar, direction: Snackbar.Direction = .down, completion: (() -> Void)? = nil) {
        dismissSemaphore.wait()
        guard snackbar.state != .dismissed else {
            dismissSemaphore.signal()
            return
        }
        snackbar.state = .dismissed
        dismissSemaphore.signal()
        
        snackbarView.gestureRecognizers = []
        
        DispatchQueue.main.async {
            let snackbarView: UIView = self.snackbarView
            
            var animationDuration: TimeInterval = 0.4
            var targetAlpha: CGFloat = 1.0
            var xTranslation: CGFloat = 0.0
            var yTranslation: CGFloat = snackbarView.bounds.size.height
            
            switch direction {
            case .up:
                xTranslation = 0.0
                yTranslation = -snackbarView.bounds.size.height
                targetAlpha = 0.0
            case .down:
                xTranslation = 0.0
                yTranslation = snackbarView.bounds.size.height
                animationDuration = 0.2
            case .left:
                xTranslation = -snackbarView.bounds.size.width
                yTranslation = 0.0
                targetAlpha = 0.0
            case .right:
                xTranslation = snackbarView.bounds.size.width
                yTranslation = 0.0
                targetAlpha = 0.0
            }
            
            UIView.animate(withDuration: animationDuration, delay: 0.0, options: .curveEaseInOut, animations: { () -> Void in
                self.snackbarView.transform = CGAffineTransform(translationX: xTranslation, y: yTranslation)
                self.snackbarView.alpha = targetAlpha
                }, completion: { (completed) -> Void in
                    self.snackbarContainerView.removeFromSuperview()
                    self.snackbarView.removeFromSuperview()
                    self.snackbarView.transform = CGAffineTransform(translationX: xTranslation, y: yTranslation)
                    self.stackView.removeFromSuperview()
                    completion?()
                    self.currentSnackbar = nil
            })
        }
    }
    
    private func createGestureRecognizers(target snackbar: Snackbar) -> [UIGestureRecognizer] {
        let downSwipeRecognizer = UISwipeGestureRecognizer(target: snackbar, action: #selector(Snackbar.dismissOnSwipeDown(_:)))
        downSwipeRecognizer.direction = .down
        let leftSwipeRecognizer = UISwipeGestureRecognizer(target: snackbar, action: #selector(Snackbar.dismissOnSwipeLeft(_:)))
        leftSwipeRecognizer.direction = .left
        let rightSwipeRecognizer = UISwipeGestureRecognizer(target: snackbar, action: #selector(Snackbar.dismissOnSwipeRight(_:)))
        rightSwipeRecognizer.direction = .right
        return [downSwipeRecognizer, leftSwipeRecognizer, rightSwipeRecognizer]
    }
    
    private func createStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 2
        stackView.autoresizingMask = .flexibleWidth
        return stackView
    }
    
    private func createSnackbarView(snackbar: Snackbar) -> UIView {
        let snackbarView = UIView()
        snackbarView.backgroundColor = snackbar.backgroundColor
        snackbarView.gestureRecognizers = createGestureRecognizers(target: snackbar)
        snackbarView.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        snackbarView.frame = CGRect(x: 0.0, y: 0.0, width: snackbar.inView!.bounds.width, height: snackbar.height)
        snackbarView.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        snackbarView.transform = CGAffineTransform.identity
        snackbarView.alpha = 1.0
        return snackbarView
    }
    
    private func createSnackbarContainerView(snackbar: Snackbar) -> SnackbarContainerView {
        let snackbarContainerView = SnackbarContainerView()
        if let inView = snackbar.inView {
            snackbarContainerView.frame = CGRect(x: 0.0, y: inView.frame.maxY - snackbar.height - snackbar.offsetFromBottom,
                                                 width: inView.bounds.width, height: snackbar.height)
        }
        return snackbarContainerView
    }
    
    private func createTextLabel(text: String, color: UIColor) -> UILabel {
        let textLabel = UILabel()
        textLabel.numberOfLines = 2
        textLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 500), for: .horizontal)
        textLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 500), for: .horizontal)
        textLabel.text = text
        textLabel.textColor = color
        return textLabel
    }
    
    private func createActionButton(text: String, color: UIColor) -> UIButton {
        let actionButton = UIButton()
        actionButton.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        actionButton.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        actionButton.setTitle(text, for: .normal)
        actionButton.setTitleColor(color, for: .normal)
        actionButton.setTitleColor(color.withAlphaComponent(0.3), for: .highlighted)
        actionButton.addTarget(self, action: #selector(SnackbarManager.actionTriggered(_:)), for: .touchUpInside)
        return actionButton
    }
}

private final class SnackbarContainerView: UIView {
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
        clipsToBounds = true
    }
    
    fileprivate override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return subviews.first?.hitTest(point, with: event)
    }
}

private final class SnackbarAsyncOperation: Operation {
    
    private enum PropertyKey: String {
        case isReady
        case isExecuting
        case isFinished
        case isCancelled
    }
    
    private var operationIsReady: Bool = true
    private var operationIsExecuting: Bool = false
    private var operationIsFinished: Bool = false
    private var operationIsCancelled: Bool = false
    
    override var isReady: Bool { return operationIsReady }
    override var isExecuting: Bool { return operationIsExecuting }
    override var isFinished: Bool { return operationIsFinished }
    override var isCancelled: Bool { return operationIsCancelled }
    override var isConcurrent: Bool { return isAsynchronous }
    override var isAsynchronous: Bool { return true }
    
    /// Implement the asynchronous operation as a closure.
    /// The closure must call the supplied finalize closure.
    var executionBlock: ((_ finalize: @escaping () -> Void) -> Void)?
    
    /// Called when the operation is being cancelled, in between the
    /// KVO willChange and didChange.
    var cancelBlock: (() -> Void)?
    
    override func start() {
        
        willChange(keys: .isReady, .isExecuting)
        operationIsReady = false
        operationIsExecuting = true
        didChange(keys: .isReady, .isExecuting)
        
        guard !isCancelled else {
            willChange(keys: .isCancelled, .isFinished)
            operationIsCancelled = true
            operationIsFinished = true
            didChange(keys: .isCancelled, .isFinished)
            return
        }
        
        if let executionBlock = executionBlock {
            executionBlock { [weak self] in
                self?.finalizeOperation()
            }
        } else {
            finalizeOperation()
        }
    }
    
    override func cancel() {
        guard !isCancelled else {
            return
        }
        if isReady {
            willChange(keys: .isCancelled)
            operationIsCancelled = true
            // Not calling cancelBlock?() because operation didn't start yet.
            didChange(keys: .isCancelled)
        } else {
            guard !isCancelled else {
                return
            }
            willChange(keys: .isCancelled, .isExecuting, .isFinished)
            operationIsCancelled = true
            operationIsExecuting = false
            operationIsFinished = true
            cancelBlock?()
            didChange(keys: .isCancelled, .isExecuting, .isFinished)
        }
    }
    
    func finalizeOperation() {
        guard !isFinished else {
            return
        }
        willChange(keys: .isExecuting, .isFinished)
        operationIsExecuting = false
        operationIsFinished = true
        didChange(keys: .isExecuting, .isFinished)
    }
    
    private func willChange(keys: PropertyKey...) {
        for key in keys {
            willChangeValue(forKey: key.rawValue)
        }
    }
    
    private func didChange(keys: PropertyKey...) {
        for key in keys {
            didChangeValue(forKey: key.rawValue)
        }
    }
}

#endif
