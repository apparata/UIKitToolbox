//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import UIKit

// MARK: - Alert

/// The `Alert` class wraps `UIAlertController` for less boilerplate.
///
/// Examples:
///
/// ```
/// Alert(title: "Hello!", message: "This is an alert.") {
///     AlertAction("OK") {
///         // ... Do something here ...
///     }
///     CancelAction("Cancel", tint: .black) {
///         // ... Do something here ...
///     }
/// }
/// .present(from: self)
/// ```
///
/// ```
/// Alert(title: "Hello!", message: "This is an alert.") {
///     OKAction {
///         // ... Do something here ...
///     }
///     CancelAction {
///         // ... Do something here ...
///     }
/// }
/// .present(from: self)
/// ```
public class Alert: AbstractAlert {
    public init(
        title: String? = nil,
        message: String? = nil,
        @AlertBuilder _ alertActions: () -> [AbstractAlertAction]
    ) {
        super.init(title: title, message: message, style: .alert, alertActions)
    }
}

// MARK: - Action Sheet

/// The `ActionSheet` class wraps `UIAlertController` for less boilerplate.
///
/// Example:
///
/// ```
/// ActionSheet(title: "Hello!", message: "This is an action sheet.") {
///     SheetAction("Whatever") {
///         // ... Do something here ...
///     }
///     SheetAction("Stuff") {
///         // ... Do something here ...
///     }
///     if isDeletable {
///         DestructiveAction("Delete") {
///             // ... Do something here ...
///         }
///     }
///     CancelAction("Cancel", tint: .black) {
///         // ... Do something here ...
///     }
/// }
/// .present(from: self)
/// ```
public class ActionSheet: AbstractAlert {
    public init(
        title: String? = nil,
        message: String? = nil,
        @AlertBuilder _ alertActions: () -> [AbstractAlertAction]
    ) {
        super.init(title: title, message: message, style: .actionSheet, alertActions)
    }
}

// MARK: - Abstract Alert

public class AbstractAlert {
    
    public let alertController: UIAlertController
    
    init(title: String? = nil,
         message: String? = nil,
         style: UIAlertController.Style,
         @AlertBuilder _ alertActions: () -> [AbstractAlertAction]) {
        alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: style)
        let actions = alertActions()
        for action in actions {
            let alertAction = UIAlertAction(title: action.title,
                                            style: action.style) { _ in
                action.action()
            }
            if let tint = action.tint {
                alertAction.setValue(tint, forKey: "titleTextColor")
            }
            alertController.addAction(alertAction)
        }
    }
    
    public func tintColor(_ color: UIColor) -> Self {
        alertController.view.tintColor = color
        return self
    }
    
    public func present(from viewController: UIViewController?) {
        guard let viewController = viewController else {
            return
        }
        
        if !Thread.isMainThread {
            DispatchQueue.main.async { [alertController] in
                viewController.present(alertController, animated: true, completion: nil)
            }
        } else {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: - Actions

public protocol AbstractAlertAction {
    var title: String { get }
    var style: UIAlertAction.Style { get }
    var tint: UIColor? { get }
    var action: () -> Void { get }
}

// MARK: Alert Action

public struct AlertAction: AbstractAlertAction {
    public let title: String
    public let style: UIAlertAction.Style
    public let tint: UIColor?
    public let action: () -> Void
    
    public init(_ title: String, tint: UIColor? = nil, _ action: @escaping () -> Void) {
        self.title = title
        self.style = .default
        self.tint = tint
        self.action = action
    }
}

// MARK: Sheet Action

public struct SheetAction: AbstractAlertAction {
    public let title: String
    public let style: UIAlertAction.Style
    public let tint: UIColor?
    public let action: () -> Void
    
    public init(_ title: String, tint: UIColor? = nil, _ action: @escaping () -> Void) {
        self.title = title
        self.style = .default
        self.tint = tint
        self.action = action
    }
}

// MARK: OK Action

public struct OKAction: AbstractAlertAction {
    public let title: String
    public let style: UIAlertAction.Style
    public let tint: UIColor?
    public let action: () -> Void
    
    public init(_ title: String = "OK", tint: UIColor? = nil, _ action: @escaping () -> Void) {
        self.title = title
        self.style = .default
        self.tint = tint
        self.action = action
    }
}

// MARK: Destructive Action

public struct DestructiveAction: AbstractAlertAction {
    public let title: String
    public let style: UIAlertAction.Style
    public let tint: UIColor?
    public let action: () -> Void
    
    public init(_ title: String, tint: UIColor? = nil, _ action: @escaping () -> Void) {
        self.title = title
        self.style = .destructive
        self.tint = tint
        self.action = action
    }
}

// MARK: Cancel Action

public struct CancelAction: AbstractAlertAction {
    public let title: String
    public let style: UIAlertAction.Style
    public let tint: UIColor?
    public let action: () -> Void
    
    public init(_ title: String = "Cancel", tint: UIColor? = nil, _ action: @escaping () -> Void) {
        self.title = title
        self.style = .cancel
        self.tint = tint
        self.action = action
    }
}

// MARK: - Alert Result Builder

@resultBuilder
public struct AlertBuilder {
    
    typealias Expression = AbstractAlertAction
    typealias Component = [AbstractAlertAction]
    
    static func buildExpression(_ expression: Expression) -> Component {
        return [expression]
    }
    
    static func buildBlock(_ children: Component...) -> Component {
        return children.flatMap { $0 }
    }
    
    static func buildIf(_ component: Component?) -> Component {
        return component ?? []
    }
    
    static func buildEither(first component: Component) -> Component {
        return component
    }

    static func buildEither(second component: Component) -> Component {
        return component
    }
    
    static func buildArray(_ components: [Component]) -> Component {
        return components.flatMap { $0 }
    }
}
