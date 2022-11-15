//
//  RatesFluctuationViewModel.swift
//  ExchangeRates
//
//  Created by Robson Moreira on 15/11/22.
//

import Foundation
import SwiftUI

extension RatesFluctuationView {
    @MainActor class ViewModel: ObservableObject, RatesFluctuationDataProviderDelegate {
        @Published var ratesFluctuation = [RateFluctuationModel]()
        @Published var timeRange = TimeRangeEnum.today
        @Published var baseCurrency = "BRL"
        @Published var currencies = [String]()
        
        private let dataProvider: RatesFluctuationDataProvider?
        
        init(dataProvider: RatesFluctuationDataProvider = RatesFluctuationDataProvider()) {
            self.dataProvider = dataProvider
            self.dataProvider?.delegate = self
        }
        
        func doFetchRatesFluctuation(timeRange: TimeRangeEnum) {
            withAnimation {
                self.timeRange = timeRange
            }
            
            let startDate = timeRange.date
            let endDate = Date()
            dataProvider?.fetchFluctuation(by: baseCurrency, from: currencies, startDate: startDate.toString(), endDate: endDate.toString())
        }
        
        nonisolated func success(model: [RateFluctuationModel]) {
            DispatchQueue.main.async {
                withAnimation {
                    self.ratesFluctuation = model.sorted { $0.symbol < $1.symbol }
                }
            }
        }
    }
}
