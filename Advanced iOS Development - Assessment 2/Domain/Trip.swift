import Foundation

/// A single driving trip recorded by the user.
/// Only verified trips (good GPS, at least 1 km) count toward the leaderboard.
struct Trip: Identifiable {
    let id = UUID()
    let startOdometer: Double   // km
    let endOdometer: Double     // km
    let startTime: Date
    let endTime: Date
    let gpsAccuracy: Double     // metres — must be ≤ 50 to be verified
    let isVerified: Bool

    var distanceKm: Double {
        endOdometer - startOdometer
    }

    var durationSeconds: Double {
        endTime.timeIntervalSince(startTime)
    }
}

extension Trip {
    static let samples: [Trip] = [
        Trip(startOdometer: 42_000, endOdometer: 42_035,
             startTime: Date().addingTimeInterval(-7 * 86400),
             endTime: Date().addingTimeInterval(-7 * 86400 + 2100),
             gpsAccuracy: 8, isVerified: true),
        Trip(startOdometer: 42_035, endOdometer: 42_058,
             startTime: Date().addingTimeInterval(-3 * 86400),
             endTime: Date().addingTimeInterval(-3 * 86400 + 1800),
             gpsAccuracy: 15, isVerified: true),
        Trip(startOdometer: 42_058, endOdometer: 42_060,
             startTime: Date().addingTimeInterval(-1 * 86400),
             endTime: Date().addingTimeInterval(-1 * 86400 + 300),
             gpsAccuracy: 80, isVerified: false),
    ]
}
