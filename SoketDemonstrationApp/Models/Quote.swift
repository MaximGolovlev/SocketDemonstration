//
//  Quote.swift
//  SoketDemonstrationApp
//
//  Created by  Macbook on 15.09.2020.
//  Copyright © 2020 Golovelv Maxim. All rights reserved.
//

import Foundation

struct Quote: Codable {
    
    var c: String
    var pcp: Double?
    var ltr: String?
    var name: String?
    var ltp: Double?
    var chg: Double?
    
    var imageUrl: String {
        return "https://tradernet.ru/logos/get-logo-by-ticker?ticker=\(c.lowercased())"
    }
    
    mutating func applyChanges(from quote: Quote) {
        self.c = quote.c
        
        if let pcp = quote.pcp {
            self.pcp = pcp
        }
        if let ltr = quote.ltr {
            self.ltr = ltr
        }
        if let name = quote.name {
            self.name = name
        }
        if let ltp = quote.ltp {
            self.ltp = ltp
        }
        if let chg = quote.chg {
            self.chg = chg
        }
        
    }
}
