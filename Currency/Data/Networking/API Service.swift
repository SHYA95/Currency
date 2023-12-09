//
//  API Service.swift
//  Currency
//
//  Created by Shrouk Yasser on 09/12/2023.
//

import Foundation
import Moya

enum APIService {
    case fetchCurrencyRate
    case readConversionResult
    case saveConversionResult(historicalItem: [HistoricalModel])
}

extension APIService: TargetType {
    var baseURL: URL {
        return URL(string: Constants.fixerBaseURL)!
    }

    var path: String {
        switch self {
        case .fetchCurrencyRate:
            return Constants.fixorPath
        case .readConversionResult, .saveConversionResult:
            return ""
        }
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .fetchCurrencyRate:
            let parameters: [String: Any] = [
                Constants.access_keyName: Constants.access_key,
                Constants.format: "1"
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)

        case .readConversionResult, .saveConversionResult:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return nil
    }
}

class MoyaNetworkService {
    private let provider = MoyaProvider<APIService>()

    func performRequest(_ apiService: APIService, completion: @escaping (Result<Data, Error>) -> Void) {
        provider.request(apiService) { result in
            switch result {
            case let .success(response):
                completion(.success(response.data))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
