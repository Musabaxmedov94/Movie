//
//  NotificationCenter.swift
//  Movie
//
//  Created by musabaxmedov on 03.04.26.
//

import Foundation

enum NotificationCenterManager {
    case updaitWatchList
    
    var name: String {
        switch self {
        case .updaitWatchList:
            return "updaitWatchList"
        }
    }
    
    
    func post() {
        switch self {
        case .updaitWatchList:
            NotificationCenter.default.post(
                name: NSNotification.Name(name),
                object: nil,
                userInfo: nil)
        }
    }
    
    func observ(usingBlock: @escaping (Notification) -> Void) {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(name),
            object: nil,
            queue: .main,
            using: usingBlock)
        
    }
}
