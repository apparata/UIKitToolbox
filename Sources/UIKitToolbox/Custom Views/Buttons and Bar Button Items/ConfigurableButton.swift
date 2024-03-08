//
//  Copyright © 2017 Apparata AB. All rights reserved.
//

#if canImport(UIKit) && os(iOS)

import UIKit

open class ConfigurableButton: UIButton {
    
    open var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            updateVisualState()
        }
    }
    
    open var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
            updateVisualState()
        }
    }
    
    open var borderColor: UIColor? = .clear {
        didSet {
            layer.borderColor = borderColor?.cgColor
            updateVisualState()
        }
    }
    
    open override var isHighlighted: Bool {
        didSet {
            updateVisualState()
        }
    }
    
    open override var isEnabled: Bool {
        didSet {
            updateVisualState()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        updateVisualState()
    }
    
    public init() {
        super.init(frame: .zero)
        updateVisualState()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateVisualState()
    }
    
    public func updateVisualState() {
        layer.masksToBounds = cornerRadius > 0
        switch (isEnabled, isHighlighted) {
        case (true, false):
            backgroundColor = backgroundColor?.alpha(1)
            alpha = 1
        case (true, true):
            backgroundColor = backgroundColor?.alpha(0.5)
            alpha = 1
        case (false, _):
            backgroundColor = backgroundColor?.alpha(1)
            alpha = 0.3
        }
    }
}

#endif
