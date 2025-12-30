//
//  CountriesService.swift
//  CountriesChallenge
//
//  Created by Matthew Ogtong on 12/30/25.
//

import Combine

protocol CountriesService {
    func fetchCountries() -> AnyPublisher<[Country], Error>
}
