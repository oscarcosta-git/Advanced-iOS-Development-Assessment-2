import Foundation

/// The user's car. All maintenance records and odometer readings belong to this vehicle.
struct Vehicle {
    var make: String
    var model: String
    var year: Int
    var plate: String

    static let sample = Vehicle(make: "Toyota", model: "Corolla", year: 2021, plate: "ABC123")
}
