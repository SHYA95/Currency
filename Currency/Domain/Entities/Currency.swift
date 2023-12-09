//
//  Currency.swift
//  Currency
//
//  Created by Shrouk Yasser on 09/12/2023.
//

import Foundation
// MARK: - Currency
struct Currency: Codable {
    let success: Bool
    let timestamp: Int
    let base, date: String
    let rates: [String: Float]
}
