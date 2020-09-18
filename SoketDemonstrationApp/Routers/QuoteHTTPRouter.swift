//
//  QuoteHTTPRouter.swift
//  SoketDemonstrationApp
//
//  Created by  Macbook on 19.09.2020.
//  Copyright © 2020 Golovelv Maxim. All rights reserved.
//

import Foundation

enum QuoteHTTPRouter: HTTPRouter {

    case fetchTopTickers(type: String, exchange: String, gainers: Bool, limit: Int)
    
    var action: String {
        switch self {
        case .fetchTopTickers:
            return "/api"
        }
    }

    var parameters: [String : String] {
        switch self {
        case .fetchTopTickers(let type, let exchange, let gainers, let limit):
            
            let json = ["cmd": "getTopSecurities", "params": ["type": type, "exchange": exchange, "gainers": gainers ? 1 : 0, "limit": limit]] as [String : Any]

            if let data =  try? JSONSerialization.data(withJSONObject: json),
                let jsonString = String(data: data, encoding: .utf8) {
                return ["q": jsonString]
            }
            return [:]
        }
    }

    var body: [String : Any]? {
        return nil
    }

    var dataKey: String? {
        return nil
    }

    var method: HTTPMethod {
        return .post
    }
}
