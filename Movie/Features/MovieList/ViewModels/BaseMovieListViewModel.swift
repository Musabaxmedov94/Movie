//
//  BaseMovieListViewModel.swift
//  Movie
//
//  Created by musabaxmedov on 19.04.26.
//

import Foundation
import UIKit

class BaseMovieListViewModel: MovieListViewModel {
    
    var callBack: ((MovieListViewState) -> Void)?
    var list: [MovieListItemModel] = []
    
    private var isPaging = false
    private var currentPage = 1
    
    func buildRequest(page: Int) -> RequestModel {
        fatalError("Subclass must override buildRequest")
    }
    
    func shouldShowLoadingOnRefresh() -> Bool {
        return true
    }
    
    func getList() {
        currentPage = 1
        list = []
        Task { await fetchMovies() }
    }
    
    func getMoreItem() {
        guard !isPaging else { return }
        isPaging = true
        currentPage += 1
        Task { await fetchMovies() }
    }
    
    func didSelect(index: Int) {
        guard list.indices.contains(index),
              let id = list[index].id
        else { return }
        addToWatchList(id: id)
    }
    
    
    private func fetchMovies() async {
        if currentPage == 1  { callBack?(.loading) }
        
        let request = buildRequest(page: currentPage)
        let response: NetworkResponse<MovieListResponse> = await NetworkManager.shared.request(model: request)
        
        isPaging = false
        
        switch response {
        case .failure(let appError):
            if self.currentPage > 1 { self.currentPage -= 1 }
            self.callBack?(.loaded)
            self.callBack?(.error(appError))
        case .success(let model):
            let newResults = model.results ?? []
            self.callBack?(.loaded)
            
            guard !newResults.isEmpty else {
                if self.currentPage == 1 {
                    self.list = []
                    self.callBack?(.reloadData)
                } else {
                    self.callBack?(.pagingData([]))
                }
                return
            }
            
            if self.currentPage == 1 {
                self.list = newResults
                self.callBack?(.reloadData)
            } else {
                let uniqueNew = newResults.filter { newItem in
                    !self.list.contains { $0.id == newItem.id }
                }
                
                guard !uniqueNew.isEmpty else {
                    self.callBack?(.pagingData([]))
                    return
                }
                
                let startIndex = self.list.count
                let endIndex   =  startIndex + uniqueNew.count
                let indexPaths = (startIndex..<endIndex).map { IndexPath(item: $0, section: 0) }
                self.list.append(contentsOf: uniqueNew)
                self.callBack?(.pagingData(indexPaths))
            }
        }
    }
    
    private func addToWatchList(id: Int) {
        Task {
            callBack?(.loading)
            
            guard let body = try? JSONEncoder().encode(
                AddToWatchListRequestBody(
                    mediaId: id,
                    watchlist: true,
                    mediaType: "movie")
            )  else { return }
            
            let requestModel = RequestModel(
                method: .post,
                path: AccountEndpoint.addToWatchList.path,
                query: AccountEndpoint.addToWatchList.query,
                body: body)
            
            let response: NetworkResponse<AddToWatchListResponse> = await NetworkManager.shared.request(model: requestModel)
            
            callBack?(.loaded)
            
            switch response {
            case .failure(let appError):
                self.callBack?(.error(appError))
                
            case .success(let model):
                if model.success == true {
                    self.callBack?(.addToWatchList(model.statusMessage ?? "Unknown error"))
                    NotificationCenterManager.updateWatchList.post()
                } else {
                    self.callBack?(.error(.networkError(model.statusMessage ?? "Unknown error")))
                }
            }
        }
    }
}
