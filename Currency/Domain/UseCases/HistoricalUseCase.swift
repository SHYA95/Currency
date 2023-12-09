//
//  HistoricalUseCase.swift
//  Currency
//
//  Created by Shrouk Yasser on 09/12/2023.
//

import Foundation

class HistoricalUseCase {
    private let historicalRepo: HistoricalRepoProtocol

    init(historicalRepo: HistoricalRepoProtocol = HistoricalRepository()) {
        self.historicalRepo = historicalRepo
    }

    func readConversionResult(completion: @escaping (Result<[HistoricalModel], Error>) -> Void) {
        historicalRepo.readConversionResult(completion: completion)
    }

    func saveConversionResult(historicalItem: [HistoricalModel], list: inout [HistoricalModel], completion: @escaping (Result<Void, Error>) -> Void) {
        historicalRepo.saveConversionResult(historicalItem: historicalItem, list: &list, completion: completion)
    }
}
