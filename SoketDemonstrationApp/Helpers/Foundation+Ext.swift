//
//  Foundation+Ext.swift
//  SoketDemonstrationApp
//
//  Created by  Macbook on 21.09.2020.
//  Copyright © 2020 Golovelv Maxim. All rights reserved.
//

import Foundation

extension Double {
    func decimalCount(max: Int) -> Int {
        if self == Double(Int(self)) {
            return 0
        }

        let integerString = String(Int(self))
        
        let number = NSNumber(value: self)
        let doubleString = "\(number.decimalValue)"
        
        let decimalCount = doubleString.count - integerString.count - 1

        return min(decimalCount, max)
    }
}
