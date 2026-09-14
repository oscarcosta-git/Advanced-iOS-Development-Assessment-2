import Foundation
import Combine

class LeaderboardViewModel: ObservableObject {
    @Published var entries: [LeaderboardEntry] = []

    private let repository = FriendRepository()

    init() {
        entries = LeaderboardUseCase().execute(friends: repository.friends)
    }
}
