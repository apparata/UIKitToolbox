//
//  Copyright © 2017 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public final class OrientationChangeObserver {
    
    public typealias OrientationChangedHandler = (UIDeviceOrientation) -> Void
    
    public var didChange: OrientationChangedHandler?
    
    public init(didChange: OrientationChangedHandler? = nil) {
        self.didChange = didChange
        addObserver(notificationName: UIDevice.orientationDidChangeNotification)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        endGeneratingNotifications()
    }
    
    public func startGeneratingNotifications() {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
    }
    
    public func endGeneratingNotifications() {
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
    
    private func addObserver(notificationName: Notification.Name) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(OrientationChangeObserver.notificationObserved(notification:)), name: notificationName, object: nil)
    }
    
    @objc private func notificationObserved(notification: NSNotification) {
        didChange?(UIDevice.current.orientation)
    }
}

#endif
