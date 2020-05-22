//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

/// Observes changes to the general pasteboard.
public final class PasteboardObserver {
    
    public typealias PasteboardChangedHandler = ((NSNotification) -> Void)
    
    public var didChange: PasteboardChangedHandler?
    
    public init(didChange: PasteboardChangedHandler? = nil) {
        self.didChange = didChange
        addObserver(notificationName: UIPasteboard.changedNotification)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func addObserver(notificationName: Notification.Name) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(PasteboardObserver.notificationObserved(notification:)), name: notificationName, object: nil)
    }
    
    @objc private func notificationObserved(notification: NSNotification) {
        didChange?(notification)
    }
}

#endif
