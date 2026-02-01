//
//  ImageLoader.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 27.12.2025.
//

import UIKit

final class ImageLoader {
    static let shared = ImageLoader()
    
    private let cache = NSCache<NSString, UIImage>()
    private var runningTasks: [URL: URLSessionDataTask] = [:]
    
    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = url.absoluteString as NSString
        
        if let cachedImage = cache.object(forKey: cacheKey) {
            completion(cachedImage)
            return
        }
        
        if let _ = runningTasks[url] {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            defer {
                self?.runningTasks.removeValue(forKey: url)
            }
            
            guard let data = data,
                  let image = UIImage(data: data),
                  error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            self?.cache.setObject(image, forKey: cacheKey)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        runningTasks[url] = task
        task.resume()
    }
    
    func cancelLoad(for url: URL) {
        runningTasks[url]?.cancel()
        runningTasks.removeValue(forKey: url)
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
}
