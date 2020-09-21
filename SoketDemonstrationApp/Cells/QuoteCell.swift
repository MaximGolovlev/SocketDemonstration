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
    @IBOutlet weak var pcpBgView: UIView!
    @IBOutlet weak var ltrLabel: UILabel!
    @IBOutlet weak var ltpLabel: UILabel!
    @IBOutlet weak var chgLabel: UILabel!
    
    var quote: Quote? {
        didSet {
            guard let quote = quote else { return }
            
            logoView?.setImage(urlString: quote.imageUrl)
            tickerLabel.text = quote.c
            ltrLabel.text = [quote.ltr, quote.name].compactMap({ $0 }).joined(separator: " | ")
            pcpLabel.text = quote.pcpString
            pcpLabel.textColor = quote.pcpColor.textColor
            pcpBgView.backgroundColor = quote.pcpColor.bgColor
            ltpLabel.text = quote.ltp
            chgLabel.text = quote.chgString
            
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
