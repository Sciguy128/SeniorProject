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
    let centerCoordinate = CLLocationCoordinate2D(latitude: 41.508056, longitude: -81.605861)

    @State private var cameraPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 41.508056, longitude: -81.605861),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    )

    var body: some View {
        Map(position: $cameraPosition) {
           
        }
        .mapStyle(.imagery(elevation: .realistic))
        .navigationTitle("CWRU Center Map")
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview{
    MapView()
}
