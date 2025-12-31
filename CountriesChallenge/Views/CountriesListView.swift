//
//  CountriesListView.swift
//  CountriesChallenge
//
//  Created by Matthew Ogtong on 12/30/25.
//

import SwiftUI

struct CountriesListView: View {
    @ObservedObject var viewModel: CountriesViewModel

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Countries")
        }
        .onAppear {
            if viewModel.viewState == .idle {
                viewModel.fetchCountries()
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.viewState {
        case .idle, .loading:
            ProgressView("Loading countries...")

        case .loaded:
            List(viewModel.countries) { country in
                CountryRowView(country: country)
            }

        case .empty:
            ContentUnavailableView(
                "No Countries",
                systemImage: "globe",
                description: Text("No countries were found.")
            )

        case .error(let message):
            ContentUnavailableView {
                Label("Error", systemImage: "exclamationmark.triangle")
            } description: {
                Text(message)
            } actions: {
                Button("Retry") {
                    viewModel.fetchCountries()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

#Preview {
    CountriesListView(viewModel: CountriesViewModel(service: CountriesAPIService()))
}
