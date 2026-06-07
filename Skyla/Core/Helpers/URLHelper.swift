//
//  URLHelper.swift
//  Skyla
//
//  Created by Shahd Ashraf on 28/05/2026.
//

import Foundation


struct URLHelper {

    static func weatherIconURL(_ icon: String?) -> URL? {
        guard let icon else { return nil }
        let normalized = icon.hasPrefix("//") ? "https:\(icon)" : icon
        return URL(string: normalized)
    }
}
