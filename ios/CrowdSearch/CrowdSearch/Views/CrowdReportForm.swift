// ios/CrowdSearch/Views/CrowdReportForm.swift
// Lets the user report how crowded a place is.

import SwiftUI

/// A half-screen form with a slider for reporting crowdedness on a 0–10 scale.
struct CrowdReportForm: View {
    @State private var crowdedness: Double = 5.0
    let placeOfInterest: String
    private let labels = [
        "empty", "barely any people", "very quiet", "some people",
        "lightly busy", "moderately busy", "getting crowded", "pretty full",
        "very busy", "almost PACKED", "PACKED"
    ]

    var crowdColor: Color {
        let hue = (240 - (crowdedness * 24)) / 360
        return Color(hue: hue, saturation: 0.85, brightness: 0.85)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("You are at \(placeOfInterest).")
                    .font(.title3)
                    .multilineTextAlignment(.center)

                Text("How crowded is it?")
                    .font(.headline)

                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(crowdColor)
                        .frame(height: 24 + CGFloat(crowdedness * 2))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white, lineWidth: 2 + CGFloat(crowdedness / 2))
                        )
                    Slider(value: $crowdedness, in: 0...10, step: 1)
                        .tint(.white)
                        .padding(.horizontal)
                }
                .padding(.horizontal)

                let level = Int(crowdedness)
                let label = labels[level]
                let fontSize = 12 + CGFloat(level * 2)

                (
                    Text("Crowdedness: \(level) — ") +
                    Text(label)
                        .font(.system(size: fontSize))
                )
                .foregroundColor(crowdColor)

                Spacer()
            }
            .padding()
            .navigationTitle("Report Crowd")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

