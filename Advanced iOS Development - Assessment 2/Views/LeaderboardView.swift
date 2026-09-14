import SwiftUI

struct LeaderboardView: View {
    @StateObject private var vm = LeaderboardViewModel()

    var body: some View {
        NavigationStack {
            if vm.entries.isEmpty {
                ContentUnavailableView(
                    "No Friends Yet",
                    systemImage: "person.2.fill",
                    description: Text("Accept friend requests to see rankings.")
                )
                .navigationTitle("Leaderboard")
            } else {
                List(vm.entries) { entry in
                    HStack {
                        Text("#\(entry.rank)")
                            .font(.headline)
                            .frame(width: 40)
                            .foregroundStyle(rankColour(entry.rank))

                        VStack(alignment: .leading) {
                            Text(entry.name)
                                .font(.headline)
                            Text(String(format: "%.0f km", entry.verifiedKm))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        if entry.rank == 1 {
                            Image(systemName: "trophy.fill")
                                .foregroundStyle(.yellow)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .navigationTitle("Leaderboard")
            }
        }
    }

    func rankColour(_ rank: Int) -> Color {
        switch rank {
        case 1: return .yellow
        case 2: return .gray
        case 3: return .brown
        default: return .primary
        }
    }
}

#Preview {
    LeaderboardView()
}
