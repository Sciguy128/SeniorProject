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

// Add this function inside the MapView struct
func crowdColor(for level: Int) -> Color {
    // Clamp level between 0 and 10
    let clampedLevel = min(max(level, 0), 10)
    let ratio = Double(clampedLevel) / 10.0

    // Interpolates from light blue (0) to red (10)
    let red = ratio
    let green = 0.5 * (1.0 - ratio)
    let blue = 1.0 - ratio

    return Color(red: red, green: green, blue: blue)
}


struct MapView: View {
    
    @StateObject private var locationManager = LocationManager()

    @State private var cameraPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 41.507421 , longitude: -81.607245),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.015)
        )
    )

    @State private var pointsOfInterest: [CrowdLocation] = [
        CrowdLocation(name: "Thwing Center", coordinate: CLLocationCoordinate2D(latitude: 41.507437 ,longitude: -81.60840), crowdLevel: 0),
        CrowdLocation(name: "Tinkham Veale", coordinate: CLLocationCoordinate2D(latitude: 41.508186 , longitude: -81.608665), crowdLevel: 0),
        CrowdLocation(name: "Veale Center", coordinate: CLLocationCoordinate2D(latitude: 41.504664, longitude: -81.607070), crowdLevel: 0),
        CrowdLocation(name: "Leutner Commons", coordinate: CLLocationCoordinate2D(latitude: 41.513639, longitude: -81.606061), crowdLevel: 0),
        CrowdLocation(name: "Fribley Commons", coordinate: CLLocationCoordinate2D(latitude: 41.501038, longitude: -81.602749), crowdLevel: 0)
    ]

    @State private var showReportForm = false

    var body: some View {
        Map(position: $cameraPosition) {
            ForEach(pointsOfInterest) { item in
                Annotation("", coordinate: item.coordinate) {
                    VStack(spacing: 6) {
                        Text(item.name)
                            .font(.headline)
                            .bold()
                            .padding(8)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 3)

                        Text("Level \(item.crowdLevel)")
                            .font(.callout)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(crowdColor(for: item.crowdLevel))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .shadow(radius: 2)
                    }

                }
            }

            // ✅ Show user location only if they are on campus
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
        .overlay(
            VStack {
                Spacer()
                HStack {
                    Button(action: {
                        showReportForm = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 48, height: 48)
                            .foregroundColor(.blue)
                            .shadow(radius: 4)
                    }
                    .padding(.leading, 20)
                    .padding(.bottom, 20)
                    
                    Spacer()
                }
            }
        )
        .sheet(isPresented: $showReportForm) {
            CrowdReportForm(placeOfInterest: "Tinkham Veale")
                .presentationDetents([.fraction(0.5)]) // 👈 half the screen height
                .presentationDragIndicator(.visible)   // 👌 adds the little drag bar
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
