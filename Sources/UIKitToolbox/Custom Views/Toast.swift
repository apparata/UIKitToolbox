//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

/// Android-like `Toast` that slides into the view for a period of time.
/// Sometimes it only contains a message, sometimes it contains an action.
/// The message label may show one or two lines of text.
public final class Toast {
    
    fileprivate enum Direction {
        case up
        case down
        case left
        case right
    }
    
    /// How long the `Toast` stays on screen.
    public enum Duration {
        case indefinite
        case long
        case short
        case time(interval: TimeInterval)
    }
    
    /// Display state of the `Toast`.
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
    
    /// The text message shown in the `Toast`.
    public var text: String?
    
    /// The color of the text message shown in the `Toast`.
    /// Defaults to white.
    public var textColor: UIColor = UIColor.white
    
    /// `Toast` background color. Defaults to dark grey.
    public var backgroundColor: UIColor = UIColor(white: 0.2, alpha: 1.0)
    
    /// Show an activity indicator. Default is false.
    public var showActivityIndicator: Bool = false
    
    public typealias ActionHandler = () -> Void
    
    /// Closure to run if the toast is tapped.
    public var action: ActionHandler?
    
    /// Vertical offset of `Toast` view from the bottom of the screen.
    public var offsetFromTop: CGFloat = 4.0
    
    /// Height of the `Toast`. Defaults to 64 points.
    public var height: CGFloat = 40.0
    
    /// True for spring animation and false for regular. Spring by default.
    public var springAnimation: Bool = true
    
    public typealias StateChangeHandler = (Toast) -> Void
    
    /// Called when the state changes.
    public var stateDidChange: StateChangeHandler?
    
    /// How long the `Toast` stays on screen.
    public let duration: Duration
    
    /// The superview of the `Toast`.
    public private(set) weak var inView: UIView?
    
    fileprivate weak var operation: ToastAsyncOperation?
    
    /// Current display state of the `Toast`.
    public internal(set) var state: State = .ready {
        didSet {
            stateDidChange?(self)
        }
    }
    
    /// `Toast` will be shown in a view.
    public init(inView: UIView, text: String, duration: Duration) {
        self.text = text
        self.inView = inView
        self.duration = duration
    }
    
    /// `Toast` will be shown in a view.
    public convenience init(inView: UIView, text: String, duration: TimeInterval) {
        self.init(inView: inView, text: text, duration: Duration.time(interval: duration))
    }
    
    
    /// `Toast` will be shown in a view.
    public init(inView: UIView, duration: Duration) {
        self.inView = inView
        self.duration = duration
    }
    
    /// `Toast` will be shown in a view.
    public convenience init(inView: UIView, duration: TimeInterval) {
        self.init(inView: inView, duration: .time(interval: duration))
    }
    
    /// Update the `Toast` text.
    public func text(_ text: String) -> Toast {
        self.text = text
        return self
    }
    
    /// Set the action to be displayed in the `Toast`.
    public func action(_ action: @escaping ActionHandler) -> Toast {
        self.action = action
        return self
    }
    
    /// Set the `Toast` colors. `nil` indicates the default color.
    public func color(_ background: UIColor? = nil, text: UIColor? = nil) -> Toast {
        backgroundColor = background ?? UIColor(white: 0.2, alpha: 1.0)
        textColor = text ?? textColor
        return self
    }
    
    /// Set vertical offset of `Toast` view from the top of the view.
    public func offset(fromTop offset: CGFloat) -> Toast {
        offsetFromTop = offset
        return self
    }
    
    /// Set whether an activity indicator should be included or not.
    public func activityIndicator(_ show: Bool = true) -> Toast {
        self.showActivityIndicator = show
        return self
    }
    
    /// Set a state change handler closure.
    public func stateDidChange(handler: @escaping StateChangeHandler) -> Toast {
        stateDidChange = handler
        return self
    }
    
    /// Show the `Toast`.
    public func show() {
        ToastManager.sharedInstance.enqueue(self)
    }
    
    /// Show the `Toast` immediately, flushing all other toasts
    /// ahead in the queue.
    public func showImmediately() {
        ToastManager.sharedInstance.enqueueImmediately(self)
    }
    
    /// Dismiss the `Toast`.
    public func dismiss() {
        ToastManager.sharedInstance.dismiss(self, direction: .up)
    }
    
    @objc func dismissOnSwipeUp(_ recognizer: UISwipeGestureRecognizer) {
        ToastManager.sharedInstance.dismiss(self, direction: .up)
    }
    
    @objc func dismissOnSwipeLeft(_ recognizer: UISwipeGestureRecognizer) {
        ToastManager.sharedInstance.dismiss(self, direction: .left)
    }
    
    @objc func dismissOnSwipeRight(_ recognizer: UISwipeGestureRecognizer) {
        ToastManager.sharedInstance.dismiss(self, direction: .right)
    }
    
    @objc func tapped(_ recognizer: UITapGestureRecognizer) {
        if isShown {
            action?()
        }
        dismiss()
    }
}

private final class ToastManager {
    
    static let sharedInstance: ToastManager = ToastManager()
    
    var toastContainerView: ToastContainerView!
    var stackView: UIStackView!
    var toastView: UIView!
    
    private weak var currentToast: Toast?
    
    private var dismissSemaphore: DispatchSemaphore
    
    private let queue: OperationQueue
    
    init() {
        queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        dismissSemaphore = DispatchSemaphore(value: 1)
    }
    
    func enqueue(_ toast: Toast) {
        
        toast.state = .queued
        
        var duration = 0.0
        switch toast.duration {
        case .indefinite: duration = -1.0
        case .long: duration = 4.0
        case .short: duration = 2.0
        case .time(let toastDuration): duration = max(toastDuration, 0.0)
        }
        
        let operation = ToastAsyncOperation(toast: toast)
        operation.executionBlock = { (finalize) in
            guard toast.state == .queued else {
                finalize()
                return
            }
            self.show(toast) {
                if toast.operation != nil {
                    if case .indefinite = toast.duration {
                        // Don't do anything.
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(Int(duration * 1000.0))) {
                            self.hide(toast, completion: finalize)
                        }
                    }
                } else {
                    self.hide(toast, completion: finalize)
                }
            }
        }
        operation.cancelBlock = {
            toast.operation = nil
            if toast.state == .shown {
                self.hide(toast, completion: nil)
            }
        }
        
        toast.operation = operation
        
        queue.addOperation(operation)
    }
    
    func enqueueImmediately(_ toast: Toast) {
        for operation in queue.operations {
            if let operation = operation as? ToastAsyncOperation,
                let toast = operation.toast {
                
                if toast.state != .shown {
                    toast.state = .dismissed
                    operation.cancel()
                } else {
                    toast.dismiss()
                }
            }
        }
        enqueue(toast)
    }
    
    func dismiss(_ toast: Toast, direction: Toast.Direction) {
        guard let operation = toast.operation else {
            return
        }
        toast.operation = nil
        hide(toast, direction: direction) {
            operation.cancel()
        }
    }
    
    func show(_ toast: Toast, completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            self.showOnMain(toast, completion: completion)
        }
    }
    
    func showOnMain(_ toast: Toast, completion: @escaping () -> Void) {
        
        currentToast = toast
        toast.state = .shown
        
        let inView = toast.inView!
        
        toastView = createToastView(toast: toast)
        toastContainerView = createToastContainerView(toast: toast)
        stackView = createStackView()
        
        var width: CGFloat = 0
        
        if let text = toast.text {
            let textLabel = createTextLabel(text: text, color: toast.textColor)
            textLabel.isUserInteractionEnabled = false
            stackView.addArrangedSubview(textLabel)
            width = textLabel.intrinsicContentSize.width
        }
        
        if toast.showActivityIndicator {
            let activityIndicator = UIActivityIndicatorView()
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            stackView.addArrangedSubview(activityIndicator)
            stackView.spacing += 4.0
            width += activityIndicator.intrinsicContentSize.width
        }
        
        toastView.frame.size.width = width + toast.height
        stackView.frame = toastView.bounds.inset(by: UIEdgeInsets.init(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0))
        
        toastView.addSubview(stackView)
        toastContainerView.addSubview(toastView)
        inView.addSubview(toastContainerView)
        
        toastView.center.x = toastContainerView.bounds.size.width / 2.0
        
        toastView.transform = CGAffineTransform(translationX: 0.0, y: -toast.height)
        
        if toast.springAnimation {
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: { [weak self] in
                self?.toastView.transform = CGAffineTransform.identity
            }) { (completed) in
                completion()
            }
        } else {
            UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
                self?.toastView.transform = CGAffineTransform.identity
                }, completion: { (completed) in
                    completion()
            })
        }
    }
    
    func hide(_ toast: Toast, direction: Toast.Direction = .up, completion: (() -> Void)? = nil) {
        dismissSemaphore.wait()
        guard toast.state != .dismissed else {
            dismissSemaphore.signal()
            return
        }
        toast.state = .dismissed
        dismissSemaphore.signal()
        
        toastView.gestureRecognizers = []
        
        DispatchQueue.main.async {
            let toastView: UIView = self.toastView
            
            var animationDuration: TimeInterval = 0.4
            var targetAlpha: CGFloat = 1.0
            var xTranslation: CGFloat = 0.0
            var yTranslation: CGFloat = -toastView.bounds.size.height
            
            switch direction {
            case .up:
                xTranslation = 0.0
                yTranslation = -toastView.bounds.size.height
                targetAlpha = 0.0
            case .down:
                xTranslation = 0.0
                yTranslation = toastView.bounds.size.height
                animationDuration = 0.2
            case .left:
                xTranslation = -toastView.bounds.size.width
                yTranslation = 0.0
                targetAlpha = 0.0
            case .right:
                xTranslation = toastView.bounds.size.width
                yTranslation = 0.0
                targetAlpha = 0.0
            }
            
            UIView.animate(withDuration: animationDuration, delay: 0.0, options: .curveEaseInOut, animations: { () -> Void in
                self.toastView.transform = CGAffineTransform(translationX: xTranslation, y: yTranslation)
                self.toastView.alpha = targetAlpha
                }, completion: { (completed) -> Void in
                    self.toastContainerView.removeFromSuperview()
                    self.toastView.removeFromSuperview()
                    self.toastView.transform = CGAffineTransform(translationX: xTranslation, y: yTranslation)
                    self.stackView.removeFromSuperview()
                    completion?()
                    self.currentToast = nil
            })
        }
    }
    
    private func createGestureRecognizers(target toast: Toast) -> [UIGestureRecognizer] {
        let upSwipeRecognizer = UISwipeGestureRecognizer(target: toast, action: #selector(Toast.dismissOnSwipeUp(_:)))
        upSwipeRecognizer.direction = .up
        var recognizers: [UIGestureRecognizer] = [upSwipeRecognizer]
        if toast.action != nil {
            let tapRecognizer = UITapGestureRecognizer(target: toast, action: #selector(Toast.tapped(_:)))
            recognizers.append(tapRecognizer)
        }
        return recognizers
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
    
    private func createToastView(toast: Toast) -> UIView {
        let toastView = UIView()
        toastView.isUserInteractionEnabled = true
        toastView.backgroundColor = toast.backgroundColor
        toastView.gestureRecognizers = createGestureRecognizers(target: toast)
        toastView.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        toastView.frame = CGRect(x: 0.0, y: 8.0, width: toast.inView!.bounds.width, height: toast.height)
        toastView.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        toastView.transform = CGAffineTransform.identity
        toastView.alpha = 1.0
        toastView.layer.cornerRadius = toast.height / 2.0
        return toastView
    }
    
    private func createToastContainerView(toast: Toast) -> ToastContainerView {
        let toastContainerView = ToastContainerView()
        if let inView = toast.inView {
            toastContainerView.frame = CGRect(x: 0.0, y: toast.offsetFromTop,
                                              width: inView.bounds.width, height: toast.height + 18.0)
        }
        return toastContainerView
    }
    
    private func createTextLabel(text: String, color: UIColor) -> UILabel {
        let textLabel = UILabel()
        textLabel.numberOfLines = 1
        textLabel.textAlignment = .center
        textLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 500), for: .horizontal)
        textLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 500), for: .horizontal)
        textLabel.text = text
        textLabel.textColor = color
        return textLabel
    }
    
}

private final class ToastContainerView: UIView {
    
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
    
}

private final class ToastAsyncOperation: Operation {
    
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
    
    weak var toast: Toast?
    
    init(toast: Toast) {
        super.init()
        self.toast = toast
    }
    
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
