//
//  PermissionDeniedView.swift
//  Skyla
//
//  Created by Shahudaa on 29/05/2026.
//


import SwiftUI

struct PermissionDeniedView: View {

    let openSettingsAction: () -> Void

    var body: some View {

        VStack(spacing: 20) {

            Image(systemName: "location.slash")
                .font(.system(size: 60))

            Text("Location Access Denied")
                .font(.title3)
                .fontWeight(.semibold)

            Text("Enable location access from Settings")
                .multilineTextAlignment(.center)

            Button("Open Settings") {
                openSettingsAction()
            }
            .buttonStyle(.borderedProminent)
        }.padding()
    }
}
