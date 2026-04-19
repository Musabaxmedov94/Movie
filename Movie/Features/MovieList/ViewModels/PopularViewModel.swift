//
//  PopularViewModel.swift
//  Movie
//
//  Created by musabaxmedov on 05.03.26.
//

import Foundation
import UIKit

final class PopularViewModel: BaseMovieListViewModel {
    
    override func buildRequest(page: Int) -> RequestModel {
        RequestModel(
            method: .get,
            path: MovieListEndpoint.popular.path,
            query: ["page": "\(page)"],
            body: nil)
    }
    
}
