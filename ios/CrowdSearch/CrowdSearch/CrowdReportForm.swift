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

    private let labels = [
        "empty", "barely any people", "very quiet", "some people",
        "lightly busy", "moderately busy", "getting crowded", "pretty full",
        "very busy", "almost packed", "packed"
    ]

    var body: some View {
        Form {
            Section(header: Text("Report Crowdedness")) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("How crowded is it?")
                        .font(.headline)

                    Slider(value: $crowdedness, in: 0...10, step: 1)

                    Text("Crowdedness: \(Int(crowdedness)) — \(labels[Int(crowdedness)])")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.vertical)
            }
        }
    }
}

#Preview{
    CrowdReportForm()
}
