import Foundation

/// Stores all recorded trips in memory.
class TripRepository {
    private(set) var trips: [Trip] = Trip.samples

    func add(_ trip: Trip) {
        trips.append(trip)
    }

    func hasOverlap(start: Date, end: Date) -> Bool {
        trips.contains { $0.startTime < end && $0.endTime > start }
    }
}
