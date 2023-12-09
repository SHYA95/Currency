//
//  HistoricalRepoProtocol.swift
//  Currency
//
//  Created by Shrouk Yasser on 09/12/2023.
//

import Foundation

protocol HistoricalRepoProtocol {
    func readConversionResult(completion: @escaping (Result<[HistoricalModel], Error>) -> Void)
    func saveConversionResult(historicalItem: [HistoricalModel], list: inout [HistoricalModel], completion: @escaping (Result<Void, Error>) -> Void)
}
