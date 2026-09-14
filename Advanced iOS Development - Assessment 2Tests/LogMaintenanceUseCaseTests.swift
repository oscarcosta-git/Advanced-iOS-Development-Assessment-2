import Foundation
import Testing
@testable import Advanced_iOS_Development___Assessment_2

@Suite("LogMaintenanceUseCase")
@MainActor
struct LogMaintenanceUseCaseTests {

    let useCase = LogMaintenanceUseCase()
    let now = Date()

    // MARK: Happy path

    @Test("First record with any odometer is accepted")
    func firstRecord() throws {
        let record = try useCase.execute(
            existingRecords: [],
            date: now, odometer: 40_000,
            description: "Oil change", mechanic: "Bob's", costAUD: 120
        )
        #expect(record.odometer == 40_000)
    }

    @Test("Second record with a higher odometer is accepted")
    func higherOdometer() throws {
        let first = try useCase.execute(
            existingRecords: [],
            date: now, odometer: 40_000,
            description: "Service A", mechanic: "Bob's", costAUD: 100
        )
        let second = try useCase.execute(
            existingRecords: [first],
            date: now, odometer: 41_000,
            description: "Service B", mechanic: "Bob's", costAUD: 200
        )
        #expect(second.odometer == 41_000)
    }

    // MARK: Boundary

    @Test("Record with odometer equal to last is accepted")
    func equalOdometer() throws {
        let first = try useCase.execute(
            existingRecords: [],
            date: now, odometer: 42_000,
            description: "Service A", mechanic: "Bob's", costAUD: 100
        )
        let second = try useCase.execute(
            existingRecords: [first],
            date: now, odometer: 42_000,
            description: "Same-day top-up", mechanic: "Bob's", costAUD: 20
        )
        #expect(second.odometer == 42_000)
    }

    // MARK: Error case

    @Test("Odometer below last service throws odometerTooLow")
    func odometerTooLow() throws {
        let first = try useCase.execute(
            existingRecords: [],
            date: now, odometer: 45_000,
            description: "Service A", mechanic: "Bob's", costAUD: 200
        )
        #expect(throws: LogMaintenanceUseCase.MaintenanceError.self) {
            try useCase.execute(
                existingRecords: [first],
                date: now, odometer: 44_999,
                description: "Service B", mechanic: "Bob's", costAUD: 150
            )
        }
    }
}
