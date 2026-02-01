//
//  UIImageView+Ext.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 27.12.2025.
//

import Foundation
import UIKit

extension UIImageView {
    private static var urlKey: UInt8 = 0
    
    private var imageURL: URL? {
        get {
            return objc_getAssociatedObject(self, &UIImageView.urlKey) as? URL
        }
        set {
            objc_setAssociatedObject(self, &UIImageView.urlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func loadImage(from url: URL, placeholder: UIImage? = nil) {
        if let previousURL = imageURL {
            ImageLoader.shared.cancelLoad(for: previousURL)
        }
        
        imageURL = url
        image = placeholder
        
        ImageLoader.shared.loadImage(from: url) { [weak self] loadedImage in
            guard self?.imageURL == url else { return }
            self?.image = loadedImage
        }
    }
    
    func cancelImageLoad() {
        if let url = imageURL {
            ImageLoader.shared.cancelLoad(for: url)
            imageURL = nil
        }
    }
}
