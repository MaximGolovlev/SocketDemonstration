//
//  FeedPresenter.swift
//  SoketDemonstrationApp
//
//  Created by  Macbook on 15.09.2020.
//  Copyright © 2020 Golovelv Maxim. All rights reserved.
//

import Foundation

protocol MonitorPresenterProtocol: class {
    func quotesDidFetch(quotes: [Quote])
    func qotesFetchedWith(error: Error)
}

class MonitorPresenter {
    
    private weak var viewController: MonitorPresenterProtocol?
    
    private var service: QuoteService?
    
    static let tickersToWatchChanges = ["RSTI", "GAZP", "MRKZ", "RUAL", "HYDR", "MRKS", "SBER", "FEES", "TGKA", "VTBR", "ANH.US", "VICL.US", "BURG.US", "NBL.US", "YETI.US", "WSFS.US", "NIO.US", "DXC.US", "MIC.US", "HSBC.US", "EXPN.EU", "GSK.EU", "SHP.EU", "MAN.EU", "DB1.EU", "MUV2.EU", "TATE.EU", "KGF.EU", "MGGT.EU", "SGGD.EU"]
    
    
    init(vc: MonitorPresenterProtocol?) {
        self.viewController = vc
    }
    
    func fetchQoutes(tickers: [String] = tickersToWatchChanges) throws {
        
        service = QuoteService()
        
        try service?.fetchQuotes(tickers: tickers) { [weak self] (result) in
            
            switch result {
            case .failure(let error):
                self?.viewController?.qotesFetchedWith(error: error)
            case .success(let items):
                self?.viewController?.quotesDidFetch(quotes: items)
            }
        }
    }
    
}
