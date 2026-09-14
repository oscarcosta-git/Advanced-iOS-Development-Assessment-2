import Foundation
import Combine

class MyCarViewModel: ObservableObject {
    @Published var vehicle: Vehicle = Vehicle.sample
    @Published var records: [MaintenanceRecord] = []
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var showAddRecord: Bool = false

    private let repository = MaintenanceRepository()

    init() {
        records = repository.records
    }

    func addRecord(date: Date, odometer: Double, description: String,
                   mechanic: String, costAUD: Double) {
        let useCase = LogMaintenanceUseCase()
        do {
            let record = try useCase.execute(
                existingRecords: repository.records,
                date: date,
                odometer: odometer,
                description: description,
                mechanic: mechanic,
                costAUD: costAUD
            )
            repository.add(record)
            records = repository.records
            showAddRecord = false
        } catch let error as LogMaintenanceUseCase.MaintenanceError {
            errorMessage = error.localizedDescription
            showError = true
        } catch { }
    }
}
