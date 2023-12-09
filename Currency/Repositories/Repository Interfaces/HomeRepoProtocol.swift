//
//  HomeRepoProtocol.swift
//  Currency
//
//  Created by Shrouk Yasser on 09/12/2023.
//

import Foundation

protocol HomeRepoProtocol {
    func fetchCurrencyRate(completion: @escaping (Result<Currency, Error>) -> Void)
}
