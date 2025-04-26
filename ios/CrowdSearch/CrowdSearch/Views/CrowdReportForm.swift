// ios/CrowdSearch/Views/CrowdReportForm.swift
// Lets the user report how crowded a place is with a slider and confirm on release.

import SwiftUI

/// A half-screen form with a slider for reporting crowdedness on a 0–10 scale,
/// and a confirmation dialog on slider release.
struct CrowdReportForm: View {
    @EnvironmentObject private var session: SessionManager
    @Environment(\.dismiss) private var dismiss

    let placeOfInterest: String

    @State private var crowdedness: Double = 5.0
    @State private var showConfirmation = false
    @State private var isSubmitting = false
    @State private var errorMessage: String?

    private let labels = [
        "empty", "barely any people", "very quiet", "some people",
        "lightly busy", "moderately busy", "getting crowded", "pretty full",
        "very busy", "almost PACKED", "PACKED"
    ]

    private var currentWeekday: String {
        let f = DateFormatter()
        f.dateFormat = "EEEE"
        return f.string(from: Date())
    }

    private var currentTime: String {
        let f = DateFormatter()
        f.dateFormat = "h:mm a"
        return f.string(from: Date())
    }

    private var crowdColor: Color {
        let hue = (240 - (crowdedness * 24)) / 360
        return Color(hue: hue, saturation: 0.85, brightness: 0.85)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("You are at **\(placeOfInterest)**.")
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

                    Slider(
                        value: $crowdedness,
                        in: 0...10,
                        step: 1,
                        onEditingChanged: { editing in
                            // when user lifts their finger
                            if !editing {
                                showConfirmation = true
                            }
                        }
                    )
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

                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Report Crowd")
            .navigationBarTitleDisplayMode(.inline)
        }
        .disabled(isSubmitting)
        .alert("Confirm Report", isPresented: $showConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Confirm") {
                submitReport()
            }
        } message: {
            Text("Report \(placeOfInterest) is \(Int(crowdedness)) — \(labels[Int(crowdedness)]) on \(currentWeekday) at \(currentTime)?")
        }
    }

    private func submitReport() {
        isSubmitting = true
        errorMessage = nil
        let userId = session.currentUser?.uid ?? ""
        let request = ReportRequest(
            user_id: userId,
            location: placeOfInterest,
            crowd_level: Int(crowdedness)
        )
        Task {
            do {
                try await ReportService.shared.submitReport(request)
                dismiss()
            } catch {
                errorMessage = error.localizedDescription
            }
            isSubmitting = false
        }
    }
}
