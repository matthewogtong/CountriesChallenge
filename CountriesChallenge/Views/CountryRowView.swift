//
//  CountryRowView.swift
//  CountriesChallenge
//
//  Created by Matthew Ogtong on 12/30/25.
//

import SwiftUI

struct CountryRowView: View {
    let country: Country

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("\(country.name), \(country.region)")
                Spacer()
                Text(country.code)
            }
            Text(country.capital.isEmpty ? "N/A" : country.capital)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    CountryRowView(country: Country(
        name: "United States",
        region: "NA",
        code: "US",
        capital: "Washington, D.C."
    ))
    .padding()
}
