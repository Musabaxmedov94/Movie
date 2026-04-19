//
//  TopRatedViewModel.swift
//  Movie
//
//  Created by musabaxmedov on 05.03.26.
//

import Foundation
import UIKit

final class TopRatedViewModel: BaseMovieListViewModel {
    
    override func buildRequest(page: Int) -> RequestModel {
        RequestModel(
            method: .get,
            path: MovieListEndpoint.topRated.path,
            query: ["page": "\(page)"],
            body: nil)
    }
    
}
