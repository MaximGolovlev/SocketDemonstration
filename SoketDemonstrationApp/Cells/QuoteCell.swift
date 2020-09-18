//
//  QuoteCell.swift
//  SoketDemonstrationApp
//
//  Created by  Macbook on 18.09.2020.
//  Copyright © 2020 Golovelv Maxim. All rights reserved.
//

import UIKit

class QuoteCell: UITableViewCell {

    @IBOutlet weak var logoView: UIImageView?
    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var pcpLabel: UILabel!
    @IBOutlet weak var ltrLabel: UILabel!
    @IBOutlet weak var ltpLabel: UILabel!
    @IBOutlet weak var chgLabel: UILabel!
    
    var quote: Quote? {
        didSet {
            guard let quote = quote else { return }
            
            logoView?.setImage(urlString: quote.imageUrl)
            tickerLabel.text = quote.c
            ltrLabel.text = [quote.ltr, quote.name].compactMap({ $0 }).joined(separator: " | ")
            if let pcp = quote.pcp {
                let plus = pcp > 0 ? "+" : ""
                pcpLabel.text = "\(plus)\(pcp)"
            }
            if let ltp = quote.ltp {
                ltpLabel.text = "\(ltp)"
            }
            if let chg = quote.chg {
                let plus = chg > 0 ? "+" : ""
                chgLabel.text = "( \(plus)\(chg) )"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        logoView?.image = nil
    }

}
