//
//  ImageListViewController.swift
//  ImageWalkTracker
//
//  Created by Valentina Iancu on 12.02.2023.
//

import CoreLocation
import UIKit

enum ActionRightButtonStyle {
    case start
    case stop
}

class ActivityPhotoListViewController: UIViewController, UINavigationBarDelegate, LocationPermissionsPresenter {

    @IBOutlet private weak var tableView: UITableView!
    
    private var currentAuthorizationStatus = LocationManager.shared.currentAuthorizationStatus
    private var currentRightActionButtonStyle: ActionRightButtonStyle = .start
    
    private var savedPhotoPaths = [TableCell]()
    private var activityStarted: Bool = false
    
    private lazy var tableDataSource = PhotosDataSource(tableView: tableView) { [weak self] tableView, indexPath, itemIdentifier in
        guard let self = self else { return UITableViewCell() }

        switch itemIdentifier {
        case .photo(let index, let diskLocationPath):
            let cell = tableView.dequeueReusableCell() as PhotoTableCell
            cell.tag = index
            cell.set(PhotoManager.shared.loadFromDisk(from: diskLocationPath))
            return cell
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        setupRightActionButton(style: .start)
        configureTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadPhotos()
    }
    
    private func fetchPhoto(for location: CLLocation) {
        let lat = String(format:"%f", location.coordinate.latitude)
        let long = String(format:"%f", location.coordinate.longitude)
        let geoLocationParameters = ["lat": lat, "lon": long]
        let flickerPhotosURL = FlickerAPIServices.photosSearchURL(extraParameters: geoLocationParameters)
        APIServices.shared.fetchPhotos(from: flickerPhotosURL) { [weak self] photoResult in
            
            switch photoResult {
            case let .success(photos):
                guard !photos.isEmpty else { return }
                for (_, photo) in photos.enumerated() {
                    if !PhotoManager.shared.checkIfSaved(name: photo.id) {
                        self?.downloadPhoto(from: photo)
                        break
                    }
                }
                
            case let .failure(error):
                print("Error fetching photos: \(error)")
                self?.reloadTableData(animated: true)
            }
        }
    }
    
    private func downloadPhoto(from photo: Photo) {
        Task { @MainActor in
            if let image = await UIImage(url: ActivityPhotoListFormatter.photoURL(from: photo)) {
                PhotoManager.shared.saveToDisk(name: photo.id, image: image)
                if UIApplication.shared.applicationState == .active {
                    loadPhotos()
                }
            }
        }
    }

    private func addObservers() {

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive(_:)),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willEnterForeground(_:)),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }
    
    private func addLocationObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(locationDidChange),
                                               name: Notifications.Location.locationUpdated.name, object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(locationAuthorizationChanged(_:)),
                                               name:  Notifications.Location.authorizationChanged.name,
                                               object: nil)
        
    }
    
    private func removeLocationObservers() {
        NotificationCenter.default.removeObserver(self, name: Notifications.Location.locationUpdated.name, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notifications.Location.authorizationChanged.name, object: nil)
    }
    
    // MARK: - UI configuration

    private func configureTable() {
        tableView.delegate = self

        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.allowsSelection = false

        tableView.register(PhotoTableCell.self)
    }
    
    private func setupRightActionButton(style: ActionRightButtonStyle) {
        switch style {
        case .start:
            let startButtonItem = UIBarButtonItem(title: "Start",
                                                  style: .plain,
                                                  target: nil,
                                                  action: nil)
            startButtonItem.target = self
            startButtonItem.action = #selector(didSelectStartButton)
            navigationItem.rightBarButtonItem = startButtonItem
           
        case .stop:
            let stopButtonItem = UIBarButtonItem(title: "Stop",
                                                  style: .plain,
                                                  target: nil,
                                                  action: nil)
            stopButtonItem.target = self
            stopButtonItem.action = #selector(didSelectStopButton)
            navigationItem.rightBarButtonItem = stopButtonItem
        }
    }

    // MARK: - Actions

    @objc func didSelectStartButton() {
        addLocationObservers()
        activityStarted = true
        requestLocationAuthorizationIfNeeded()
        setupRightActionButton(style: .stop)
    }
    
    @objc func didSelectStopButton() {
        activityStarted = false
        setupRightActionButton(style: .start)
        
        removeLocationObservers()
        LocationManager.shared.stopLocating()
    }
    
    // MARK: - Notification center
    
    @objc func applicationDidBecomeActive(_ notification: Notification) {
        // let your app know that it moved from the inactive to active state
        if LocationManager.shared.isLocationGranted {
            currentAuthorizationStatus = LocationManager.shared.currentAuthorizationStatus
            if activityStarted {
                LocationManager.shared.startLocating()
            }
        } else {
            if activityStarted {
                activityStarted = false
                setupRightActionButton(style: .start)
            }
        }
    }
    
    @objc func willEnterForeground(_ notification: Notification) {
        loadPhotos()
    }

    private func loadPhotos() {
        let photos = PhotoManager.shared.getAllSavedPhotoPaths()
        savedPhotoPaths = photos.enumerated().map(TableCell.photo)
        reloadTableData(animated: true)
    }
    
    @objc func locationDidChange() {
        if let currentLocation = LocationManager.shared.currentLocation {
            fetchPhoto(for: currentLocation)
        }
    }
    
    @objc func locationAuthorizationChanged(_ notification: Notification) {
        let notificationObject = notification.object as? String ?? ""
        currentAuthorizationStatus = LocationManagerAuthorizationStatus(rawValue: notificationObject) ?? .unknown
    }
    
    // MARK: - Location logic
        
    private func requestLocationAuthorizationIfNeeded() {
        guard currentAuthorizationStatus != .unknown && currentAuthorizationStatus != .notDetermined  else {
            LocationManager.shared.requestUserLocationPermission()
            return
        }

        if currentAuthorizationStatus == .noAccess {
            displayGetLocationPermissionaAlert()
        } else {
             LocationManager.shared.startLocating()
         }
    }
}


// MARK: - TableViewDataSource

extension ActivityPhotoListViewController {
    
    private enum TableSection: String, CaseIterable {
        case photos
    }
    
    private enum TableCell: Hashable {
        case photo(Int, String)
    }
    
    private typealias PhotosDataSource = UITableViewDiffableDataSource<TableSection, TableCell>
    private typealias PhotosSnapshot = NSDiffableDataSourceSnapshot<TableSection, TableCell>
    
    private func reloadTableData(animated: Bool = false) {
        var snapshot = PhotosSnapshot()
        snapshot.appendSections([.photos])
        snapshot.appendItems(savedPhotoPaths, toSection: .photos)
        tableDataSource.defaultRowAnimation = .fade
        tableDataSource.apply(snapshot, animatingDifferences: animated)
    }
}

// MARK: - TableViewDelegate

extension ActivityPhotoListViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}
