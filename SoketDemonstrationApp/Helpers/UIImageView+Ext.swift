//
//  UIImageView+Ext.swift
//  Wiser
//
//  Created by  Macbook on 14.10.2019.
//  Copyright © 2019 Golovelv Maxim. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func setImage(urlString : String?, filterTrash: Bool = true, animation: ImageTransition = .fade(0.5)) {
        
        loadImage(urlString: urlString)
            .filterSmallerThen(size: CGSize(width: 5, height: 5))
            .show(on: self, animation: animation)
    }
    
    func loadImage(urlString : String?) -> Future<UIImage> {
        
        let promise = Promise<UIImage>()
        
        guard let urlString = urlString, let url = URL(string: urlString) else {
            promise.reject(with: ImageDownloaderError.invalidUrl)
            return promise
        }

        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            promise.resolve(with: cachedImage)
            return promise
        }
        
        // if not, download image from url
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                promise.reject(with: ImageDownloaderError.imageDownloadingError(error: error))
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    promise.resolve(with: image)
                }
            }

        }).resume()
        
        return promise
    }
}

extension Future where Value == UIImage {
    
    @discardableResult
    func filterSmallerThen(size: CGSize) -> Future<UIImage> {
        transformed { image in
            if image.size.width < size.width {
                throw ImageDownloaderError.imageIsTooSmall
            } else {
                return image
            }
        }
    }
    
    func show(on imageView: UIImageView, animation: ImageTransition) {
        observe { (result) in
            if case .fade(let duration) = animation, case .success(let image) = result {
                FadeImageAnimator().animate(imageView: imageView, image: image, duration: duration)
            }
        }
    }
}

