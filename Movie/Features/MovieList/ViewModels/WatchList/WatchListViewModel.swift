//
//  Untitled.swift
//  Movie
//
//  Created by musabaxmedov on 31.03.26.
//

import Foundation
import UIKit

final class WatchListViewModel: MovieListViewModel {
    
    var callBack: ((MovieListViewState) -> Void)?
    var list: [MovieListItemModel] = []
    
    private var isPaging = false
    private var currentPage = 1
    
    init() {
        NotificationCenterManager.updaitWatchList.observ(usingBlock: {
            [weak self] _ in
            guard let self else { return }
            self.getList()
        })
    }
    
    func getList() {
        currentPage = 1
        list = []
        getWatchList()
    }
    
    func getMoreItem() {
        guard !isPaging else { return }
        
        isPaging = true
        currentPage += 1
        getWatchList()
    }
    
    private func getWatchList() {
        callBack?(.loading)
        
        var query = AccountEndpoint.watchListMovies.query ?? [:]
        query["page"] = "\(currentPage)"
        
        let requestModel = RequestModel(
            method: .get,
            path: AccountEndpoint.watchListMovies.path,
            query: query,
            body: nil)
        
        let completion: (NetworkResponse<MovieListResponse>) -> Void = {
            [weak self] response in
            guard let self else { return }
            self.isPaging = false
            
            switch response {
            case .error(let message):
                if self.currentPage > 1 { self.currentPage -= 1 }
                self.callBack?(.loaded)
                self.callBack?(.error(message))
            case .success(let model):
                let newResults = model.results ?? []
                self.callBack?(.loaded)
                
                if currentPage == 1 {
                    self.list = newResults
                    self.callBack?(.reloadData)
                    return
                }
                
                let uniqueNewResults = newResults.filter { newItem in
                    !self.list.contains(where: { $0.id == newItem.id })
                }
                
                guard !uniqueNewResults.isEmpty else { return }
                
                let startIndex = self.list.count
                let endIndex = startIndex + uniqueNewResults.count
                let indexPaths = (startIndex..<endIndex).map { IndexPath(item: $0, section: 0) }
                
                self.list.append(contentsOf: uniqueNewResults)
                self.callBack?(.pagingData(indexPaths))
            }
        }
        
        NetworkManager.shared.request(model: requestModel, completion: completion)
    }
    
    func didSelect(index: Int) {
        guard list.indices.contains(index) else { return }
        guard let id = list[index].id else { return }
        removeFromWatchList(id: id)
    }
    
    private func removeFromWatchList(id: Int) {
        callBack?(.loading)
        
        guard let body = try? JSONEncoder().encode(
            AddToWatchListRequestBody(
                mediaId: id,
                watchlist: false,
                mediaType: "movie")
        )  else { return }
        
        let requestModel = RequestModel(
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
                if model.success == true || model.statusCode == 12 || model.statusCode == 13 {
                    self.getList()
                    print("Add To Watch List")
                } else {
                    self.callBack?(.error(model.statusMessage ?? "Unknown error"))
                }
            }
        }
        
        
        NetworkManager.shared.request(model: requestModel, completion: completion)
    }
}
