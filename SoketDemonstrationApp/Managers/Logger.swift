//
//  Logger.swift
//  BackMyCash
//
//  Created by User on 18.02.2019.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

class Logger {
    
    static func request(request: String?, body: [String: Any]) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted) else { return }
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print("\nHTTP request: \(request ?? "")\nBody: \(jsonString)\n")
        }
    }
    
    static func response(request: String?, data: Data?) {
        guard let data = data else { return }
        if let jsonString = String(data: data, encoding: .utf8) {
            print("\nHTTP response: \(request ?? "")\nParams: \(jsonString)\n")
        }
    }
    
}
