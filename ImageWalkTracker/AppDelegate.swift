//
//  AppDelegate.swift
//  ImageWalkTracker
//
//  Created by Valentina Iancu on 12.02.2023.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white
        let imageListViewController = ActivityPhotoListViewController()
        let navigationBarController = NavigationBarController(embeddedViewController: imageListViewController)
        window?.rootViewController = navigationBarController
        
        LocationManager.shared.initialize()
        
        return true
    }
}

