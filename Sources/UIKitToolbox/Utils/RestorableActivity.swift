//
//  Copyright © 2017 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

// https://videos.raywenderlich.com/courses/introducing-ios-9-search-apis/lessons/4

public typealias RestorableActivity = String

public protocol RestorableActivityHandler {
    
    /// Set of activities the implementing class can handle.
    var restorableActivities: Set<RestorableActivity> { get }
    
    func restore(activity: RestorableActivity, context: Any)
}

public protocol RestorableActivityHandlerContainer: RestorableActivityHandler {
    
    func primaryRestorableActivityHandler(for activity: RestorableActivity) -> UIResponder?
    
}

public extension RestorableActivityHandlerContainer where Self: UIViewController {
    
    var restorableActivites: Set<RestorableActivity> {
        var activities = Set<RestorableActivity>()
        for viewController in children {
            if let handler = viewController as? RestorableActivityHandler {
                activities = activities.union(handler.restorableActivities)
            }
        }
        return activities
    }
    
    func primaryRestorableActivityHandler(for activity: RestorableActivity) -> UIResponder? {
        let handlers = children.reversed().filter { viewController in
            guard let viewController = viewController as? RestorableActivityHandler else {
                return false
            }
            return viewController.restorableActivities.contains(activity)
        }
        return handlers.first
    }
}

#endif
