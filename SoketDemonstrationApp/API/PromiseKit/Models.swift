//
//  Models.swift
//  APIStructureTest
//
//  Created by Максим Головлев on 06/02/2020.
//  Copyright © 2020 Максим Головлев. All rights reserved.
//

import Foundation

class Future<Value> {
    typealias Result = Swift.Result<Value, Error>
    
    fileprivate var result: Result? {
        // Observe whenever a result is assigned, and report it:
        didSet { result.map(report) }
    }
    private var callbacks = [(Result) -> Void]()
    
    var task: URLSessionDataTask?
    var request: URLRequest?
    private var shouldDispose: Bool = true
    
    @discardableResult
    func observe(using callback: @escaping (Result) -> Void) -> URLSessionDataTask? {
        // If a result has already been set, call the callback directly:
        if let result = result {
            callback(result)
            return task
        }

        callbacks.append(callback)
        return task
    }
    
    private func report(result: Result) {
        callbacks.forEach { $0(result) }
    }
}

class Promise<Value>: Future<Value> {
    init(value: Value? = nil) {
        super.init()
        
        // If the value was already known at the time the promise
        // was constructed, we can report it directly:
        result = value.map(Result.success)
    }
    
    func resolve(with value: Value) {
        result = .success(value)
    }
    
    func reject(with error: Error) {
        result = .failure(error)
    }
}

extension Future {
    func chained<T>(using closure: @escaping (Value) throws -> Future<T>) -> Future<T> {
        // We'll start by constructing a "wrapper" promise that will be
        // returned from this method:
        let promise = Promise<T>()
        promise.task = task
        promise.request = request
        
        // Observe the current future:
        observe { result in
            switch result {
            case .success(let value):
                do {
                    // Attempt to construct a new future using the value
                    // returned from the first one:
                    let future = try closure(value)
                    
                    // Observe the "nested" future, and once it
                    // completes, resolve/reject the "wrapper" future:
                    future.observe { result in
                        switch result {
                        case .success(let value):
                            promise.resolve(with: value)
                        case .failure(let error):
                            promise.reject(with: error)
                        }
                    }
                } catch {
                    promise.reject(with: error)
                }
            case .failure(let error):
                promise.reject(with: error)
            }
        }
        
        return promise
    }
}

extension Future {
    func cancel() {
        guard let task = task else { return }
        task.cancel()
    }
}

extension Future {
    func transformed<T>(with closure: @escaping (Value) throws -> T) -> Future<T> {
         chained { [weak self] value in
            let promise = try Promise(value: closure(value))
            promise.task = self?.task
            promise.request = self?.request
            return promise
        }
    }
}

