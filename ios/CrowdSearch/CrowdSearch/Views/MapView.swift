// ios/CrowdSearch/Views/MapView.swift
// Displays an interactive map annotated with live crowd levels.

import SwiftUI
import MapKit

/// Shows campus POIs on a map, fetches their current crowd levels from the backend,
/// and lets the user tap an annotation to report a new level.
struct MapView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var cameraPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: .init(latitude: Constants.campusCenterLatitude,
                          longitude: Constants.campusCenterLongitude),
            span: .init(latitudeDelta: Constants.campusLatitudeDelta,
                        longitudeDelta: Constants.campusLongitudeDelta)
        )
    )

    /// Static coordinates for known locations
    private let defaultLocations: [CrowdLocation] = [
        .init(name: "Thwing Center",     coordinate: .init(latitude: 41.507437, longitude: -81.608400), crowdLevel: 0),
        .init(name: "Tinkham Veale",     coordinate: .init(latitude: 41.508186, longitude: -81.608665), crowdLevel: 0),
        .init(name: "Veale Center",      coordinate: .init(latitude: 41.504664, longitude: -81.607070), crowdLevel: 0),
        .init(name: "Leutner Commons",   coordinate: .init(latitude: 41.513639, longitude: -81.606061), crowdLevel: 0),
        .init(name: "Fribley Commons",   coordinate: .init(latitude: 41.501038, longitude: -81.602749), crowdLevel: 0)
    ]

    @State private var pointsOfInterest: [CrowdLocation] = []
    @State private var showReportForm = false
    @State private var selectedLocationName: String?

    var body: some View {
        Map(position: $cameraPosition) {
            ForEach(pointsOfInterest) { item in
                Annotation(item.name, coordinate: item.coordinate) {
                    VStack(spacing: 6) {
                        Text(item.name)
                            .font(.headline)
                            .bold()
                            .padding(8)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 3)

                        Text("Level \(item.crowdLevel)")
                            .font(.callout)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(crowdColor(for: item.crowdLevel))
                            .clipShape(Capsule())
                            .shadow(radius: 2)
                    }
                    .onTapGesture {
                        selectedLocationName = item.name
                        showReportForm = true
                    }
                }
            }

            if locationManager.isOnCampus {
                UserAnnotation()
            }
        }
        .mapStyle(.standard(elevation: .realistic))
        .mapControls {
            MapCompass()
            MapUserLocationButton()
        }
        .navigationTitle("CWRU Crowd Map")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await fetchCrowdLevels()
        }
        .overlay(alignment: .bottomLeading) {
            Button {
                if let first = pointsOfInterest.first?.name {
                    selectedLocationName = first
                    showReportForm = true
                }
            } label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .shadow(radius: 4)
            }
            .padding([.leading, .bottom], 20)
        }
        .sheet(isPresented: $showReportForm) {
            if let place = selectedLocationName {
                CrowdReportForm(placeOfInterest: place)
                    .presentationDetents([.fraction(0.5)])
                    .presentationDragIndicator(.visible)
            }
        }
    }

    /// Fetches current crowd levels, merges them into the static coordinate list.
    private func fetchCrowdLevels() async {
        // Start from defaults (level 0 placeholder)
        var merged = defaultLocations

        do {
            let crowds = try await CrowdService.shared.fetchCrowds()
            // Update merge
            merged = merged.map { loc in
                if let match = crowds.first(where: { $0.name == loc.name }) {
                    return CrowdLocation(
                        name: loc.name,
                        coordinate: loc.coordinate,
                        crowdLevel: match.crowd_level
                    )
                }
                return loc
            }
        } catch {
            print("Failed to fetch crowd data:", error)
        }

        // Apply on main thread
        await MainActor.run {
            pointsOfInterest = merged
        }
    }
}
