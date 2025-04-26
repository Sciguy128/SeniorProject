// ios/CrowdSearch/Views/MapView.swift
// Displays an interactive map annotated with current crowd levels.

import SwiftUI
import MapKit

/// Shows crowd-level annotations on a map centered on campus, and lets the user open a report form.
struct MapView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var cameraPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: .init(latitude: 41.507421, longitude: -81.607245),
            span: .init(latitudeDelta: 0.01, longitudeDelta: 0.015)
        )
    )
    @State private var pointsOfInterest: [CrowdLocation] = [
        .init(name: "Thwing Center", coordinate: .init(latitude: 41.507437, longitude: -81.60840), crowdLevel: 3),
        .init(name: "Tinkham Veale", coordinate: .init(latitude: 41.508186, longitude: -81.608665), crowdLevel: 1),
        .init(name: "Veale Center", coordinate: .init(latitude: 41.504664, longitude: -81.607070), crowdLevel: 10),
        .init(name: "Leutner Commons", coordinate: .init(latitude: 41.513639, longitude: -81.606061), crowdLevel: 3),
        .init(name: "Fribley Commons", coordinate: .init(latitude: 41.501038, longitude: -81.602749), crowdLevel: 5)
    ]
    @State private var showReportForm = false

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
                showReportForm = true
            } label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .shadow(radius: 4)
            }
            .padding([.leading, .bottom], 20)
        }
        .sheet(isPresented: $showReportForm) {
            CrowdReportForm(placeOfInterest: "Tinkham Veale")
                .presentationDetents([.fraction(0.5)])
                .presentationDragIndicator(.visible)
        }
    }

    private func fetchCrowdLevels() async {
        guard let url = URL(string: "\(Constants.baseURL)/api/crowds") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let crowdData = try JSONDecoder().decode([Crowd].self, from: data)
            DispatchQueue.main.async {
                pointsOfInterest = pointsOfInterest.map { loc in
                    if let match = crowdData.first(where: { $0.name == loc.name }) {
                        return CrowdLocation(name: loc.name, coordinate: loc.coordinate, crowdLevel: match.crowd_level)
                    }
                    return loc
                }
            }
        } catch {
            print("Failed to fetch crowd data:", error)
        }
    }
}

