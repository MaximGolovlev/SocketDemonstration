//
//  UIImageView+Ext.swift
//  Wiser
//
//  Created by  Macbook on 14.10.2019.
//  Copyright © 2019 Golovelv Maxim. All rights reserved.
//

import Kingfisher
import UIKit

extension UIImageView {
    
    func setImage(urlString: String?, placeholder: UIImage? = nil, completion: ((UIImage) -> ())? = nil) {
        
        guard let urlString = urlString else { return }

        kf.setImage(with: URL(string: urlString), placeholder: placeholder, options: [
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(0.3))
        ]) { result in
            if case .success(let image) = result {
                completion?(image.image)
            }
        }
    }
    
}
