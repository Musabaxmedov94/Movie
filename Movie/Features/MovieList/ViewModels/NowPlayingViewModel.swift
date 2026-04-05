//
//  MovieListController.swift
//  Movie
//
//  Created by musabaxmedov on 23.02.26.
//

import Foundation
import UIKit

final class NowPlayingViewModel: MovieListViewModel {
    func didSelect(index: Int) {
        guard let id = list[index].id else { return }
    }

    var callBack: ((MovieListViewState) -> Void)?
    var list: [MovieListItemModel] = []


    private var isPaging = false
    private var currentPage = 1

    func getList() {
        currentPage = 1
        getNowPlaying()
    }

    func getMoreItem() {
        guard !isPaging else { return }

        isPaging = true
        currentPage += 1
        getNowPlaying()
    }

    private func getNowPlaying() {
        if currentPage == 1 { callBack?(.loading) }

        let requestModel = RequestModel(
            method: .get,
            path: MovieListEndpoint.nowPlaying.path,
            query: ["page" : "\(currentPage)"],
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

                if currentPage == 1 {
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


    private func addToWatchList(id: Int) {
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

        let completion: (NetworkResponse<AddToWatchListResponse>) -> Void = {
            [weak self] response in
            guard let self else { return }
            self.callBack?(.loaded)

            switch response {
            case .error(let message):
                self.callBack?(.error(message))

            case .success(let model):
                if model.success == true {
                    self.callBack?(.addToWatchList(model.statusMessage ?? "Unknown error"))
                    NotificationCenterManager.updaitWatchList.post()
                  print("Add To Watch List")
                } else {
                    self.callBack?(.error(model.statusMessage ?? "Unknown error"))
                }
            }
        }


        NetworkManager.shared.request(model: requestModel, completion: completion)
    }

}
