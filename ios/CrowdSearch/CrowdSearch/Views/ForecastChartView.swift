import SwiftUI
import Charts

/// Displays a 24-hour forecast line chart with 15-minute buckets.
struct ForecastChartView: View {
    let location: String

    @State private var forecast: [HourlyForecast] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    private var todayWeekday: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: Date())
    }

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            if isLoading {
                ProgressView("Loading forecast...")
                    .frame(maxWidth: .infinity)
            } else if let err = errorMessage {
                Text(err)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity)
            } else {
                VStack(spacing: 6) {
                    Text("\(location) — \(todayWeekday)")
                        .font(.title2)
                        .bold()
                    Text("Forecast:")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 24) // more space from the top
                .padding(.bottom, 8) // little space above chart

                Chart(forecast) { point in
                    LineMark(
                        x: .value("Time", point.hour),
                        y: .value("Crowd Level", point.value)
                    )
                    .interpolationMethod(.catmullRom)
                    .lineStyle(StrokeStyle(lineWidth: 3))
                    .symbol(Circle())
                }
                .chartXAxis {
                    AxisMarks(values: [0, 24, 48, 72, 96]) { value in
                        AxisGridLine()
                        AxisValueLabel {
                            if let idx = value.as(Int.self) {
                                Text(timeLabel(for: idx))
                                    .font(.caption)
                            }
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24) // extra breathing room at bottom
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

    /// Converts 15-min index to hour label.
    private func timeLabel(for index: Int) -> String {
        switch index {
        case 0: return "12AM"
        case 24: return "6AM"
        case 48: return "12PM"
        case 72: return "6PM"
        case 96: return "12AM"
        default: return ""
        }
    }
}
