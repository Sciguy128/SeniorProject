// ios/CrowdSearch/Views/CrowdListView.swift
// Displays a list of crowd levels for all locations.

import SwiftUI

/// Fetches and shows all `Crowd` items in a `List`, with loading state.
struct CrowdListView: View {
    @State private var crowds: [Crowd] = []
    @State private var isLoading = true

    var body: some View {
        NavigationView {
            List(crowds) { c in
                HStack {
                    Text(c.name).font(.headline)
                    Spacer()
                    Text("Level \(c.crowd_level)").foregroundColor(.gray)
                }
            }
            .navigationTitle("Crowd Levels")
            .overlay { if isLoading { ProgressView("Loading...") } }
        }
        .task {
            do {
                crowds = try await CrowdService.shared.fetchCrowds()
            } catch {
                print("Error fetching crowd data:", error)
            }
            isLoading = false
        }
    }
}
