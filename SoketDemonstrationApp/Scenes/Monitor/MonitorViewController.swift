//
//  FeedViewController.swift
//  SoketDemonstrationApp
//
//  Created by  Macbook on 15.09.2020.
//  Copyright © 2020 Golovelv Maxim. All rights reserved.
//

import UIKit
import SocketIO

class MonitorViewController: UIViewController {

    private let cellName = "QuoteCell"
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
            tableView.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
        }
    }
    
    
    lazy var presenter = MonitorPresenter(vc: self)
    
    var quotesDictionary = [String: Quote]()
    
    var quotesArray = [Quote]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try presenter.fetchQoutes()
        } catch {
            print(error.localizedDescription)
        }
    }

}

extension MonitorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! QuoteCell
        cell.quote = quotesArray[indexPath.row]
        return cell
        
    }
    
}

extension MonitorViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension MonitorViewController: MonitorPresenterProtocol {
    
    func quotesDidFetch(quotes: [Quote]) {
        
        quotes.forEach({ quote in
            if quotesDictionary[quote.c] != nil {
                quotesDictionary[quote.c]?.applyChanges(from: quote)
            } else {
                quotesDictionary[quote.c] = quote
            }
        })
        
        quotesArray = quotesDictionary.values.map{ $0 }.sorted(by: { $0.c < $1.c })
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func qotesFetchedWith(error: Error) {
        print(error.localizedDescription)
    }
    
}
