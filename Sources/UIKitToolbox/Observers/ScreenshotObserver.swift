//
//  Copyright © 2015 Apparata AB. All rights reserved.
//

#if os(iOS)

import UIKit

/// The ScreenshotObserver is a convenience object that observes
/// screenshot taken notifications.
public final class ScreenshotObserver {
    
    public var screenshotTaken: (() -> ())?
    
    public init() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(ScreenshotObserver.screenshotTaken(notification:)),
            name: UIApplication.userDidTakeScreenshotNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func screenshotTaken(notification: NSNotification) {
        screenshotTaken?()
    }
}

#endif
