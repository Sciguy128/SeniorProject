// ios/CrowdSearch/Views/MapView.swift
// Displays an interactive map annotated with live crowd levels.
// Tapping “+” brings up a location picker before showing the report form.

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var cameraPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: Constants.campusCenterCoordinate,
            span: .init(latitudeDelta: Constants.campusLatitudeDelta,
                        longitudeDelta: Constants.campusLongitudeDelta)
        )
    )

    private let defaultLocations: [CrowdLocation] = [
        .init(name: "Thwing Center",   coordinate: .init(latitude: 41.507437, longitude: -81.608400), crowdLevel: 0),
        .init(name: "Tinkham Veale",   coordinate: .init(latitude: 41.508186, longitude: -81.608665), crowdLevel: 0),
        .init(name: "Veale Center",    coordinate: .init(latitude: 41.504664, longitude: -81.607070), crowdLevel: 0),
        .init(name: "Leutner Commons", coordinate: .init(latitude: 41.513639, longitude: -81.606061), crowdLevel: 0),
        .init(name: "Fribley Commons", coordinate: .init(latitude: 41.501038, longitude: -81.602749), crowdLevel: 0)
    ]

    @State private var pointsOfInterest: [CrowdLocation] = []
    @State private var showReportForm = false
    @State private var selectedLocationName: String?
    @State private var showLocationPicker = false

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
        .mapControls { MapCompass(); MapUserLocationButton() }
        .navigationTitle("CWRU Crowd Map")
        .navigationBarTitleDisplayMode(.inline)
        .task { await fetchCrowdLevels() }
        .overlay(alignment: .bottomLeading) {
            Button {
                showLocationPicker = true
            } label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .shadow(radius: 4)
            }
            .padding([.leading, .bottom], 20)
        }
        // ConfirmationDialog to pick which location to report
        .confirmationDialog("Select a location", isPresented: $showLocationPicker, titleVisibility: .visible) {
            ForEach(pointsOfInterest) { loc in
                Button(loc.name) {
                    selectedLocationName = loc.name
                    showReportForm = true
                }
            }
            Button("Cancel", role: .cancel) { }
        }
        // The actual report sheet
        .sheet(isPresented: $showReportForm) {
            if let place = selectedLocationName {
                CrowdReportForm(placeOfInterest: place)
                    .presentationDetents([.fraction(0.5)])
                    .presentationDragIndicator(.visible)
            }
        }
    }

    /// Fetches current crowd levels and merges them into the static coordinate list.
    private func fetchCrowdLevels() async {
        var merged = defaultLocations
        do {
            let crowds = try await CrowdService.shared.fetchCrowds()
            merged = merged.map { loc in
                if let match = crowds.first(where: { $0.name == loc.name }) {
                    return CrowdLocation(name: loc.name, coordinate: loc.coordinate, crowdLevel: match.crowd_level)
                }
                return loc
            }
        } catch {
            print("Failed to fetch crowd data:", error)
        }
        await MainActor.run { pointsOfInterest = merged }
    }
}
