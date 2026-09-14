import Foundation

struct LogMaintenanceUseCase {

    enum MaintenanceError: LocalizedError {
        case odometerTooLow(lastRecorded: Double)

        var errorDescription: String? {
            switch self {
            case .odometerTooLow(let last):
                return "Service odometer cannot be lower than the previous record (\(Int(last)) km). Check the odometer reading and try again."
            }
        }
    }

    func execute(
        existingRecords: [MaintenanceRecord],
        date: Date,
        odometer: Double,
        description: String,
        mechanic: String,
        costAUD: Double
    ) throws -> MaintenanceRecord {

        let lastOdometer = existingRecords.map { $0.odometer }.max() ?? 0
        if odometer < lastOdometer {
            throw MaintenanceError.odometerTooLow(lastRecorded: lastOdometer)
        }

        return MaintenanceRecord(
            date: date,
            odometer: odometer,
            description: description,
            mechanic: mechanic,
            costAUD: costAUD
        )
    }
}
