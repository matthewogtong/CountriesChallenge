//
//  CountriesViewModelTests.swift
//  CountriesChallengeTests
//
//  Created by Matthew Ogtong on 12/30/25.
//

import XCTest
import Combine
@testable import CountriesChallenge

final class CountriesViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }

    func testInitialState() {
        let viewModel = CountriesViewModel(service: MockCountriesService())

        XCTAssertEqual(viewModel.viewState, .idle)
        XCTAssertTrue(viewModel.countries.isEmpty)
    }

    func testFetchCountriesSuccess() {
        let mockCountries = [
            Country(name: "United States", region: "NA", code: "US", capital: "Washington, D.C."),
            Country(name: "Canada", region: "NA", code: "CA", capital: "Ottawa")
        ]
        let mockService = MockCountriesService(result: .success(mockCountries))
        let viewModel = CountriesViewModel(service: mockService)

        let expectation = XCTestExpectation(description: "Fetch countries success")

        viewModel.$viewState
            .dropFirst()
            .sink { state in
                if state == .loaded {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.fetchCountries()

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(viewModel.viewState, .loaded)
        XCTAssertEqual(viewModel.countries.count, 2)
        XCTAssertEqual(viewModel.countries.first?.name, "United States")
    }

    func testFetchCountriesEmpty() {
        let mockService = MockCountriesService(result: .success([]))
        let viewModel = CountriesViewModel(service: mockService)

        let expectation = XCTestExpectation(description: "Fetch countries empty")

        viewModel.$viewState
            .dropFirst()
            .sink { state in
                if state == .empty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.fetchCountries()

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(viewModel.viewState, .empty)
        XCTAssertTrue(viewModel.countries.isEmpty)
    }

    func testFetchCountriesError() {
        let mockError = NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        let mockService = MockCountriesService(result: .failure(mockError))
        let viewModel = CountriesViewModel(service: mockService)

        let expectation = XCTestExpectation(description: "Fetch countries error")

        viewModel.$viewState
            .dropFirst()
            .sink { state in
                if case .error = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.fetchCountries()

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(viewModel.viewState, .error("Network error"))
    }

    func testLoadingStateTransition() {
        let mockService = MockCountriesService(result: .success([]))
        let viewModel = CountriesViewModel(service: mockService)

        let expectation = XCTestExpectation(description: "Loading state observed")

        viewModel.$viewState
            .dropFirst()
            .first()
            .sink { state in
                XCTAssertEqual(state, .loading)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.fetchCountries()

        wait(for: [expectation], timeout: 1.0)
    }
}

// MARK: - Mock Service

private final class MockCountriesService: CountriesService {
    private let result: Result<[Country], Error>

    init(result: Result<[Country], Error> = .success([])) {
        self.result = result
    }

    func fetchCountries() -> AnyPublisher<[Country], Error> {
        result.publisher
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
