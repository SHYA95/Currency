//
//  HomeViewModel.swift
//  Currency
//
//  Created by Shrouk Yasser on 09/12/2023.
//

import RxSwift
import RxRelay
import UIKit

class HomeViewModel {
    
    // MARK: - Variables
    var amountBehavior: BehaviorRelay<String> = .init(value: "1")
    var fromCurrencyBehavior: BehaviorRelay<String> = .init(value: "")
    var toCurrencyBehavior: BehaviorRelay<String> = .init(value: "")
    var swipCurrencyChange: PublishSubject<Void> = .init()
    var resultCurrenyPublisher: PublishSubject<Float> = .init()
    var currencyBehavior: BehaviorRelay<[String]> = .init(value: [])
    var isConnected: BehaviorRelay<Bool> = .init(value: true)
    let showAlert = PublishSubject<String>()
    var currencies: Currency?
    private let historicalUseCase: HistoricalUseCase
    private let homeUseCase: HomeUseCase
    private let bag = DisposeBag()
    private let fileName = "conversion_result.json"
    private var list = [HistoricalModel]()
    
    // MARK: - Init
    init(homeUseCase: HomeUseCase = HomeUseCase(), historicalUseCase: HistoricalUseCase = HistoricalUseCase( historicalRepo: HistoricalRepository())) {
        self.homeUseCase = homeUseCase
        self.historicalUseCase = historicalUseCase
    }
    
    // MARK: - viewDidLoad
    func viewDidLoad() {
        currencySymbolsRequest()
        swipCurrencySymbols()
        observeInternetConnectivity()
    }
    
    // combineFromToFields
    func combineFromToFields() -> Observable<(String, String)> {
        Observable.combineLatest(fromCurrencyBehavior.asObservable(),
                                 toCurrencyBehavior.asObservable())
    }
    
    // Subscribe to Amount Value
    func fetchResult() {
        if !fromCurrencyBehavior.value.isEmpty && !toCurrencyBehavior.value.isEmpty && fromCurrencyBehavior.value != toCurrencyBehavior.value {
            if let amount = Float(amountBehavior.value) {
                convert(amount: amount, from: fromCurrencyBehavior.value, to: toCurrencyBehavior.value)
                    .subscribe(onNext: { [weak self] convertedAmount in
                        guard let self = self else { return }
                        self.resultCurrenyPublisher.onNext(convertedAmount)
                    })
                    .disposed(by: bag)
            }
        } else {
            showAlert.onNext(AppError.enterAllFields.localizedDescription)
        }
    }
    
    // swipCurrencySymbols
    private func swipCurrencySymbols() {
        swipCurrencyChange
            .throttle(RxTimeInterval.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let toValue = self.toCurrencyBehavior.value
                let fromValue = self.fromCurrencyBehavior.value
                self.fromCurrencyBehavior.accept(toValue)
                self.toCurrencyBehavior.accept(fromValue)
            })
            .disposed(by: bag)
    }
    
    // Symbols from api to present in picker view
    private func currencySymbolsRequest() {
        homeUseCase.fetchCurrencyRate { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let currencies):
                self.currencies = currencies
                let currenciesSymbols = Array(currencies.rates.keys)
                self.currencyBehavior.accept(currenciesSymbols)
            case .failure(let error):
                print("Error fetching currency rates: \(error.localizedDescription)")
            }
        }
    }

    
    func observeInternetConnectivity() {
        if Reachability.isConnectedToNetwork() {
            isConnected.accept(false)
        } else {
            isConnected.accept(true)
        }
    }
    
    // convert currency method
    private func convert(amount: Float, from baseCurrency: String, to targetCurrency: String) -> Observable<Float> {
        guard let currencies = currencies else {
            return Observable.error(AppError.currencies)
        }
        
        guard let baseRate = currencies.rates[baseCurrency] else {
            return Observable.error(AppError.baseRate)
        }
        
        guard let targetRate = currencies.rates[targetCurrency] else {
            return Observable.error(AppError.targetRate)
        }
        
        let convertedAmount = (amount / baseRate) * targetRate
        print("Result is \(convertedAmount)")
        self.resultCurrenyPublisher.onNext(convertedAmount)
        
        // call save data in local
        let historicalModel = HistoricalModel(amount: amountBehavior.value, date: currencies.date, fromCurrency: baseCurrency, toCurrency: targetCurrency, result: convertedAmount)
        saveConversionResult(historicalItem: [historicalModel])
        
        return Observable.just(convertedAmount)
    }
    
    // save data in file local
    private func saveConversionResult(historicalItem: [HistoricalModel]) {
            historicalUseCase.saveConversionResult(historicalItem: historicalItem, list: &list) { result in
                switch result {
                case .success:
                    
                    print("Conversion result saved successfully.")
                case .failure(let error):
                  
                    print("Error saving conversion result: \(error.localizedDescription)")
                }
            }
        }

}
