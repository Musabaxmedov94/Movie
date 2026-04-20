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
        list.remove(at: index)
        callBack?(.reloadData)
        removeFromWatchList(id: id)
    }
    
    
    
    private func removeFromWatchList(id: Int) {
        Task {
            
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
            
            let response: (NetworkResponse<AddToWatchListResponse>) = await NetworkManager.shared.request(model: request)
            
            switch response {
            case .failure(let appError):
                self.getList()
                self.callBack?(.error(appError))
            case .success(let model):
                if model.success == true || model.statusCode == 12 || model.statusCode == 13  {
                    break
                } else {
                    self.getList()
                    self.callBack?(.error(.networkError(model.statusMessage ?? "Unknown error")))
                }
            }
        }
    }
}
