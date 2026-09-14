import Foundation

struct RecordTripUseCase {

    enum TripError: LocalizedError {
        case odometerReversed
        case distanceTooShort
        case durationTooShort
        case poorGPSAccuracy
        case overlapsExistingTrip

        var errorDescription: String? {
            switch self {
            case .odometerReversed:
                return "The end odometer reading is lower than the start. Check the odometer and re-enter the trip."
            case .distanceTooShort:
                return "Trip distance is under 1 km. Only trips of 1 km or more can be logged."
            case .durationTooShort:
                return "Trip duration is under 60 seconds. Make sure your start and end times are correct."
            case .poorGPSAccuracy:
                return "GPS signal was too weak to verify this trip (accuracy worse than 50 m). Move to an open area and try again."
            case .overlapsExistingTrip:
                return "This trip overlaps a trip you have already recorded. Check your existing trips and adjust the times."
            }
        }
    }

    func execute(
        existingTrips: [Trip],
        startOdometer: Double,
        endOdometer: Double,
        startTime: Date,
        endTime: Date,
        gpsAccuracy: Double
    ) throws -> Trip {

        if endOdometer < startOdometer {
            throw TripError.odometerReversed
        }
        if endOdometer - startOdometer < 1.0 {
            throw TripError.distanceTooShort
        }
        if endTime.timeIntervalSince(startTime) < 60 {
            throw TripError.durationTooShort
        }
        if gpsAccuracy > 50 {
            throw TripError.poorGPSAccuracy
        }

        let overlaps = existingTrips.contains { trip in
            trip.startTime < endTime && trip.endTime > startTime
        }
        if overlaps {
            throw TripError.overlapsExistingTrip
        }

        let isVerified = gpsAccuracy <= 50
        return Trip(
            startOdometer: startOdometer,
            endOdometer: endOdometer,
            startTime: startTime,
            endTime: endTime,
            gpsAccuracy: gpsAccuracy,
            isVerified: isVerified
        )
    }
}
