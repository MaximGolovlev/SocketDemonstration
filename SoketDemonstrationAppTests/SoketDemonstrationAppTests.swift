//
//  SoketDemonstrationAppTests.swift
//  SoketDemonstrationAppTests
//
//  Created by  Macbook on 15.09.2020.
//  Copyright © 2020 Golovelv Maxim. All rights reserved.
//

import XCTest
@testable import SoketDemonstrationApp
import SocketIO

class SoketDemonstrationAppTests: XCTestCase {
    
    var socketRouter: QuoteSocketRouter?
    var socketManager: SoketManager?

    override func setUp() {
        
        let tickers = ["RSTI", "GAZP", "MRKZ", "RUAL", "HYDR", "MRKS", "SBER", "FEES", "TGKA", "VTBR", "ANH.US", "VICL.US", "BURG.US", "NBL.US", "YETI.US", "WSFS.US", "NIO.US", "DXC.US", "MIC.US", "HSBC.US", "EXPN.EU", "GSK.EU", "SHP.EU", "MAN.EU", "DB1.EU", "MUV2.EU", "TATE.EU", "KGF.EU", "MGGT.EU", "SGGD.EU"]
        socketRouter = QuoteSocketRouter.quotesChangeSubscribtion(tickersToWatch: tickers)
        socketManager = try? SoketManager(socketURL: socketRouter?.baseUrl)
    }

    override func tearDown() {
        socketRouter = nil
        socketManager = nil
    }

    func testTickerData() {
        
        XCTAssertNotNil(socketManager)
        XCTAssertNotNil(socketRouter)
        
        socketManager!
            .connectIfNeeded()
            .emit(event: socketRouter!.requestEvent, items: socketRouter!.soketData)
            .handle(event: socketRouter!.responseEvent)
            .decodeSocketResponse(event: socketRouter!.responseEvent)
            .observe { (result: (Result<[Quote], Error>)) in
                
                if case .success(let items) = result {
                    XCTAssert(items.contains(where: { $0.name == "RSTI" }))
                }
        }
    }


}
