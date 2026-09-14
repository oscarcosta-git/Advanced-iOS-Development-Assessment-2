import Foundation
import Combine

class TripDashboardViewModel: ObservableObject {
    @Published var trips: [Trip] = []
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var showAddTrip: Bool = false

    private let repository = TripRepository()

    init() {
        trips = repository.trips
    }

    var totalVerifiedKm: Double {
        trips.filter { $0.isVerified }.reduce(0) { $0 + $1.distanceKm }
    }

    func addTrip(startOdometer: Double, endOdometer: Double,
                 startTime: Date, endTime: Date, gpsAccuracy: Double) {
        let useCase = RecordTripUseCase()
        do {
            let trip = try useCase.execute(
                existingTrips: repository.trips,
                startOdometer: startOdometer,
                endOdometer: endOdometer,
                startTime: startTime,
                endTime: endTime,
                gpsAccuracy: gpsAccuracy
            )
            repository.add(trip)
            trips = repository.trips
            showAddTrip = false
        } catch let error as RecordTripUseCase.TripError {
            errorMessage = error.localizedDescription
            showError = true
        } catch { }
    }
}
