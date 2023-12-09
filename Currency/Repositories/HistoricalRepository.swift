//
//  HistoricalRepository.swift
//  Currency
//
//  Created by Shrouk Yasser on 09/12/2023.
//

import Foundation

class HistoricalRepository: HistoricalRepoProtocol {
    private let networkService: MoyaNetworkService
    private let fileName = "conversion_result.json"

    init(networkService: MoyaNetworkService = MoyaNetworkService()) {
        self.networkService = networkService
    }

    func readConversionResult(completion: @escaping (Result<[HistoricalModel], Error>) -> Void) {
        networkService.performRequest(.readConversionResult) { result in
            switch result {
            case let .success(data):
                do {
                    let results = try JSONDecoder().decode([HistoricalModel].self, from: data)

                    completion(.success(results))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func saveConversionResult(historicalItem: [HistoricalModel], list: inout [HistoricalModel], completion: @escaping (Result<Void, Error>) -> Void) {
        networkService.performRequest(.saveConversionResult(historicalItem: historicalItem)) { result in
            switch result {
            case .success:
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
