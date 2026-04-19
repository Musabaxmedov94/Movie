//
//  Untitled.swift
//  Movie
//
//  Created by musabaxmedov on 31.03.26.
//

import Foundation
import UIKit

final class WatchListViewModel: BaseMovieListViewModel {
    
    private var notificationToken: NSObjectProtocol?
    
    override init() {
        super.init()
        notificationToken = NotificationCenterManager.updateWatchList.observ(usingBlock: {
            [weak self] _ in
            guard let self else { return }
            self.getList()
        })
    }
    
    deinit {
        if let token = notificationToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    override func getList() {
        list = []
        super.getList()
    }
    
    override func buildRequest(page: Int) -> RequestModel {
        var query = AccountEndpoint.watchListMovies.query ?? [:]
        query["page"] = "\(page)"
        return RequestModel(
            method: .get,
            path: AccountEndpoint.watchListMovies.path,
            query: query,
            body: nil)
    }
    
    override func didSelect(index: Int) {
        guard list.indices.contains(index),
              let id = list[index].id
        else { return }
        removeFromWatchList(id: id)
    }
    
    
    
    private func removeFromWatchList(id: Int) {
        callBack?(.loading)
        
        guard let body = try? JSONEncoder().encode(
            AddToWatchListRequestBody(
                mediaId: id,
                watchlist: false,
                mediaType: "movie")
        ) else { return }
        
        let request = RequestModel(
            method: .post,
            path: AccountEndpoint.addToWatchList.path,
            query: AccountEndpoint.addToWatchList.query,
            body: body)
        
        let completion: (NetworkResponse<AddToWatchListResponse>) -> Void = {
            [weak self] response in
            guard let self else { return }
            self.callBack?(.loaded)
            
            switch response {
            case .error(let message):
                self.callBack?(.error(message))
                
            case .success(let model):
                if model.success == true || model.statusCode == 12 || model.statusCode == 13  {
                    self.getList()
                } else {
                    self.callBack?(.error(model.statusMessage ?? "Unknown error"))
                }
            }
        }
        
        NetworkManager.shared.request(model: request, completion: completion)
    }
}
