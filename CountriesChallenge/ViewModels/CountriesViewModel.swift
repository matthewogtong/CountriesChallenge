//
//  CountriesViewModel.swift
//  CountriesChallenge
//
//  Created by Matthew Ogtong on 12/30/25.
//

import Foundation
import Combine

final class CountriesViewModel: ObservableObject {
    enum ViewState: Equatable {
        case idle
        case loading
        case loaded
        case empty
        case error(String)

        static func == (lhs: ViewState, rhs: ViewState) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle), (.loading, .loading), (.loaded, .loaded), (.empty, .empty):
                return true
            case let (.error(lhsMessage), .error(rhsMessage)):
                return lhsMessage == rhsMessage
            default:
                return false
            }
        }
    }

    @Published private(set) var countries: [Country] = []
    @Published private(set) var viewState: ViewState = .idle

    private let service: CountriesService
    private var cancellables = Set<AnyCancellable>()

    init(service: CountriesService) {
        self.service = service
    }

    func fetchCountries() {
        viewState = .loading

        service.fetchCountries()
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.viewState = .error(error.localizedDescription)
                }
            } receiveValue: { [weak self] countries in
                self?.countries = countries
                self?.viewState = countries.isEmpty ? .empty : .loaded
            }
            .store(in: &cancellables)
    }
}
