//
//  Copyright © 2018 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public class Form {
    
    public enum Error: Swift.Error {
        case validationFailed(ValidatableFormElement)
        case incorrectValueType
    }
    
    /// Set to `false` if focus should not be shifted back to the first
    /// focusable row when the last focusable row resigns focus.
    /// Default is `false`.
    public var isFocusWrapping: Bool = false
    
    /// If the form is in a scroll view, you can tell the form what
    /// scroll view it is in, for the purpose of scrolling elements into view.
    public weak var scrollView: UIScrollView?
    
    public private(set) var elements: [FormElement]
    
    private let toolbar = FormInputAccessoryToolbar()
    
    private var focusedElement: FocusableFormElement?
    
    public init() {
        elements = []
        toolbar.actionDelegate = self
    }
    
    public func addElement(_ element: FormElement) {
        elements.append(element)
        if let focusableElement = element as? FocusableFormElement {
            focusableElement.didBecomeFocused = { [weak self] element in
                self?.focusedElement = element
                self?.scrollIntoView(element: element)
            }
            
            focusableElement.didResignFocus = { [weak self] element in
                self?.focusOnElement(after: element)
            }
            
            focusableElement.setInputAccessoryToolbar(toolbar)
        }
    }
    
    public func addElements(_ elements: [FormElement]) {
        for element in elements {
            addElement(element)
        }
    }
    
    private func onlyFocusableElements() -> [FocusableFormElement] {
        return elements.compactMap { element in
            element as? FocusableFormElement
            }.filter {
                $0.isFocusable
        }
    }
    
    private func focusOnElement(after element: FocusableFormElement) {
        
        // If element has multiple focus points, attempt to go to next point.
        if let multiFocusableElement = element as? MultiFocusableElement {
            if !multiFocusableElement.isFocusedOnLastPoint {
                multiFocusableElement.focusOnNext()
                return
            }
        }
        
        let focusableElements = onlyFocusableElements()
        
        guard let currentIndex = focusableElements.firstIndex(where: { $0 === element }) else {
            // The element doesn't appear to be in this form at all. Abort.
            return
        }
        
        if !isFocusWrapping, currentIndex + 1 >= focusableElements.count {
            // Reached the end of the focusable elements and as we are not
            // wrapping the focus to the start of the form, we will resign
            // the first responsed and return here.
            focusedElement?.resignFocusSilently()
            focusedElement = nil
            return
        }
        
        let nextIndex = (currentIndex + 1) % focusableElements.count
        
        let nextElement = focusableElements[nextIndex]
        nextElement.becomeFocused()
    }
    
    private func focusOnElement(before element: FocusableFormElement) {
        
        // If multiple focus points, attempt to go to previous point.
        if let multiFocusableElement = element as? MultiFocusableElement {
            if !multiFocusableElement.isFocusedOnFirstPoint {
                multiFocusableElement.focusOnPrevious()
                return
            }
        }
        
        let focusableElements = onlyFocusableElements()
        
        guard let currentIndex = focusableElements.firstIndex(where: { $0 === element }) else {
            // The element doesn't appear to be in this form at all. Abort.
            return
        }
        
        if !isFocusWrapping, currentIndex - 1 < 0 {
            // Reached the start of the focusable elements and as we are not
            // wrapping the focus to the end of the form, we will resign
            // the first responsed and return here.
            focusedElement?.resignFocusSilently()
            focusedElement = nil
            return
        }
        
        let previousIndex: Int
        if currentIndex - 1 < 0 {
            previousIndex = focusableElements.count - 1
        } else {
            previousIndex = currentIndex - 1
        }
        
        let previousElement = focusableElements[previousIndex]
        
        if let multifocusableElement = previousElement as? MultiFocusableElement {
            multifocusableElement.becomeFocusedOnLastFocusPoint()
        } else {
            previousElement.becomeFocused()
        }
    }
    
    private func scrollIntoView(element: FormElement) {
        if let scrollableElement = element as? IntoViewScrollableFormElement,
            scrollableElement.shouldScrollIntoView,
            let view = scrollableElement.viewToScrollIntoView,
            let scrollView = scrollView {
            let rect = view.convert(view.frame, to: scrollView)
            scrollView.scrollRectToVisible(rect, animated: true)
        }
    }
}

extension Form: FormInputAccessoryToolbarDelegate {
    
    public func toolbarDidTapPrevious(_ toolbar: FormInputAccessoryToolbar) {
        
        if let focusedElement = focusedElement {
            focusOnElement(before: focusedElement)
        }
    }
    
    public func toolbarDidTapNext(_ toolbar: FormInputAccessoryToolbar) {
        if let focusedElement = focusedElement {
            focusOnElement(after: focusedElement)
        }
    }
    
    public func toolbarDidTapDone(_ toolbar: FormInputAccessoryToolbar) {
        focusedElement?.resignFocusSilently()
        focusedElement = nil
    }
}

public protocol FormElement: AnyObject {
    
}

public protocol FocusableFormElement: FormElement {
    
    /// The element should call this closure when it becomes 1st responder.
    var didBecomeFocused: ((FocusableFormElement) -> Void)? { get set }
    
    /// The element should call `didResignFocus` when it resigns 1st responder.
    var didResignFocus: ((FocusableFormElement) -> Void)? { get set }
    
    /// The element should return `true` if the element is currently focusable.
    /// Typically, this returns `false` if e.g. a text field is disabled.
    var isFocusable: Bool { get }
    
    /// The element should try to become first responder when this
    /// method is called by `Form`.
    func becomeFocused()
    
    /// When this method is called by `Form`, the element should
    /// resign as first responder, without calling `didResignFocus`.
    func resignFocusSilently()
    
    /// Called by `Form` to set an input accessory toolbar for the element.
    func setInputAccessoryToolbar(_ toolbar: UIToolbar)
}

public protocol IntoViewScrollableFormElement: FormElement {
    
    /// Called by `Form` to determine if element should be scrolled into view.
    var shouldScrollIntoView: Bool { get }
    
    /// Called by `Form` to determine the frame to scroll into view.
    var viewToScrollIntoView: UIView? { get }
}

public protocol ValidatableFormElement: FormElement {
    
    /// The `isValid` variable is `true` if the element state is valid.
    var isValid: Bool { get }
    
    /// The `isMandatory` variable is `true` the element is mandatory.
    var isMandatory: Bool { get }
    
    func validatedValue<ValueType>() throws -> ValueType
}

public protocol MultiFocusableElement: FocusableFormElement {
    
    /// Is the focus on the first focus point?
    var isFocusedOnFirstPoint: Bool { get }
    
    /// Is the focus on the last focus point?
    var isFocusedOnLastPoint: Bool { get }
    
    /// Same as `becomeFocused` except that the element should focus on
    /// the last focus point instead of the first.
    func becomeFocusedOnLastFocusPoint()
    
    /// Called by `StaticTable` to shift focus to the next focus point.
    func focusOnNext()
    
    /// Called by `StaticTable` to shift focus to the previous focus point.
    func focusOnPrevious()
}

#endif
