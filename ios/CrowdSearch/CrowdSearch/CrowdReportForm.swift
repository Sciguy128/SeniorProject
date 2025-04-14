//
//  CrowdReportForm.swift
//  CrowdSearch
//
//  Created by Ryan Lin on 4/12/25.
//

import Foundation

import SwiftUI



struct CrowdReportForm: View {
    @State private var crowdedness: Double = 5.0


    let placeOfInterest: String

    private let labels = [
        "empty", "barely any people", "very quiet", "some people",
        "lightly busy", "Moderately busy", "Getting crowded", "Pretty Full",
        "Very Busy", "Almost PACKED", "PACKED"
    ]

    var crowdColor: Color {
        // Blue (low) to red (high)
        let hue = (240 - (crowdedness * 24)) / 360
        return Color(hue: hue, saturation: 0.85, brightness: 0.85)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("We see that you are in **\(placeOfInterest)**.")
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
                        .tint(.white) // ✅ use this instead of .accentColor(.clear)
                        .padding(.horizontal)
                }

                .padding(.horizontal)
                let level = Int(crowdedness)
                let label = labels[level]

                let fontSize = 12 + CGFloat(level * 2) // Size from 12 → 32

                (
                    Text("Crowdedness: \(level) — ") +
                    Text(label)
                        .font(.system(size: fontSize, weight:  .regular))
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

#Preview {
    CrowdReportForm(placeOfInterest: "Tinkham Veale")
}

