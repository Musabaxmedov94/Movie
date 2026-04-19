//
//  MovieListController.swift
//  Movie
//
//  Created by musabaxmedov on 23.02.26.
//

import Foundation
import UIKit

final class NowPlayingViewModel: BaseMovieListViewModel {
    
    override func buildRequest(page: Int) -> RequestModel {
        RequestModel(
            method: .get,
            path: MovieListEndpoint.nowPlaying.path,
            query: ["page": "\(page)"],
            body: nil)
    }
}
