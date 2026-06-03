//
//  SearchBar.swift
//  Skyla
//
//  Created by ITI_JETS on 02/06/2026.
//

import SwiftUI

struct SearchBar: View {

    @Binding var query: String
    let foregroundColor: Color
    var horizontalPadding: CGFloat
    @FocusState private var isFocused: Bool

    var body: some View {

        HStack(spacing: 10) {

            Image(systemName: "magnifyingglass")
                .foregroundColor(foregroundColor.opacity(0.6))

            TextField("", text: $query, prompt: Text("Search city...")
                .foregroundColor(foregroundColor.opacity(0.4)))
                .foregroundColor(foregroundColor)
                .focused($isFocused)
            
            if !query.isEmpty {
                Button {
                    query = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(foregroundColor.opacity(0.6))
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal,14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(
                    isFocused
                    ? foregroundColor.opacity(0.6)
                    : foregroundColor.opacity(0.2),
                    lineWidth: 1
                )
        )
        .padding(.horizontal,horizontalPadding)
       
    }
}
