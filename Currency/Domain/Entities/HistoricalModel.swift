//
//  HistoricalModel.swift
//  Currency
//
//  Created by Shrouk Yasser on 09/12/2023.
//

import Foundation

struct HistoricalModel: Codable, Hashable{
    let amount: String
    let date: String
    let fromCurrency: String
    let toCurrency: String
    let result: Float
}
