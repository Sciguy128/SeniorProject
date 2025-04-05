//
//  MapView.swift
//  CrowdSearch
//
//  Created by Ryan Lin on 3/31/25.
//

//
//  HomePageView.swift
//  CrowdSearch
//
//  Created by Ryan Lin on 3/31/25.
//

import SwiftUI
import MapKit

struct CrowdLocation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    var crowdLevel: Int
}

struct MapView: View {
    @State private var cameraPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 41.507421 , longitude: -81.607245),
            span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
        )
    )

    @State private var pointsOfInterest: [CrowdLocation] = [
        CrowdLocation(name: "Thwing Center", coordinate: CLLocationCoordinate2D(latitude: 41.507437 ,longitude: -81.60840), crowdLevel: 0),
        CrowdLocation(name: "Tinkham Veale", coordinate: CLLocationCoordinate2D(latitude: 41.508186 , longitude: -81.608665), crowdLevel: 0),
        CrowdLocation(name: "Veale Center", coordinate: CLLocationCoordinate2D(latitude: 41.504664, longitude: -81.607070), crowdLevel: 0),
        CrowdLocation(name: "Leutner Commons", coordinate: CLLocationCoordinate2D(latitude: 41.513639, longitude: -81.606061), crowdLevel: 0),
        CrowdLocation(name: "Fribley Commons", coordinate: CLLocationCoordinate2D(latitude: 41.501038, longitude: -81.602749), crowdLevel: 0)
    ]

    var body: some View {
        Map(position: $cameraPosition) {
            ForEach(pointsOfInterest) { item in
                Annotation("", coordinate: item.coordinate) {
                    VStack(spacing: 4) {
                        Text(item.name)
                            .font(.caption)
                            .bold()
                            .padding(6)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(radius: 2)

                        Text("Level \(item.crowdLevel)")
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.8))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .shadow(radius: 1)
                    }
                }
            }
        }
        // Use standard style and disable default geocoded POIs
        .mapStyle(.standard(elevation: .realistic))
        .mapControls {
            MapUserLocationButton()
            MapCompass()
        }
        .navigationTitle("CWRU Crowd Map")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await fetchCrowdLevels()
        }
    }

    func fetchCrowdLevels() async {
        guard let url = URL(string: "http://127.0.0.1:5000/api/crowds") else { return } // Replace with Mac IP

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let crowdData = try JSONDecoder().decode([Crowd].self, from: data)

            DispatchQueue.main.async {
                pointsOfInterest = pointsOfInterest.map { location in
                    if let match = crowdData.first(where: { $0.name == location.name }) {
                        return CrowdLocation(name: location.name, coordinate: location.coordinate, crowdLevel: match.crowd_level)
                    }
                    return location
                }
            }
        } catch {
            print("Failed to fetch crowd data: \(error)")
        }
    }
}
