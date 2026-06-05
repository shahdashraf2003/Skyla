//
//  AddButton.swift
//  Skyla
//
//  Created by ITI_JETS on 05/06/2026.
//

import SwiftUI

struct  AddButton:  View {
    var addTapped: () -> Void
    var backgroundColor: Color
    var foregroundColor: Color
    var weatherContext: WeatherContext
    var body: some View {
        
        Button {
           addTapped()
        } label: {
            Image(systemName: "plus")
                .font(.title2)
                .foregroundColor(backgroundColor)
                .frame(width: 56, height: 56)
                .background(foregroundColor.opacity(0.9))
                .clipShape(Circle())
                .shadow(radius: 8)
        }
        .padding(.horizontal, weatherContext.theme == .night ? 60 :20)
    }
}
