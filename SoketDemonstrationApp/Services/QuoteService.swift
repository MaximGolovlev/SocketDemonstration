//
//  Quotes.swift
//  SoketDemonstrationApp
//
//  Created by  Macbook on 15.09.2020.
//  Copyright © 2020 Golovelv Maxim. All rights reserved.
//

import Foundation

class QuoteService: APIService {
    
    private var socketManager: SoketManager?
    private var httpManager: HTTPManager?
    
    func fetchQuotes(tickers: [String], completion: @escaping (Result<[Quote], Error>) -> Void) throws {
        
        let r = QuoteSocketRouter.quotesChangeSubscribtion(tickersToWatch: tickers)
        
        socketManager = try SoketManager(socketURL: r.baseUrl, config: [.log(true), .compress])
        
        socketManager?
            .connectIfNeeded()
            .emit(event: r.requestEvent, items: r.soketData)
            .handle(event: r.responseEvent)
            .decodeSocketResponse(event: r.responseEvent)
            .observe(shouldDispose: false, using: completion)
    }
    
    func fetchTopTickers(type: String, exchange: String, gainers: Bool, limit: Int, completion: @escaping (Result<[String], Error>) -> Void) -> URLSessionDataTask? {
        
        let r = QuoteHTTPRouter.fetchTopTickers(type: type, exchange: exchange, gainers: gainers, limit: limit)
        
        httpManager = HTTPManager()
        
        return httpManager?
            .perform(request: r.asURLRequest(), isLogging: true)
            .validate(using: acceptableStatusCodes)
            .decodeHTTPResponse(using: jsonDecoder, keypath: "tickers")
            .observe(using: completion)
        
    }
    
}
