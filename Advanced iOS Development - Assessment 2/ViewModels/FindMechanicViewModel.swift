import Foundation
import Combine

class FindMechanicViewModel: ObservableObject {
    @Published var searchText: String = "" {
        didSet { search() }
    }
    @Published var recommended: [Mechanic] = []
    @Published var others: [Mechanic] = []

    private let repository = MechanicRepository()

    init() {
        search()
    }

    func search() {
        let result = SearchMechanicsUseCase().execute(mechanics: repository.mechanics, query: searchText)
        recommended = result.recommended
        others = result.others
    }
}
