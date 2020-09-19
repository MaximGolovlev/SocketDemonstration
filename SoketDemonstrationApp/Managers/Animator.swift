//
//  Animator.swift
//  SoketDemonstrationApp
//
//  Created by  Macbook on 19.09.2020.
//  Copyright © 2020 Golovelv Maxim. All rights reserved.
//

import UIKit

public enum ImageTransition {
    case none
    case fade(TimeInterval)
}

protocol ImageAnimatable {
    func animate(imageView: UIImageView, image: UIImage, duration: TimeInterval)
}

class FadeImageAnimator: ImageAnimatable {
    func animate(imageView: UIImageView, image: UIImage, duration: TimeInterval) {
        imageView.alpha = 0
        imageView.image = image
        UIView.animate(withDuration: duration) {
            imageView.alpha = 1
        }
    }
}
