import SwiftUI
import Charts

/// Displays a 24-hour forecast line chart for a location.
struct ForecastChartView: View {
    let location: String

    @State private var forecast: [HourlyForecast] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading forecast...")
            } else if let err = errorMessage {
                Text(err)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                Chart(forecast) { point in
                    LineMark(
                        x: .value("Hour", point.hour),
                        y: .value("Crowd Level", point.value)
                    )
                    .interpolationMethod(.catmullRom)
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: 2)) { value in
                        AxisGridLine()
                        AxisValueLabel()
                    }
                }
                .padding()
            }
        }
        .navigationTitle(location)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadForecast()
        }
    }

    private func loadForecast() async {
        do {
            forecast = try await PredictionService.shared.fetchForecast(for: location)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
