//
//  CountriesChallengeTests.swift
//  CountriesChallengeTests
//
//  Created by Matthew Ogtong on 12/30/25.
//

import XCTest
@testable import CountriesChallenge

final class CountriesChallengeTests: XCTestCase {
    func testCountryModel() {
        let country = Country(
            name: "France",
            region: "EU",
            code: "FR",
            capital: "Paris"
        )

        XCTAssertEqual(country.id, "FR")
        XCTAssertEqual(country.name, "France")
        XCTAssertEqual(country.region, "EU")
        XCTAssertEqual(country.capital, "Paris")
    }

    func testCountryEquatable() {
        let country1 = Country(name: "France", region: "EU", code: "FR", capital: "Paris")
        let country2 = Country(name: "France", region: "EU", code: "FR", capital: "Paris")
        let country3 = Country(name: "Germany", region: "EU", code: "DE", capital: "Berlin")

        XCTAssertEqual(country1, country2)
        XCTAssertNotEqual(country1, country3)
    }
}
