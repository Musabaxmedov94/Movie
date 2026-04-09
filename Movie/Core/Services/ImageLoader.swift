//
//  ImageLoader.swift
//  Movie
//
//  Created by musabaxmedov on 08.03.26.
//

import Foundation
import Bricks

final class ImageLoader {
    
    static let shared = ImageLoader()
    
    private init() {}
    
    func fetchCacheImage(urlString: String, completion: @escaping (Data?) -> Void) {
        
        if let imageData = ImageCache.shared.get(forKey: urlString) {
            completion(imageData)
            return
        }
        
        fetchRemoteImage(urlString: urlString) { data in
                if let data {
                    ImageCache.shared.set(data, forKey: urlString)
                }
                completion(data)
            }
        }
    
    func fetchRemoteImage(urlString: String, completion: @escaping (Data?) -> Void) {
        NetworkManager.shared.loadData(urlString: urlString, completion: completion)
    }
    
    func refreshImage(urlString: String, completion: @escaping (Data?) -> Void) {
        ImageCache.shared.remove(forKey: urlString)
        
        fetchCacheImage(urlString: urlString) { data in
            if let data {
                ImageCache.shared.set(data, forKey: urlString)
            }
            completion(data)
        }
    }
    
    func removeCacheImage(urlString: String) {
        ImageCache.shared.remove(forKey: urlString)
    }
    
    func removeAllCacheImage() {
        ImageCache.shared.removeAll()
    }
}
