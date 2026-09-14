import Foundation

struct LeaderboardEntry: Identifiable {
    let id = UUID()
    let name: String
    let verifiedKm: Double
    let rank: Int
}

struct LeaderboardUseCase {

    func execute(friends: [Friend]) -> [LeaderboardEntry] {
        let accepted = friends.filter { $0.status == "accepted" }
        let sorted = accepted.sorted { $0.verifiedKm > $1.verifiedKm }

        return sorted.enumerated().map { index, friend in
            LeaderboardEntry(name: friend.name, verifiedKm: friend.verifiedKm, rank: index + 1)
        }
    }
}
