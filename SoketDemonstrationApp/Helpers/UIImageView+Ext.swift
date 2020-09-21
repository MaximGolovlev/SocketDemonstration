//
//  UIImageView+Ext.swift
//  Wiser
//
//  Created by  Macbook on 14.10.2019.
//  Copyright © 2019 Golovelv Maxim. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

struct ImageLoadingParameters {
    var image: UIImage = UIImage()
    var animation: ImageTransition
}

extension UIImageView {
    
    func setImage(urlString : String?, animation: ImageTransition = .fade(0.5)) {
        
        let params = ImageLoadingParameters(animation: animation)
        
        loadImage(urlString: urlString, params: params)
            .filterSmallerThen(size: CGSize(width: 5, height: 5))
            .show(on: self)
    }
    
    func loadImage(urlString : String?, params: ImageLoadingParameters) -> Future<ImageLoadingParameters> {
        
        let promise = Promise<ImageLoadingParameters>()
        
        guard let urlString = urlString, let url = URL(string: urlString) else {
            promise.reject(with: ImageDownloaderError.invalidUrl)
            return promise
        }

        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            promise.resolve(with: ImageLoadingParameters(image: cachedImage, animation: .none))
            return promise
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                promise.reject(with: ImageDownloaderError.imageDownloadingError(error: error))
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    promise.resolve(with: ImageLoadingParameters(image: image, animation: params.animation))
                }
            }

        }).resume()
        
        return promise
    }
}

extension Future where Value == ImageLoadingParameters {
    
    @discardableResult
    func filterSmallerThen(size: CGSize) -> Future<ImageLoadingParameters> {
        transformed { params in
            if params.image.size.width < size.width {
                throw ImageDownloaderError.imageIsTooSmall
            } else {
                return ImageLoadingParameters(image: params.image, animation: params.animation)
            }
        }
    }
    
    func show(on imageView: UIImageView) {
        observe { (result) in
            if case .success(let params) = result {
                if case .fade(let duration) = params.animation {
                    FadeImageAnimator().animate(imageView: imageView, image: params.image, duration: duration)
                } else {
                    imageView.image = params.image
                }
            }
        }
    }
}

