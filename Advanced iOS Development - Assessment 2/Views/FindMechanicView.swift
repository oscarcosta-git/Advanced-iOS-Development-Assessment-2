import SwiftUI

struct FindMechanicView: View {
    @StateObject private var vm = FindMechanicViewModel()

    var body: some View {
        NavigationStack {
            List {
                // Search bar
                Section {
                    TextField("Search by name or suburb", text: $vm.searchText)
                }

                // Recommended mechanics
                if !vm.recommended.isEmpty {
                    Section("Recommended ✓") {
                        ForEach(vm.recommended) { mechanic in
                            MechanicRow(mechanic: mechanic)
                        }
                    }
                }

                // Other mechanics
                if !vm.others.isEmpty {
                    Section("Others") {
                        ForEach(vm.others) { mechanic in
                            MechanicRow(mechanic: mechanic)
                        }
                    }
                }

                if vm.recommended.isEmpty && vm.others.isEmpty {
                    Section {
                        Text("No mechanics found.")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Find a Mechanic")
        }
    }
}

struct MechanicRow: View {
    let mechanic: Mechanic

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(mechanic.name)
                    .font(.headline)
                Spacer()
                if !mechanic.isVerified {
                    Text("Unverified")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
            }
            Text(String(format: "★ %.1f  ·  %@", mechanic.rating, mechanic.suburb))
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(mechanic.specialties.joined(separator: ", "))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    FindMechanicView()
}
