import Foundation

/// Another driver. Only accepted friends appear on the leaderboard.
struct Friend: Identifiable {
    let id = UUID()
    let name: String
    let status: String      // "accepted", "pending", "declined"
    let verifiedKm: Double
}

extension Friend {
    static let samples: [Friend] = [
        Friend(name: "Jordan", status: "accepted", verifiedKm: 1_240),
        Friend(name: "Alex",   status: "accepted", verifiedKm: 980),
        Friend(name: "Sam",    status: "accepted", verifiedKm: 2_105),
        Friend(name: "Taylor", status: "pending",  verifiedKm: 0),
    ]
}
