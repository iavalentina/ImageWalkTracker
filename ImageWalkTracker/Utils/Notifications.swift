//
//  Notifications.swift
//  ImageWalkTracker
//
//  Created by Valentina Iancu on 12.02.2023.
//

import Foundation

struct Notifications {
    enum Location: String, NotificationName {
        /// Location tracking permission change.
        case authorizationChanged
        case locationUpdated
    }
}
