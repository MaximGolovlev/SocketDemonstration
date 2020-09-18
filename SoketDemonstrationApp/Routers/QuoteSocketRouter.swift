//
//  QuoteRouter.swift
//  SoketDemonstrationApp
//
//  Created by  Macbook on 15.09.2020.
//  Copyright © 2020 Golovelv Maxim. All rights reserved.
//

import Foundation
import SocketIO

enum QuoteSocketRouter: SoketRouter {
    
    case quotesChangeSubscribtion(tickersToWatch: [String])
    
    var requestEvent: String {
        switch self {
        case .quotesChangeSubscribtion:
            return "sup_updateSecurities2"
        }
    }
    
    var responseEvent: String {
        switch self {
        case .quotesChangeSubscribtion:
            return "q"
        }
    }
    
    var soketData: [SocketData] {
        switch self {
        case .quotesChangeSubscribtion(let tickersToWatch):
            return tickersToWatch
        }
    }
}
