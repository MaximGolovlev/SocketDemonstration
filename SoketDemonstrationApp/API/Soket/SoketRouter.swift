//
//  SoketRouter.swift
//  SoketDemonstrationApp
//
//  Created by  Macbook on 16.09.2020.
//  Copyright © 2020 Golovelv Maxim. All rights reserved.
//

import Foundation
import SocketIO

protocol SoketRouter {
    var baseUrl: URL? { get }
    var requestEvent: String { get }
    var responseEvent: String { get }
    var soketData: [SocketData] { get }
}

extension SoketRouter {
    var baseUrl: URL? {
        return URL(string: "https://ws.tradernet.ru")
    }
}
