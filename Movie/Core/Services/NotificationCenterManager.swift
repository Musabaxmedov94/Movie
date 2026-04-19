//
//  NotificationCenter.swift
//  Movie
//
//  Created by musabaxmedov on 03.04.26.
//

import Foundation

enum NotificationCenterManager {
    case updateWatchList
    
    var name: String {
        switch self {
        case .updateWatchList:
            return "updateWatchList"
        }
    }
    
    
    func post() {
        NotificationCenter.default.post(
            name: NSNotification.Name(name),
            object: nil,
            userInfo: nil)
    }
    
    @discardableResult
    func observ(usingBlock: @escaping (Notification) -> Void) -> NSObjectProtocol {
       return  NotificationCenter.default.addObserver(
            forName: NSNotification.Name(name),
            object: nil,
            queue: .main,
            using: usingBlock)
        
    }
}
