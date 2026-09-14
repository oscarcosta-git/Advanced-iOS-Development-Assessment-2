import SwiftUI

struct TripDashboardView: View {
    @StateObject private var vm = TripDashboardViewModel()

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading) {
                        Text("Verified Kilometres")
                            .foregroundStyle(.secondary)
                        Text(String(format: "%.1f km", vm.totalVerifiedKm))
                            .font(.largeTitle)
                            .bold()
                    }
                    .padding(.vertical, 4)
                }

                Section("Recent Trips") {
                    ForEach(vm.trips) { trip in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(String(format: "%.1f km", trip.distanceKm))
                                    .font(.headline)
                                Spacer()
                                if trip.isVerified {
                                    Text("Verified")
                                        .font(.caption)
                                        .foregroundStyle(.green)
                                } else {
                                    Text("Unverified")
                                        .font(.caption)
                                        .foregroundStyle(.orange)
                                }
                            }
                            Text(trip.startTime.formatted(date: .abbreviated, time: .omitted))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("My Trips")
            .toolbar {
                Button("Add Trip") {
                    vm.showAddTrip = true
                }
            }
            .sheet(isPresented: $vm.showAddTrip) {
                AddTripView(vm: vm)
            }
            .alert("Error", isPresented: $vm.showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(vm.errorMessage)
            }
        }
    }
}

struct AddTripView: View {
    @ObservedObject var vm: TripDashboardViewModel
    @Environment(\.dismiss) var dismiss

    @State private var startOdo: String = ""
    @State private var endOdo: String = ""
    @State private var startTime: Date = Date().addingTimeInterval(-3600)
    @State private var endTime: Date = Date()
    @State private var gpsAccuracy: String = "10"

    var body: some View {
        NavigationStack {
            Form {
                Section("Odometer (km)") {
                    TextField("Start odometer", text: $startOdo)
                        .keyboardType(.decimalPad)
                    TextField("End odometer", text: $endOdo)
                        .keyboardType(.decimalPad)
                }
                Section("Time") {
                    DatePicker("Start", selection: $startTime)
                    DatePicker("End", selection: $endTime)
                }
                Section("GPS Accuracy (metres)") {
                    TextField("e.g. 10", text: $gpsAccuracy)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Log a Trip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard let start = Double(startOdo),
                              let end = Double(endOdo),
                              let accuracy = Double(gpsAccuracy) else { return }
                        vm.addTrip(startOdometer: start, endOdometer: end,
                                   startTime: startTime, endTime: endTime,
                                   gpsAccuracy: accuracy)
                    }
                }
            }
        }
    }
}

#Preview {
    TripDashboardView()
}
