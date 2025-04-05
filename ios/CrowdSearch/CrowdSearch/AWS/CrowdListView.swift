//
//  CrowdListView.swift
//  CrowdSearch
//
//  Created by Ryan Lin on 4/4/25.
//

import SwiftUI

import SwiftUI

struct CrowdListView: View {
    @State private var crowds: [Crowd] = []
    @State private var isLoading = true

    var body: some View {
        NavigationView {
            List(crowds) { crowd in
                HStack {
                    Text(crowd.name)
                        .font(.headline)
                    Spacer()
                    Text("Level \(crowd.crowd_level)")
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Crowd Levels")
            .overlay(
                Group {
                    if isLoading {
                        ProgressView("Loading...")
                    }
                }
            )
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


#Preview{
    CrowdListView()
}
