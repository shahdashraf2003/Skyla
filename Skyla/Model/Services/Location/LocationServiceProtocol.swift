//
//  LocationServiceProtocol.swift
//  Skyla
//
//  Created by Shahd Ashraf on 28/05/2026.
//


import CoreLocation

protocol LocationServiceProtocol: ObservableObject {

    var location: CLLocation? { get }

    func requestLocation()
}
