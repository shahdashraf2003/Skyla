//
//  LocationManager.swift
//  Skyla
//
//  Created by Shahd Ashraf 28/05/2026.
//


import Foundation
import CoreLocation
internal import Combine

final class LocationManager: NSObject,
                             ObservableObject,
                             LocationServiceProtocol {

    private let manager = CLLocationManager()

    @Published var location: CLLocation?

    override init() {
        super.init()

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocation() {

        switch manager.authorizationStatus {

        case .notDetermined:
            manager.requestWhenInUseAuthorization()

        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()

        default:
            print("Location permission denied")
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {

        location = locations.first
    }

    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {

        print("Location Error:", error.localizedDescription)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {

        if manager.authorizationStatus == .authorizedWhenInUse ||
            manager.authorizationStatus == .authorizedAlways {

            manager.requestLocation()
        }
    }
}
