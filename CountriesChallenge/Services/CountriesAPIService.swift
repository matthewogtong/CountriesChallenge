//
//  CountriesAPIService.swift
//  CountriesChallenge
//
//  Created by Matthew Ogtong on 12/30/25.
//

import Foundation
import Combine

final class CountriesAPIService: CountriesService {
    private let session: URLSession
    private let url: URL

    init(
        session: URLSession = .shared,
        url: URL = URL(string: APIConstants.baseURL)!
    ) {
        self.session = session
        self.url = url
    }

    func fetchCountries() -> AnyPublisher<[Country], Error> {
        session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Country].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
