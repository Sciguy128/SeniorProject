import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var session: SessionManager
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

    @State private var showForecastSheet = false
    @State private var selectedForecastLocation: String?

    @State private var showReportPicker = false
    @State private var showReportSheet = false
    @State private var selectedReportLocation: String?

    @State private var showProfileSheet = false

    var body: some View {
        NavigationStack { // ✅ must be inside a NavigationStack
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
                            selectedForecastLocation = item.name
                            showForecastSheet = true
                        }
                    }
                }

                if locationManager.isOnCampus {
                    UserAnnotation()
                }
            }
            .mapStyle(.standard(elevation: .realistic))
            .mapControls { MapCompass(); MapUserLocationButton() }
            .navigationTitle("CWRU Crowd Map") // ✅ required
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showReportPicker = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.title2)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showProfileSheet = true
                    } label: {
                        Image(systemName: "person.crop.circle")
                            .font(.title2)
                    }
                }
            }
            .task { await fetchCrowdLevels() }
            .confirmationDialog("Report Crowd Level for…", isPresented: $showReportPicker) {
                ForEach(pointsOfInterest) { loc in
                    Button(loc.name) {
                        selectedReportLocation = loc.name
                        showReportSheet = true
                    }
                }
                Button("Cancel", role: .cancel) { }
            }
            .sheet(isPresented: $showForecastSheet) {
                if let loc = selectedForecastLocation {
                    ForecastChartView(location: loc)
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                }
            }
            .sheet(isPresented: $showReportSheet) {
                if let loc = selectedReportLocation {
                    CrowdReportForm(placeOfInterest: loc)
                        .presentationDetents([.fraction(0.5)])
                        .presentationDragIndicator(.visible)
                }
            }
            .sheet(isPresented: $showProfileSheet) {
                ProfileView()
                    .environmentObject(session)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }
    }

    private func fetchCrowdLevels() async {
        var merged = defaultLocations
        do {
            let crowds = try await CrowdService.shared.fetchCrowds()
            merged = merged.map { loc in
                if let m = crowds.first(where: { $0.name == loc.name }) {
                    return CrowdLocation(name: loc.name,
                                         coordinate: loc.coordinate,
                                         crowdLevel: m.crowd_level)
                }
                return loc
            }
        } catch {
            print("Failed to fetch crowd data:", error)
        }
        await MainActor.run { pointsOfInterest = merged }
    }
}
