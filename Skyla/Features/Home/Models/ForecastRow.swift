//
//  ForecastRow.swift
//  Skyla
//
//  Created by Shahudaa on 29/05/2026.
//

import Foundation


struct ForecastRow: Identifiable {
    let id: String
    let label: String
    let iconURL: URL?
    let range: String
    let day: ForecastDay   
}
