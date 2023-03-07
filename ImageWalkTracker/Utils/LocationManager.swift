//
//  LocationManager.swift
//  ImageWalkTracker
//
//  Created by Valentina Iancu on 12.02.2023.
//

import CoreLocation
import Foundation
import UIKit

enum LocationManagerAuthorizationStatus: String {
    case unknown
    case noAccess
    case notDetermined
    case whenInUse
    case always
}

class LocationManager: NSObject, CLLocationManagerDelegate {

    static let shared = LocationManager()

    private let locationManager = CLLocationManager()
    var currentLocation: CLLocation? {
        didSet {
            NotificationCenter.default.post(name: Notifications.Location.locationUpdated.name, object: nil)
        }
    }

    var isLocationGranted: Bool {
        return currentAuthorizationStatus == .always || currentAuthorizationStatus == .whenInUse
    }

    lazy var currentAuthorizationStatus: LocationManagerAuthorizationStatus = {
        return authorizationStatus(from: locationManager.authorizationStatus)
    }()
    
    override private init() {
        super.init()
    }

    func initialize() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.activityType = .fitness
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.showsBackgroundLocationIndicator = true
        locationManager.distanceFilter = CLLocationDistance(100.0)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }

    func startLocating() {
        locationManager.startUpdatingLocation()
    }

    func stopLocating() {
        locationManager.stopUpdatingLocation()
    }

    func requestUserLocationPermission() {
        if !isLocationGranted {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        updateAuthorizationStatus()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       print("Location manager did fail with error: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last, location != currentLocation else {
            return
        }

        currentLocation = location
    }

    // MARK: - Private methods

    private func updateAuthorizationStatus() {
        let newAuthorizationStatus = authorizationStatus(from: locationManager.authorizationStatus)
   
        if newAuthorizationStatus != currentAuthorizationStatus {
            currentAuthorizationStatus = newAuthorizationStatus

            NotificationCenter.default.post(name: Notifications.Location.authorizationChanged.name,
                                            object: currentAuthorizationStatus.rawValue)
        }
    }

    // MARK: - Notifications

    @objc func willEnterForeground() {
        locationManager.delegate = self

        if !isLocationGranted {
            stopLocating()
        }

        updateAuthorizationStatus()
    }

    private func authorizationStatus(from status: CLAuthorizationStatus) -> LocationManagerAuthorizationStatus {
        switch status {
        case .notDetermined:
            // Request when-in-use authorization initially
            return .notDetermined
        case .restricted, .denied:
            // Disable location features
            return .noAccess
        case .authorizedWhenInUse:
            // Enable basic location features
            return .always
        case .authorizedAlways:
            return .always
        @unknown default:
            return .unknown
        }
    }
}
