//
//  ImageCache.swift
//  Movie
//
//  Created by musabaxmedov on 08.03.26.
//

import Foundation

final class ImageCache {
    
    static let shared = ImageCache()
    
    private let cache: NSCache<NSString, NSData>
    
    private init(countLimit: Int = 100, totalCostLimit: Int = 50 * 1024 * 1024) {
        let cache            = NSCache<NSString, NSData>()
        cache.countLimit     = countLimit
        cache.totalCostLimit = totalCostLimit
        self.cache           = cache
    }
    
    func get(forKey key: String) -> Data? {
        guard let nsData = cache.object(forKey: key as NSString) else { return nil }
        return nsData as Data
    }
    
    func set(_ data: Data, forKey key: String) {
        cache.setObject(data as NSData, forKey: key as NSString, cost: data.count)
    }
    
    func remove(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    func removeAll() {
        cache.removeAllObjects()
    }
}
