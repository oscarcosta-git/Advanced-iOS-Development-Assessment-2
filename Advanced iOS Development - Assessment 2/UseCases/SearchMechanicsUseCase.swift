import Foundation

struct SearchMechanicsUseCase {

    let minimumRating = 4.0

    func execute(mechanics: [Mechanic], query: String) -> (recommended: [Mechanic], others: [Mechanic]) {

        var results = mechanics
        if !query.isEmpty {
            results = mechanics.filter { mechanic in
                mechanic.name.lowercased().contains(query.lowercased()) ||
                mechanic.suburb.lowercased().contains(query.lowercased())
            }
        }

        let recommended = results
            .filter { $0.isVerified && $0.rating >= minimumRating }
            .sorted { $0.rating > $1.rating }

        let others = results
            .filter { !$0.isVerified || $0.rating < minimumRating }
            .sorted { $0.rating > $1.rating }

        return (recommended, others)
    }
}
