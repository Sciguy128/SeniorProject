// Views/ProfileView.swift
// Shows user info: username, XP, rank, and logout.

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var session: SessionManager
    @Environment(\.dismiss) private var dismiss

    @State private var xp: Int?
    @State private var rank: String?
    @State private var isLoading = true
    @State private var errorMessage: String?

    private var username: String {
        session.currentUser?.displayName
        ?? session.currentUser?.email
        ?? "Unknown User"
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text(username)
                    .font(.title)
                    .bold()

                if isLoading {
                    ProgressView("Loading stats…")
                } else if let err = errorMessage {
                    Text(err)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                } else {
                    if let xp { Text("XP: \(xp)").font(.headline) }
                    if let rank { Text("Rank: \(rank)").font(.headline) }
                }

                Spacer()

                Button("Logout") {
                    session.signOut()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
            .task { await loadStats() }
        }
    }

    private func loadStats() async {
        guard let uid = session.currentUser?.uid else { return }
        do {
            let stats = try await XPService.shared.getXP(id: uid)
            xp = stats.xp
            rank = stats.rank
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
