//
//  SelectLocationVC.swift
//  TrackEnsure
//
//  Created by Денис Андриевский on 05.09.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

final class SelectLocationVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var okBtn: UIButton!
    
    // MARK: - Properties
    private let locationManager = CLLocationManager()
    private let coredataManager = CoreDataManager()
    private let activityIndicatorView = UIActivityIndicatorView()
    private var currentLocation: CLLocation?
    var selectedName: String = ""
    var selectedProvider: String = ""
    var newStationVC: NewStationVC?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        locationManager.delegate = self
        requestAuthorizationIfNeeded()
        activityIndicatorView.startAnimating()
        mapView.delegate = self
    }
    
    private func configureView() {
        okBtn.layer.cornerRadius = C.buttonCornerRadius
        activityIndicatorView.center = view.center
        self.view.addSubview(activityIndicatorView)
    }
    
    private func configureAnnotation() {
        activityIndicatorView.stopAnimating()
        guard let currentLocation = currentLocation else { return }
        let markerImageView = UIImageView(image: UIImage(named: C.markerImage))
        markerImageView.frame.size = C.markerSize
        markerImageView.contentMode = .scaleAspectFit
        markerImageView.center = mapView.center
        markerImageView.center.y -= C.markerSize.height
        mapView.addSubview(markerImageView)
        let region = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: C.mapZoomOffset, longitudinalMeters: C.mapZoomOffset)
        self.mapView.setRegion(region, animated: true)
    }
    
    private func requestAuthorizationIfNeeded() {
        if CLLocationManager.authorizationStatus() != .authorizedAlways && CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func presentSettingsAlert() {
        let alertController = UIAlertController(title: "Unable to proceed location", message: "Permission denied. Please give us access to your location in settings", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Go to settings", style: .default) { _ in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL)
            }
        }
        alertController.addAction(settingsAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }

    // MARK: - IBActions
    @IBAction func okBtnPressed(_ sender: Any) {
        coredataManager.addStation(name: selectedName, provider: selectedProvider, coordinate: mapView.centerCoordinate)
        dismiss(animated: true) { [unowned self] in
            self.newStationVC?.dismiss(animated: true, completion: nil)
        }
    }
    
}

// MARK: - MKMapViewDelegate
extension SelectLocationVC: MKMapViewDelegate {
    
}

// MARK: - CLLocationManagerDelegate
extension SelectLocationVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status != .authorizedAlways && status != .authorizedWhenInUse) && status != .notDetermined {
            presentSettingsAlert()
        } else {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.currentLocation = location
        self.mapView.setCenter(location.coordinate, animated: true)
        self.configureAnnotation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        AlertManager.presentAlert(self, title: "Error", message: error.localizedDescription)
    }
    
}
