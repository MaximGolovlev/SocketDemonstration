//
//  Soxket.swift
//  SoketDemonstrationApp
//
//  Created by  Macbook on 18.09.2020.
//  Copyright © 2020 Golovelv Maxim. All rights reserved.
//

import Foundation

enum HTTPError: Error {
    case invalidUrl
    case connectionError
    case managerDeallocated
    case isNotValidJson
    case serializationError
    case statusCodeError
    case retryError
    
    var localizedDescription: String {
        
        switch self {
        case .invalidUrl:
            return "HTTP manager provided with invalid url"
        case .connectionError:
            return "HTTP manager connection error"
        case .managerDeallocated:
            return "HTTP manager has been deallocated"
        case .isNotValidJson:
            return "HTTP response is not a valid json"
        case .serializationError:
            return "HTTP response serialization error"
        case .statusCodeError:
            return "HTTP response status code is invalid"
        case .retryError:
            return "Retry attempts is over"
        }
    }
}

enum SocketError: Error {
    case invalidUrl
    case connectionError
    case managerDeallocated
    case isNotValidJson
    case serializationError(error: Error)
    
    var localizedDescription: String {
        
        switch self {
        case .invalidUrl:
            return "Socket manager provided with invalid url"
        case .connectionError:
            return "Socket manager connection error"
        case .managerDeallocated:
            return "Socket manager has been deallocated"
        case .isNotValidJson:
            return "Socket response is not a valid json"
        case .serializationError(let error):
            return "Socket response serialization error: \(error.localizedDescription)"
        }
    }
}
