//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

#if canImport(UIKit) && os(iOS)

import UIKit

public class ViewAboveKeyboardMover {

    private let keyboardObserver = KeyboardObserver()

    public weak var view: UIView?

    public init(view: UIView? = nil) {
        self.view = view
        setUpKeyboardObserver()
    }

    // Move textfield above keyboard when keyboard is shown.
    private func setUpKeyboardObserver() {
        keyboardObserver.keyboardWillShow = { [weak self] size in
            guard let view = self?.view else {
                return
            }
            let viewLowerEdgeY = view.frame.origin.y + view.frame.size.height
            let heightAboveKeyboard = UIScreen.main.bounds.size.height - size.height
            let viewOffset = min(0, heightAboveKeyboard - viewLowerEdgeY)
            ViewAnimation(duration: 0.4).easeInOut().animations {
                view.transform = CGAffineTransform(translationX: 0.0, y: viewOffset)
                }.start()
        }

        keyboardObserver.keyboardWillHide = { [weak self] in
            guard let view = self?.view else {
                return
            }
            ViewAnimation(duration: 0.4).easeInOut().animations {
                view.transform = .identity
                }.start()
        }
    }
}

#endif
