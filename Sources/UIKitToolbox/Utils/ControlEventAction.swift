//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

@MainActor
public class ControlEventAction<Control: UIControl> {

    private weak var control: Control?

    private var event: UIControl.Event

    private var action: (_ control: Control?) -> Void

    public init(control: Control, event: UIControl.Event, action: @escaping (_ sender: Control?) -> Void) {
        self.control = control
        self.event = event
        self.action = action
        control.addTarget(self, action: #selector(eventOccurred(_:)), for: event)
    }

    isolated deinit {
        control?.removeTarget(self, action: #selector(eventOccurred(_:)), for: event)
    }

    @objc func eventOccurred(_ sender: Any?) {
        action(sender as? Control)
    }
}

#endif
