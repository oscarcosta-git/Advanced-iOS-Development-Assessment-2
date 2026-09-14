import Foundation
import Testing
@testable import Advanced_iOS_Development___Assessment_2

@Suite("LeaderboardUseCase")
@MainActor
struct LeaderboardUseCaseTests {

    let useCase = LeaderboardUseCase()

    // MARK: Happy path

    @Test("Accepted friends are ranked by km descending")
    func rankingOrder() {
        let friends = [
            Friend(name: "Alice", status: "accepted", verifiedKm: 500),
            Friend(name: "Bob",   status: "accepted", verifiedKm: 1200),
            Friend(name: "Carol", status: "accepted", verifiedKm: 300),
        ]
        let entries = useCase.execute(friends: friends)
        #expect(entries[0].name == "Bob")
        #expect(entries[1].name == "Alice")
        #expect(entries[2].name == "Carol")
    }

    @Test("Rank starts at 1")
    func rankStartsAtOne() {
        let friends = [Friend(name: "Solo", status: "accepted", verifiedKm: 100)]
        let entries = useCase.execute(friends: friends)
        #expect(entries.first?.rank == 1)
    }

    // MARK: Filtering

    @Test("Pending friends are excluded")
    func pendingExcluded() {
        let friends = [
            Friend(name: "Pending", status: "pending",  verifiedKm: 9999),
            Friend(name: "Active",  status: "accepted", verifiedKm: 100),
        ]
        let entries = useCase.execute(friends: friends)
        #expect(entries.count == 1)
        #expect(entries.first?.name == "Active")
    }

    @Test("Declined friends are excluded")
    func declinedExcluded() {
        let friends = [Friend(name: "Declined", status: "declined", verifiedKm: 500)]
        let entries = useCase.execute(friends: friends)
        #expect(entries.isEmpty)
    }

    // MARK: Boundary

    @Test("Empty friends list returns empty leaderboard")
    func emptyList() {
        let entries = useCase.execute(friends: [])
        #expect(entries.isEmpty)
    }
}
