//
//  SoketManager.swift
//  SoketDemonstrationApp
//
//  Created by  Macbook on 16.09.2020.
//  Copyright © 2020 Golovelv Maxim. All rights reserved.
//

import Foundation
import SocketIO

class SoketManager {
    private var socketURL: URL
    private var config: SocketIOClientConfiguration
    
    init(socketURL: URL?, config: SocketIOClientConfiguration = []) throws {
        guard let socketURL = socketURL else {
            throw SocketError.invalidUrl
        }
        self.socketURL = socketURL
        self.config = config
    }
    
    lazy var manager = SocketManager(socketURL: self.socketURL, config: self.config)
    lazy var socket = manager.defaultSocket
    
    func connectIfNeeded() -> Future<SocketIOClient> {
        
        let promise = Promise<SocketIOClient>()
        
        guard !socket.status.active else {
            return Promise(value: socket)
        }
        
        socket.on(clientEvent: .connect) { [weak self] data, ack in
            guard let self = self else {
                promise.reject(with: SocketError.managerDeallocated)
                return
            }
            promise.resolve(with: self.socket)
        }
        
        socket.on(clientEvent: .error) { (data, ack) in
            promise.reject(with: SocketError.connectionError)
        }
        
        socket.connect()

        return promise
    }
}

extension Future where Value == SocketIOClient {
    
    func emit(event: String, items: [SocketData]) -> Future<SocketIOClient> {
        transformed { (socket) in
            socket.emit(event, items)
            return socket
        }
    }
    
    func handle(event: String) -> Future<([Any], SocketAckEmitter)> {
        chained { (socket) in
            
            let promise = Promise<([Any], SocketAckEmitter)>()
            
            socket.on(event) {data, ack in
                promise.resolve(with: (data, ack))
            }
            
            return promise
        }
    }
}

extension Future where Value == ([Any], SocketAckEmitter) {
    func decodeSocketResponse<T: Decodable>(event: String, using decoder: JSONDecoder = .init(), keypath: String? = nil) -> Future<[T]> {
        transformed { data, _ in
            
            guard let items = (data[0] as? [String: Any])?[event] as? [[String: Any]] else {
                throw SocketError.isNotValidJson
            }
            
            do {
                let data = try JSONSerialization.data(withJSONObject: items, options: [])
                return try JSONDecoder().decode([T].self, from: data)
            } catch {
                throw SocketError.serializationError(error: error)
            }
            
        }
    }
}
