//
//  ErrorView.swift
//  Skyla
//
//  Created by Shahudaa on 27/05/2026.
//


import SwiftUI

struct ErrorView: View {
    
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
			Text("")
				.font(.headline)
			
			Image(systemName: "exclamationmark.triangle.fill")
				.font(.system(size: 50))
				.foregroundColor(.yellow)

            Text("Something went wrong")
                .font(.headline)
            
            Text(message)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .opacity(0.8)
            
            Button("Retry") {
                retryAction()
            }
            .padding()
            .background(.white.opacity(0.9))
            .cornerRadius(14)

			Text("")
				.font(.headline)

        }
		.padding(.horizontal,40)
		.background(.white.opacity(0.5))
		.cornerRadius(22)
    }
}
