//
//  Quote.swift
//  SoketDemonstrationApp
//
//  Created by  Macbook on 15.09.2020.
//  Copyright © 2020 Golovelv Maxim. All rights reserved.
//

import Foundation
import UIKit

struct Quote: Codable {
    
    enum ColorScheme {
        case red
        case green
        case none
        
        var bgColor: UIColor {
            switch self {
            case .red:
                return #colorLiteral(red: 1, green: 0.1960784314, blue: 0.2784313725, alpha: 1)
            case .green:
                return #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            case .none:
                return #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .red:
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            case .green:
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            case .none:
                return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
    }
    
    var c: String
    var pcp: Double?
    var ltr: String?
    var name: String?
    var ltp: String?
    var chg: String? = nil
    var minStep: Double?
    
    private var chgDouble: Double?
    
    var imageUrl: String {
        return "https://tradernet.ru/logos/get-logo-by-ticker?ticker=\(c.lowercased())"
    }
    
    enum CodingKeys: String, CodingKey {
        case c, pcp, ltr, name, ltp, chg, minStep = "min_step"
    }
    
    var pcpColor: ColorScheme {
        if let pcp = pcp {
            if pcp == 0 { return .none }
            return pcp > 0 ? .green : .red
        }
        return .none
    }
    
    var pcpString: String? {
        if let pcp = pcp {
            let modifier = pcp > 0 ? "+" : ""
            return "\(modifier)\(pcp)%"
        }
        
        return nil
    }
    
    var chgString: String? {
        if let chg = chg, let chgDouble = chgDouble {
            let modifier = chgDouble > 0 ? "+" : ""
            return "( \(modifier)\(chg) )"
        }
        
        return nil
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.c = try values.decode(String.self, forKey: .c)
        self.pcp = try? values.decode(Double?.self, forKey: .pcp)
        self.ltr = try? values.decode(String?.self, forKey: .ltr)
        self.name = try? values.decode(String?.self, forKey: .name)
        
        let minStep = (try? values.decode(Double?.self, forKey: .minStep)) ?? 0.000_001
        let stepCounts = minStep.decimalCount(max: 6)
        
        let ltpDouble = try? values.decode(Double?.self, forKey: .ltp)
        self.chgDouble = try? values.decode(Double?.self, forKey: .chg)
        
        if let ltpDouble = ltpDouble {
            self.ltp = String(format: "%.\(stepCounts)f", ltpDouble)
        }
        
        if let chgDouble = chgDouble {
            let divisor = pow(10.0, Double(stepCounts))
            self.chg = String(format: "%.\(stepCounts)f", (ceil(chgDouble*divisor)/divisor))
        }
        
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
