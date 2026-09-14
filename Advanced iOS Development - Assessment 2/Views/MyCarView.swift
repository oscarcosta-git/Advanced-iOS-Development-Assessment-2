import SwiftUI

struct MyCarView: View {
    @StateObject private var vm = MyCarViewModel()

    var body: some View {
        NavigationStack {
            List {
                Section("Vehicle") {
                    HStack {
                        Image(systemName: "car.fill")
                            .font(.title)
                            .foregroundStyle(.blue)
                        VStack(alignment: .leading) {
                            Text("\(vm.vehicle.year) \(vm.vehicle.make) \(vm.vehicle.model)")
                                .font(.headline)
                            Text(vm.vehicle.plate)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }

                Section("Service History") {
                    if vm.records.isEmpty {
                        Text("No records yet.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(vm.records) { record in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(record.description)
                                    .font(.headline)
                                Text(String(format: "%.0f km  ·  $%.0f", record.odometer, record.costAUD))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(record.mechanic)
                                    .font(.caption)
                                    .foregroundStyle(.blue)
                            }
                            .padding(.vertical, 2)
                        }
                    }
                }
            }
            .navigationTitle("My Car")
            .toolbar {
                Button("Add Service") {
                    vm.showAddRecord = true
                }
            }
            .sheet(isPresented: $vm.showAddRecord) {
                AddServiceView(vm: vm)
            }
            .alert("Error", isPresented: $vm.showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(vm.errorMessage)
            }
        }
    }
}

struct AddServiceView: View {
    @ObservedObject var vm: MyCarViewModel
    @Environment(\.dismiss) var dismiss

    @State private var date: Date = Date()
    @State private var odometer: String = ""
    @State private var description: String = ""
    @State private var mechanic: String = ""
    @State private var cost: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    TextField("Odometer (km)", text: $odometer)
                        .keyboardType(.decimalPad)
                    TextField("Description", text: $description)
                }
                Section("Mechanic") {
                    TextField("Mechanic name", text: $mechanic)
                }
                Section("Cost") {
                    TextField("Cost (AUD)", text: $cost)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Add Service")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard let odo = Double(odometer),
                              !description.isEmpty else { return }
                        let costValue = Double(cost) ?? 0
                        vm.addRecord(date: date, odometer: odo, description: description,
                                     mechanic: mechanic, costAUD: costValue)
                    }
                }
            }
        }
    }
}

#Preview {
    MyCarView()
}
