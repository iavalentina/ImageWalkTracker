//
//  LocationPermissionsPresenter.swift
//  ImageWalkTracker
//
//  Created by Valentina Iancu on 12.02.2023.
//

import UIKit

protocol LocationPermissionsPresenter {
    func displayGetLocationPermissionaAlert()
}

extension LocationPermissionsPresenter where Self: UIViewController {
    func displayGetLocationPermissionaAlert() {
        let alert = UIAlertController(title: "Location Permission Access",
                                      message: "In order to track your activity you need to enable location permissions",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Open app settings", style: .default) { _ in
            UIApplication.openSettings()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}
