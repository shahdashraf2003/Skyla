//
//  ViewState.swift
//  Skyla
//
//  Created by Shahudaa on 29/05/2026.
//


enum ViewState :Equatable {

    case loading
    case loaded
    case empty
    case locationDenied
    case error(String)
	case noInternet

}
