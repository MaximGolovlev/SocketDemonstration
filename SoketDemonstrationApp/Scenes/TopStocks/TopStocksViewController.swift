//
//  TopStocksViewController.swift
//  SoketDemonstrationApp
//
//  Created by  Macbook on 18.09.2020.
//  Copyright © 2020 Golovelv Maxim. All rights reserved.
//

import UIKit

class TopStocksViewController: UIViewController {

    lazy var presenter = TopStocksPresenter(vc: self)
    
    private var currentTask: URLSessionDataTask?
    
    lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(handlePullToRefresh), for: .valueChanged)
        return rc
    }()
    
    var tickers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchTopStocks()
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
            tableView.addSubview(refreshControl)
        }
    }
    
    func fetchTopStocks() {
        currentTask?.cancel()
        currentTask = presenter.fetchTopStocks(type: "stocks", exchange: "russia", gainers: true, limit: 20)
    }
    
    @objc func handlePullToRefresh() {
        fetchTopStocks()
    }
    
}

extension TopStocksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TickerCell", for: indexPath)
        cell.textLabel?.text = tickers[indexPath.row]
        return cell
        
    }
    
}

extension TopStocksViewController: TopStocksProtocol {
    func stocksDidFetch(items: [String]) {
        self.tickers = items
        
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.tableView.reloadData()
        }
    }
    
    func failed(with error: Error) {
        print(error.localizedDescription)
    }
}
