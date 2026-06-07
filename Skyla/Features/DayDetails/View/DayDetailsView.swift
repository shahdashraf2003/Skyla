//
//  DayDetailsView.swift
//  Skyla
//
//  Created by Shahudaa on 29/05/2026.
//


import SwiftUI

struct DayDetailsView: View {

    @EnvironmentObject var weatherContext: WeatherContext
    @Environment(\.dismiss) private var dismiss

    @StateObject var viewModel: DayDetailsViewModel
    @State private var didAppear = false

    var foregroundColor: Color {
        weatherContext.theme == .day ? .black : .white
    }

    var backgroundColor: Color {
        weatherContext.theme == .day ? .white : .black
    }

    var horizontalPadding: CGFloat {
        foregroundColor == .black ? 45 : 55
    }

    var body: some View {

        ZStack {

          
            Image(weatherContext.theme.backgroundImage)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .opacity(didAppear ? 1 : 0)
                .animation(.easeInOut(duration: 0.4), value: didAppear)

            if viewModel.isEmpty {
                EmptyStateView()
                    .foregroundColor(foregroundColor)
                    .transition(.opacity)
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        Spacer(minLength: 60)
                        header
                            .transition(.move(edge: .top).combined(with: .opacity))

                        HourlyForecastView(
                            hours: viewModel.groupedHours,
                            backgroundColor: backgroundColor
                        )
                        .padding(.horizontal, horizontalPadding)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    .foregroundColor(foregroundColor)
                    .padding(.horizontal, horizontalPadding - 24)
                    .animation(.easeInOut(duration: 0.35), value: viewModel.groupedHours)
                }
            }
        }

     
        .toolbar {

            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        dismiss()
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(foregroundColor)
                        .padding(10)
                        .background(
                            Circle()
                                .fill(foregroundColor.opacity(0.12))
                        )
                }
                .scaleEffect(didAppear ? 1 : 0.8)
                .opacity(didAppear ? 1 : 0)
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: didAppear)
            }

            ToolbarItem(placement: .principal) {
                Text(viewModel.date)
                    .font(.headline)
                    .foregroundColor(foregroundColor)
                    .opacity(didAppear ? 1 : 0)
                    .offset(y: didAppear ? 0 : -10)
                    .animation(.easeOut(duration: 0.35), value: didAppear)
            }
        }

        .navigationBarBackButtonHidden(true)
        .onAppear {
            didAppear = true
        }
    }

    private var header: some View {
        VStack(spacing: 10) {

            Text(viewModel.conditionText)
                .font(.title2)
                .bold()
                .opacity(didAppear ? 1 : 0)
                .offset(y: didAppear ? 0 : 10)
                .animation(.easeOut(duration: 0.35).delay(0.05), value: didAppear)

            if let icon = viewModel.iconURL {
                RemoteImage(url: icon)
                    .frame(width: 80, height: 80)
                    .scaleEffect(didAppear ? 1 : 0.7)
                    .opacity(didAppear ? 1 : 0)
                    .animation(.spring(response: 0.4, dampingFraction: 0.75).delay(0.1), value: didAppear)
            }

            Text(viewModel.rangeTemp)
                .font(.headline)
                .opacity(didAppear ? 1 : 0)
                .offset(y: didAppear ? 0 : 10)
                .animation(.easeOut(duration: 0.35).delay(0.15), value: didAppear)
        }
    }
}
