import Foundation

/// One service event logged against the user's car.
/// Records are kept in odometer order — you can't log a service with a lower odometer than the previous one.
struct MaintenanceRecord: Identifiable {
    let id = UUID()
    let date: Date
    let odometer: Double        // km at time of service
    let description: String
    let mechanic: String
    let costAUD: Double
}

extension MaintenanceRecord {
    static let samples: [MaintenanceRecord] = [
        MaintenanceRecord(date: Date().addingTimeInterval(-180 * 86400),
                          odometer: 40_000,
                          description: "Full service — oil, filters, tyres rotated",
                          mechanic: "Quick Fix Auto",
                          costAUD: 320),
        MaintenanceRecord(date: Date().addingTimeInterval(-60 * 86400),
                          odometer: 41_500,
                          description: "Brake pad replacement",
                          mechanic: "City Motors",
                          costAUD: 480),
    ]
}
