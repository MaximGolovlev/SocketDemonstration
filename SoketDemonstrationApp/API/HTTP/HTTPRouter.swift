//
//  Router.swift
//  APIStructureTest
//
//  Created by Максим Головлев on 31/01/2020.
//  Copyright © 2020 Максим Головлев. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

enum URLScheme: String {
    case https = "https"
    case http = "http"
}

protocol URLRequestConvertible {
    func asURLRequest() -> URLRequest?
}

extension URLRequestConvertible where Self: HTTPRouter {
    func asURLRequest() -> URLRequest? {
        
        var components = URLComponents()
        components.port = port
        components.scheme = scheme.rawValue
        components.host = baseURL
        components.path = action
        
        if !parameters.keys.isEmpty {
            components.queryItems = parameters.compactMap({ URLQueryItem(name: $0.key, value: $0.value) })
        }
        
        guard let url = components.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        if let bodyData = bodyData {
            request.httpBody = bodyData
        }
        
        if let body = body, let data = try? JSONSerialization.data(withJSONObject: body, options: []) {
            request.httpBody = data
        }
        
        return request
    }
}

protocol HTTPRouter: URLRequestConvertible {
    var scheme: URLScheme { get }
    var baseURL: String { get }
    var action: String { get }
    var parameters: [String: String] { get }
    var body: [String: Any]? { get }
    var bodyData: Data? { get }
    var dataKey: String? { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var deviceId: String { get }
}

extension HTTPRouter {

    var scheme: URLScheme {
        return .https
    }
    
    var baseURL: String {
        return "tradernet.ru"
    }
    
    var port: Int? {
        return nil
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    
    var deviceId: String {
        return UUID().uuidString
    }
    
    var bodyData: Data? {
        return nil
    }
    
}


