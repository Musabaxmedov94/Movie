//
//  MovieListController.swift
//  Movie
//
//  Created by musabaxmedov on 23.02.26.
//

import Foundation
import UIKit

final class UpcomingViewModel: BaseMovieListViewModel {
    
    override func buildRequest(page: Int) -> RequestModel {
        RequestModel(
            method: .get,
            path: MovieListEndpoint.upComing.path,
            query: ["page": "\(page)"],
            body: nil)
    }
    
}
