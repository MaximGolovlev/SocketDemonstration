//
//  UIView+Ext.swift
//  CelebEthnisity
//
//  Created by  Macbook on 12.04.2020.
//  Copyright © 2020 Golovelv Maxim. All rights reserved.
//

import UIKit

@IBDesignable
extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        set {
            layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        set {
            layer.shadowOffset = newValue
        }
        get {
            return layer.shadowOffset
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        set {
            layer.shadowOpacity = newValue
        }
        get {
            return layer.shadowOpacity
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
        }
    }
    
    @IBInspectable var shadowColor: UIColor {
        set {
            layer.shadowColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: layer.shadowColor!)
        }
    }
    
    @IBInspectable var _clipsToBounds: Bool {
        set {
            clipsToBounds = newValue
        }
        get {
            return clipsToBounds
        }
    }
}
