import Foundation

/// A workshop or mechanic that users can search for.
/// Only verified mechanics with a rating of 4.0+ show as "recommended".
struct Mechanic: Identifiable {
    let id = UUID()
    let name: String
    let suburb: String
    let rating: Double      // 0–5
    let isVerified: Bool
    let specialties: [String]
}

extension Mechanic {
    static let samples: [Mechanic] = [
        Mechanic(name: "Quick Fix Auto", suburb: "Surry Hills",
                 rating: 4.8, isVerified: true,
                 specialties: ["Servicing", "Brakes", "Electrical"]),
        Mechanic(name: "City Motors", suburb: "Redfern",
                 rating: 4.5, isVerified: true,
                 specialties: ["Servicing", "Tyres"]),
        Mechanic(name: "Bob's Workshop", suburb: "Marrickville",
                 rating: 4.1, isVerified: true,
                 specialties: ["Mechanical", "Exhaust"]),
        Mechanic(name: "Discount Auto", suburb: "Parramatta",
                 rating: 3.6, isVerified: false,
                 specialties: ["Tyres", "Oil Changes"]),
        Mechanic(name: "Fast Lane Service", suburb: "Newtown",
                 rating: 3.0, isVerified: false,
                 specialties: ["General Servicing"]),
    ]
}
