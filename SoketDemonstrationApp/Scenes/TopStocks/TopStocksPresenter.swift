//
//  TopStocksPresenter.swift
//  SoketDemonstrationApp
//
//  Created by  Macbook on 18.09.2020.
//  Copyright © 2020 Golovelv Maxim. All rights reserved.
//

import Foundation

protocol TopStocksProtocol: class {
    func stocksDidFetch(items: [String])
    func failed(with error: Error)
}

class TopStocksPresenter {
    
    private weak var viewController: TopStocksProtocol?
    
    private var service: QuoteService?
    
    init(vc: TopStocksProtocol?) {
        self.viewController = vc
    }
    
    func fetchTopStocks(type: String, exchange: String, gainers: Bool, limit: Int) -> URLSessionDataTask? {
        service = QuoteService()
        return service?.fetchTopTickers(type: type, exchange: exchange, gainers: gainers, limit: limit, completion: { [weak self] (result) in
            
            switch result {
            case .failure(let error):
                self?.viewController?.failed(with: error)
            case .success(let items):
                self?.viewController?.stocksDidFetch(items: items)
            }
            
        })
    }
}
