//
//  UIApplication+OpenURL.swift
//  ImageWalkTracker
//
//  Created by Valentina Iancu on 12.02.2023.
//

import UIKit

extension UIApplication {
    static func openSettings() {
        if let aString = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(aString, options: [:], completionHandler: nil)
        }
    }
}
