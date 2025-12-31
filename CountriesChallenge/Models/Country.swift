//
//  Country.swift
//  CountriesChallenge
//
//  Created by Matthew Ogtong on 12/30/25.
//

import Foundation

struct Country: Codable, Identifiable, Equatable {
    let name: String
    let region: String
    let code: String
    let capital: String

    var id: String { code }
}
