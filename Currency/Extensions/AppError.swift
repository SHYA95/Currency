//
//  AppError.swift
//  Currency
//
//  Created by Shrouk Yasser on 09/12/2023.
//

import Foundation

enum AppError: Error {
    case enterAllFields
    case baseRate
    case targetRate
    case currencies
    case invalidDirectory
    case dataEncodingFailed
    case fileNotFound
    case dataConversionFailed
    case invalidURL
    case noData
    case noInternet
    case generalError
    case fromTXIsEmpty
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noInternet:
            return NSLocalizedString("No Internet Connection, Please try again Later!", comment: "")
        case .enterAllFields:
            return NSLocalizedString("You should fill all required data in order to continue", comment: "")
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "")
        case .noData:
            return NSLocalizedString("No Data", comment: "")
        case .generalError:
            return NSLocalizedString("Something went wrong, Please try again!", comment: "")
        case .baseRate:
            return  NSLocalizedString("baseRate", comment: "")
        case .targetRate:
            return NSLocalizedString("targetRate", comment: "")
        case .currencies:
            return NSLocalizedString("currencies", comment: "")
        case .invalidDirectory:
            return NSLocalizedString("invalidDirectory", comment: "")
        case .dataEncodingFailed:
            return NSLocalizedString("dataEncodingFailed", comment: "")
        case .fileNotFound:
            return NSLocalizedString("fileNotFound", comment: "")
        case .dataConversionFailed:
            return NSLocalizedString("dataConversionFailed", comment: "")
        case .fromTXIsEmpty:
            return NSLocalizedString("You should choose base currency", comment: "")
        }
    }
}
