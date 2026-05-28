//
//  LocationManager.swift
//  Skyla
//
//  Created by Shahd Ashraf 28/05/2026.
//


import Foundation
import CoreLocation
internal import Combine

final class LocationManager: NSObject, ObservableObject, LocationServiceProtocol {

	private let manager = CLLocationManager()
	private let locationSubject = PassthroughSubject<CLLocation, Never>()

	@Published var location: CLLocation?
	@Published var authorizationStatus: CLAuthorizationStatus = .notDetermined

	var locationPublisher: AnyPublisher<CLLocation, Never> {
		locationSubject.eraseToAnyPublisher()
	}

	override init() {
		super.init()
		manager.delegate = self
		manager.desiredAccuracy = kCLLocationAccuracyBest
		authorizationStatus = manager.authorizationStatus
	}

	func requestLocation() {
		switch manager.authorizationStatus {
			case .notDetermined:
					
				manager.requestWhenInUseAuthorization()

			case .authorizedWhenInUse, .authorizedAlways:
				manager.requestLocation()

			case .denied, .restricted:
				print("Location access denied")

			@unknown default:
				break
		}
	}
}

extension LocationManager: CLLocationManagerDelegate {

	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		authorizationStatus = manager.authorizationStatus

		switch manager.authorizationStatus {
			case .authorizedWhenInUse, .authorizedAlways:

				manager.requestLocation()

			case .denied, .restricted:
				print("Location access denied")

			case .notDetermined:
				break

			@unknown default:
				break
		}
	}

	func locationManager(_ manager: CLLocationManager,
						 didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.first else { return }
		self.location = location
		locationSubject.send(location)
	}

	func locationManager(_ manager: CLLocationManager,
						 didFailWithError error: Error) {
		guard let clError = error as? CLError else { return }

		switch clError.code {
			case .denied:
				print("Location denied by user")
			case .locationUnknown:

				DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
					self.manager.requestLocation()
				}
			default:
				print("Location error:", error.localizedDescription)
		}
	}
}
