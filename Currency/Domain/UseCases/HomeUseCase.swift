//
//  HomeUseCase.swift
//  Currency
//
//  Created by Shrouk Yasser on 09/12/2023.
//

import Foundation

class HomeUseCase {
    private let homeRepo: HomeRepoProtocol

    init(homeRepo: HomeRepoProtocol = HomeRepository()) {
        self.homeRepo = homeRepo
    }

    func fetchCurrencyRate(completion: @escaping (Result<Currency, Error>) -> Void) {
        homeRepo.fetchCurrencyRate(completion: completion)
    }
}
