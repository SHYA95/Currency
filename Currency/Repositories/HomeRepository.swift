//
//  HomeRepository.swift
//  Currency
//
//  Created by Shrouk Yasser on 09/12/2023.
//

import Foundation

class HomeRepoImple: HomeRepoProtocol {
    private let networkService: MoyaNetworkService

    init(networkService: MoyaNetworkService = MoyaNetworkService()) {
        self.networkService = networkService
    }

    func fetchCurrencyRate(completion: @escaping (Result<Currency, Error>) -> Void) {
        networkService.performRequest(.fetchCurrencyRate) { result in
            switch result {
            case let .success(data):
                do {
                    let currenciesRateList = try JSONDecoder().decode(Currency.self, from: data)
                    completion(.success(currenciesRateList))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
