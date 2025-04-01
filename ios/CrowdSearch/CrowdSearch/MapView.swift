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

struct MapView: View {
    @State private var cameraPosition = MapCameraPosition.region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 41.5065, longitude: -81.6085),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        )

        let pointsOfInterest: [(label: String, name: String, coordinate: CLLocationCoordinate2D)] = [
            ("4", "Thwing Center", CLLocationCoordinate2D(latitude: 41.507600, longitude: -81.609200)),
            ("8", "Tinkham Veale University Center", CLLocationCoordinate2D(latitude: 41.508050, longitude: -81.609914)),
            ("2", "Veale Center", CLLocationCoordinate2D(latitude: 41.504664, longitude: -81.607070)),
            ("1", "Leutner Commons", CLLocationCoordinate2D(latitude: 41.509452, longitude: -81.604680)),
            ("5", "Fribley Commons", CLLocationCoordinate2D(latitude: 41.500258, longitude: -81.608053))
        ]

        var body: some View {
            Map(position: $cameraPosition) {
                ForEach(pointsOfInterest, id: \.name) { item in
                    Annotation(item.name, coordinate: item.coordinate) {
                        VStack(spacing: 4) {
                            Text(item.label)
                                .font(.caption)
                                .padding(6)
                                .background(.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())

                            Text(item.name)
                                .font(.caption2)
                                .bold()
                                .multilineTextAlignment(.center)
                                .padding(4)
                                .background(.white.opacity(0.8))
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                    }
                }
            }
            .mapStyle(.imagery(elevation: .realistic))
            .navigationTitle("CWRU Points of Interest")
            .navigationBarTitleDisplayMode(.inline)
        }
}


#Preview{
    MapView()
}
