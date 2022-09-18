//
//  Copyright © 2017 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public struct ViewPadding {
    public let top: CGFloat
    public let bottom: CGFloat
    public let leading: CGFloat
    public let trailing: CGFloat
    
    public init(top: CGFloat = 0, bottom: CGFloat = 0, leading: CGFloat = 0, trailing: CGFloat = 0) {
        self.top = top
        self.bottom = bottom
        self.leading = leading
        self.trailing = trailing
    }
}

public extension UIView {
    
    func addSubview(_ view: UIView, constraints: [NSLayoutConstraint]) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate(constraints)
    }
    
    enum SubviewConstraintType {
        case superview
        case safeArea
        case superviewWithTopSafeArea
    }
    
    func addSubview(_ view: UIView, constrainedTo constraintType: SubviewConstraintType) {
        switch constraintType {
        case .superview:
            addSubview(view, constraints: [
                view.topAnchor.constraint(equalTo: topAnchor),
                view.bottomAnchor.constraint(equalTo: bottomAnchor),
                view.leadingAnchor.constraint(equalTo: leadingAnchor),
                view.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        case .safeArea:
            addSubview(view, constraints: [
                view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
            ])
        case .superviewWithTopSafeArea:
            addSubview(view, constraints: [
                view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                view.bottomAnchor.constraint(equalTo: bottomAnchor),
                view.leadingAnchor.constraint(equalTo: leadingAnchor),
                view.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        }
    }
    
    func addSubview(_ view: UIView, constrainedTo constraintType: SubviewConstraintType, padding: CGFloat) {
        switch constraintType {
        case .superview:
            addSubview(view, constraints: [
                view.topAnchor.constraint(equalTo: topAnchor, constant: padding),
                view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
                view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
                view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
            ])
        case .safeArea:
            addSubview(view, constraints: [
                view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
                view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding),
                view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
                view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding)
            ])
        case .superviewWithTopSafeArea:
            addSubview(view, constraints: [
                view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
                view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
                view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
                view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
            ])
        }
    }

    func addSubview(_ view: UIView, constrainedTo constraintType: SubviewConstraintType, padding: ViewPadding) {
        switch constraintType {
        case .superview:
            addSubview(view, constraints: [
                view.topAnchor.constraint(equalTo: topAnchor, constant: padding.top),
                view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom),
                view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding.leading),
                view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding.trailing)
            ])
        case .safeArea:
            addSubview(view, constraints: [
                view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding.top),
                view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding.bottom),
                view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding.leading),
                view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding.trailing)
            ])
        case .superviewWithTopSafeArea:
            addSubview(view, constraints: [
                view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding.top),
                view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom),
                view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding.leading),
                view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding.trailing)
            ])
        }
    }
}


public extension UIView {
    
    func fillToSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            NSLayoutConstraint.activate([
                leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                trailingAnchor.constraint(equalTo: superview.trailingAnchor),
                topAnchor.constraint(equalTo: superview.topAnchor),
                bottomAnchor.constraint(equalTo: superview.bottomAnchor)
            ])
        }
    }
    
}

#endif
