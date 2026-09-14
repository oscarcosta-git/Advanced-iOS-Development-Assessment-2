import Foundation
import Testing
@testable import Advanced_iOS_Development___Assessment_2

@Suite("SearchMechanicsUseCase")
@MainActor
struct SearchMechanicsUseCaseTests {

    let useCase = SearchMechanicsUseCase()

    let mechanics: [Mechanic] = [
        Mechanic(name: "Top Shop", suburb: "Surry Hills",
                 rating: 4.8, isVerified: true, specialties: ["Brakes"]),
        Mechanic(name: "Mid Shop", suburb: "Redfern",
                 rating: 4.0, isVerified: true, specialties: ["Tyres"]),
        Mechanic(name: "Low Shop", suburb: "Newtown",
                 rating: 3.5, isVerified: false, specialties: ["Oil Changes"]),
        Mechanic(name: "Unverified High", suburb: "Glebe",
                 rating: 4.7, isVerified: false, specialties: ["Servicing"]),
    ]

    // MARK: Happy path

    @Test("Verified mechanics at or above 4.0 appear in recommended")
    func recommendedIsVerifiedAndHighRating() {
        let result = useCase.execute(mechanics: mechanics, query: "")
        let names = result.recommended.map { $0.name }
        #expect(names.contains("Top Shop"))
        #expect(names.contains("Mid Shop"))
        #expect(!names.contains("Low Shop"))
        #expect(!names.contains("Unverified High"))
    }

    @Test("Unverified mechanic with high rating goes to others")
    func unverifiedGoesToOthers() {
        let result = useCase.execute(mechanics: mechanics, query: "")
        let names = result.others.map { $0.name }
        #expect(names.contains("Unverified High"))
    }

    // MARK: Boundary

    @Test("Mechanic exactly at rating 4.0 is recommended")
    func exactlyAtThreshold() {
        let result = useCase.execute(mechanics: mechanics, query: "")
        #expect(result.recommended.contains { $0.name == "Mid Shop" })
    }

    // MARK: Search filter

    @Test("Query filters results by name")
    func queryFiltersByName() {
        let result = useCase.execute(mechanics: mechanics, query: "Top")
        #expect(result.recommended.count == 1)
        #expect(result.recommended.first?.name == "Top Shop")
    }

    @Test("Empty query returns all mechanics")
    func emptyQueryReturnsAll() {
        let result = useCase.execute(mechanics: mechanics, query: "")
        #expect(result.recommended.count + result.others.count == mechanics.count)
    }
}
