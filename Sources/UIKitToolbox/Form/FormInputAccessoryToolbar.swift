//
//  Copyright © 2018 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public protocol FormInputAccessoryToolbarDelegate: class {
    func toolbarDidTapPrevious(_ toolbar: FormInputAccessoryToolbar)
    func toolbarDidTapNext(_ toolbar: FormInputAccessoryToolbar)
    func toolbarDidTapDone(_ toolbar: FormInputAccessoryToolbar)
}

public class FormInputAccessoryToolbar: UIToolbar {
    
    public weak var actionDelegate: FormInputAccessoryToolbarDelegate?
    
    public private(set) var previousButton: UIBarButtonItem!
    
    public private(set) var nextButton: UIBarButtonItem!
    
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 1, height: 44))
        setUp()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func setUp() {
        previousButton = UIBarButtonItem(title: "⬆︎",
                                         style: .plain,
                                         target: self,
                                         action: #selector(previousButtonAction))
        
        nextButton = UIBarButtonItem(title: "⬇︎",
                                     style: .plain,
                                     target: self,
                                     action: #selector(nextButtonAction))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonAction))
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let trailingSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        
        items = [previousButton, nextButton, space, doneButton, trailingSpace]
    }
    
    @objc private func previousButtonAction(_ item: UIBarButtonItem) {
        actionDelegate?.toolbarDidTapPrevious(self)
    }
    
    @objc private func nextButtonAction(_ item: UIBarButtonItem) {
        actionDelegate?.toolbarDidTapNext(self)
    }
    
    @objc private func doneButtonAction(_ item: UIBarButtonItem) {
        actionDelegate?.toolbarDidTapDone(self)
    }
    
}

#endif
