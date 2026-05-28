//
//  LocationServiceProtocol.swift
//  Skyla
//
//  Created by Shahd Ashraf on 28/05/2026.
//


import CoreLocation
internal import Combine

protocol LocationServiceProtocol: AnyObject {
	var location: CLLocation? { get }
	var locationPublisher: AnyPublisher<CLLocation, Never> { get }
	func requestLocation()
}
