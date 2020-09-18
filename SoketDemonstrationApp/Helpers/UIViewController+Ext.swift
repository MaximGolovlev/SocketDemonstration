//
//  UIViewController+Ext.swift
//  BackMyCash
//
//  Created by User on 18.01.2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit

extension UIViewController {
    
    static func initFromStoryboard() -> UIViewController {
        return UIStoryboard(name: String(describing: self), bundle: nil).instantiateInitialViewController()!
    }
    
    static func initWith(name: String) -> UIViewController {
        return UIStoryboard(name: String(describing: self), bundle: nil).instantiateViewController(withIdentifier: name)
    }
}

