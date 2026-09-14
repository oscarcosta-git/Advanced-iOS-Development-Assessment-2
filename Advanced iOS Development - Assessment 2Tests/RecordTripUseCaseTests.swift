import Foundation
import Testing
@testable import Advanced_iOS_Development___Assessment_2

@Suite("RecordTripUseCase")
@MainActor
struct RecordTripUseCaseTests {

    let useCase = RecordTripUseCase()
    let now = Date()

    // MARK: Happy path

    @Test("Valid trip is saved and marked verified")
    func happyPath() throws {
        let trip = try useCase.execute(
            existingTrips: [],
            startOdometer: 1000, endOdometer: 1025,
            startTime: now, endTime: now.addingTimeInterval(1800),
            gpsAccuracy: 10
        )
        #expect(trip.distanceKm == 25)
        #expect(trip.isVerified == true)
    }

    // MARK: Boundary — values exactly at the limits are accepted

    @Test("Trip exactly 1 km, 60 s, and 50 m accuracy is accepted")
    func boundaryValues() throws {
        let trip = try useCase.execute(
            existingTrips: [],
            startOdometer: 500, endOdometer: 501,
            startTime: now, endTime: now.addingTimeInterval(60),
            gpsAccuracy: 50
        )
        #expect(trip.distanceKm == 1.0)
        #expect(trip.isVerified == true)
    }

    // MARK: Error cases

    @Test("Reversed odometer throws odometerReversed")
    func odometerReversed() {
        #expect(throws: RecordTripUseCase.TripError.odometerReversed) {
            try useCase.execute(
                existingTrips: [],
                startOdometer: 1000, endOdometer: 999,
                startTime: now, endTime: now.addingTimeInterval(300),
                gpsAccuracy: 10
            )
        }
    }

    @Test("Distance under 1 km throws distanceTooShort")
    func distanceTooShort() {
        #expect(throws: RecordTripUseCase.TripError.distanceTooShort) {
            try useCase.execute(
                existingTrips: [],
                startOdometer: 1000, endOdometer: 1000.5,
                startTime: now, endTime: now.addingTimeInterval(300),
                gpsAccuracy: 10
            )
        }
    }

    @Test("Duration under 60 s throws durationTooShort")
    func durationTooShort() {
        #expect(throws: RecordTripUseCase.TripError.durationTooShort) {
            try useCase.execute(
                existingTrips: [],
                startOdometer: 1000, endOdometer: 1010,
                startTime: now, endTime: now.addingTimeInterval(59),
                gpsAccuracy: 10
            )
        }
    }

    @Test("GPS accuracy over 50 m throws poorGPSAccuracy")
    func poorGPSAccuracy() {
        #expect(throws: RecordTripUseCase.TripError.poorGPSAccuracy) {
            try useCase.execute(
                existingTrips: [],
                startOdometer: 1000, endOdometer: 1010,
                startTime: now, endTime: now.addingTimeInterval(600),
                gpsAccuracy: 51
            )
        }
    }

    @Test("Overlapping time window throws overlapsExistingTrip")
    func tripOverlap() throws {
        let existing = try useCase.execute(
            existingTrips: [],
            startOdometer: 1000, endOdometer: 1010,
            startTime: now, endTime: now.addingTimeInterval(600),
            gpsAccuracy: 10
        )
        #expect(throws: RecordTripUseCase.TripError.overlapsExistingTrip) {
            try useCase.execute(
                existingTrips: [existing],
                startOdometer: 1010, endOdometer: 1020,
                startTime: now.addingTimeInterval(300), endTime: now.addingTimeInterval(900),
                gpsAccuracy: 10
            )
        }
    }
}
