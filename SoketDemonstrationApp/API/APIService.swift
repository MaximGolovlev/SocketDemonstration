//
//  APIService.swift
//  APIStructureTest
//
//  Created by Максим Головлев on 07/02/2020.
//  Copyright © 2020 Максим Головлев. All rights reserved.
//

import Foundation

protocol APIService {
    var acceptableStatusCodes: [Int] { get }
    var jsonDecoder: JSONDecoder { get }
}

extension APIService {
    var acceptableStatusCodes: [Int] {
        return Array(200..<300)
    }
    
    var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
