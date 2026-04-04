//
//  MovieListController.swift
//  Movie
//
//  Created by musabaxmedov on 23.02.26.
//

import Foundation
import UIKit

final class UpcomingViewModel: MovieListViewModel {
    func didSelect(index: Int) {}
    
    var callBack: ((MovieListViewState) -> Void)?
    var list: [MovieListItemModel] = []
    
    private var isPaging = false
    private var currentPage = 1
    
    func getList() {
        currentPage = 1
        getUpcoming(page: currentPage)
    }
    
    func getMoreItem() {
        guard !isPaging else { return }
        
        isPaging = true
        currentPage += 1
        getUpcoming(page: currentPage)
    }
    
    private func getUpcoming(page: Int) {
        if page == 1 { callBack?(.loading) }
        
        let requestModel = RequestModel(
            method: .get,
            path: MovieListEndpoint.upComing.path,
            query: ["page" : "\(page)"],
            body: nil)
        
        let completion: (NetworkResponse<MovieListResponse>) -> Void = {
            [weak self] response in
            guard let self else { return }
            self.isPaging = false
            
            switch response {
            case .error(let message):
                if self.currentPage > 1 { self.currentPage -= 1}
                self.callBack?(.loaded)
                self.callBack?(.error(message))
            case .success(let model):
                let newResults = model.results ?? []
                
                let uniqueNewResults = newResults.filter { newItem in
                    !self.list.contains(where: {$0.id == newItem.id })
                }
                
                self.callBack?(.loaded)
                guard !uniqueNewResults.isEmpty else { return }
                
                if page == 1 {
                    self.list = uniqueNewResults
                    self.callBack?(.reloadData)
                } else {
                    let startIndex = self.list.count
                    let endIndex   = startIndex + uniqueNewResults.count
                    let indexPaths  = (startIndex..<endIndex).map { IndexPath(item: $0, section: 0) }
                    
                    self.list.append(contentsOf: uniqueNewResults)
                    self.callBack?(.pagingData(indexPaths))
                }
            }
        }
        
        
        NetworkManager.shared.request(model: requestModel, completion: completion)
    }
    
}
