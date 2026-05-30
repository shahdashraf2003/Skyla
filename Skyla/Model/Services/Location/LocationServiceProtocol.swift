//
//  LocationServiceProtocol.swift
//  Skyla
//
//  Created by Shahd Ashraf on 28/05/2026.
//


import CoreLocation
import Combine

protocol LocationServiceProtocol: AnyObject {
	var location: CLLocation? { get }
	var locationPublisher: AnyPublisher<CLLocation, Never> { get }
	func requestLocation()
	var authorizationDenied: Bool { get }
	var authorizationStatusPublisher: Published<Bool>.Publisher { get }
}
