//
//  SessionManager.swift
//  APIStructureTest
//
//  Created by Максим Головлев on 31/01/2020.
//  Copyright © 2020 Максим Головлев. All rights reserved.
//

import Foundation

typealias HTTPHeaders = [String: String]

protocol HTTPManagable: class {
    var acceptEncoding: String { get }
    var acceptLanguage: String { get }
    var userAgent: String { get }
    var token: String { get }
    var HTTPHeaders: HTTPHeaders { get }
    var session: URLSession { get set }
    
    init(delegate: URLSessionDelegate?, delegateQueue: OperationQueue?)
}

extension HTTPManagable {
    
    var acceptEncoding: String {
        return "gzip;q=1.0, compress;q=0.5"
    }
    
    var acceptLanguage: String {
        return Locale.preferredLanguages.prefix(6).enumerated().map { index, languageCode in
            let quality = 1.0 - (Double(index) * 0.1)
            return "\(languageCode);q=\(quality)"
        }.joined(separator: ", ")
    }
    
    var userAgent: String {
        if let info = Bundle.main.infoDictionary {
            let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
            let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
            let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
            let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"

            let osNameVersion: String = {
                let version = ProcessInfo.processInfo.operatingSystemVersion
                let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"

                let osName: String = {
                    #if os(iOS)
                        return "iOS"
                    #elseif os(watchOS)
                        return "watchOS"
                    #elseif os(tvOS)
                        return "tvOS"
                    #elseif os(macOS)
                        return "OS X"
                    #elseif os(Linux)
                        return "Linux"
                    #else
                        return "Unknown"
                    #endif
                }()

                return "\(osName) \(versionString)"
            }()

            return "\(executable)/\(appVersion) (\(bundle); build:\(appBuild); \(osNameVersion))"
        }
        
        return ""
    }
    
    var token: String {
        return ""
    }
    
    var HTTPHeaders: HTTPHeaders {
        return [
            "Accept-Encoding": acceptEncoding,
            "Accept-Language": acceptLanguage,
            "User-Agent": userAgent,
            "Authorization": "Bearer \(token)"
        ]
    }
}

class Retrier {
    private var count: Int
    private var delay: Double = 0
    
    init(count: Int, delay: Double = 0) {
        self.count = count
        self.delay = delay
    }
    
    class var `default`: Retrier {
        return Retrier(count: 3, delay: 3)
    }
    
    func retry(completion: @escaping () -> Void) throws {
        guard canTry else {
            throw HTTPError.retryError
        }
        count = count - 1
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: completion)
    }
    
    var canTry: Bool {
        return count > 0
    }
}


extension HTTPManagable {
    
    func perform(request: URLRequest?, oldPromise: Promise<(Data, URLResponse)>? = nil, retrier: Retrier = Retrier.default, isLogging: Bool = false) -> Future<(Data, URLResponse)> {
        
        let promise = oldPromise ?? Promise<(Data, URLResponse)>()
        
        guard let request = request else {
            promise.reject(with: HTTPError.invalidUrl)
            return promise
        }
        var body: [String: Any] = [:]
        if let data = request.httpBody, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            body = json
        }
        if isLogging {
            Logger.request(request: request.url?.absoluteString, body: body)
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                do {
                    try retrier.retry {
                        print("attempt to retry")
                        _ = self.perform(request: request, oldPromise: promise, retrier: retrier)
                    }
                } catch _ {
                    promise.reject(with: error)
                }
                
            } else {
                if isLogging {
                    Logger.response(request: request.url?.absoluteString, data: data)
                }
                promise.resolve(with: (data ?? Data(), response ?? URLResponse()))
            }
        }
        
        task.resume()
        
        return promise
    }
}

class HTTPManager: HTTPManagable {
    
    internal var session: URLSession
    
    required init(delegate: URLSessionDelegate? = nil, delegateQueue: OperationQueue? = .main) {
        
        let configuration = URLSessionConfiguration.default
        self.session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: delegateQueue)
        configuration.httpAdditionalHeaders = HTTPHeaders
    }
}

extension Future where Value == (Data, URLResponse) {
    func validate(using validResponses: [Int]) -> Future<(Data, URLResponse)> {
        chained { [weak self] (data, response) in

            let promise = Promise<(Data, URLResponse)>()
            promise.task = self?.task
            promise.request = self?.request
            
             if let response = response as? HTTPURLResponse {
                 if validResponses.contains(response.statusCode) {
                     promise.resolve(with: (data, response))
                 } else {
                    promise.reject(with: HTTPError.statusCodeError)
                 }
             }
             
             return promise
        }
    }
}

extension Future where Value == (Data, URLResponse) {
    func decodeHTTPResponse<T: Decodable>(using decoder: JSONDecoder = .init(), keypath: String? = nil) -> Future<T> {
        transformed { data, _ in
            
            guard let keypath = keypath else {
                
                if T.self == String.self {
                    return String(data: data, encoding: .utf8) as! T
                }
                
                return try decoder.decode(T.self, from: data)
            }
            
            let topLevelJSON = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
            if let nestedJSON = topLevelJSON.value(forKeyPath: keypath) {
                let nestedJSONData = try JSONSerialization.data(withJSONObject: nestedJSON, options: [])
                return try decoder.decode(T.self, from: nestedJSONData)
            } else {
                throw HTTPError.serializationError
            }
        }
    }
}


