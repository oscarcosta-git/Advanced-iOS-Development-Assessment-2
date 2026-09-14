import Foundation

/// Stores all maintenance records in memory.
class MaintenanceRepository {
    private(set) var records: [MaintenanceRecord] = MaintenanceRecord.samples

    func add(_ record: MaintenanceRecord) {
        records.append(record)
        records.sort { $0.odometer < $1.odometer }
    }
}
