//
//  MovieListController.swift
//  Movie
//
//  Created by musabaxmedov on 23.02.26.
//



import Foundation

// MARK: - MovieListResponse
struct MovieListResponse: Decodable {
    let page: Int?
    let results: [MovieListModel]?
    let totalPages: Int?
    let totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Dates
struct Dates: Decodable {
    let maximum: String?
    let minimum: String?

    enum CodingKeys: String, CodingKey {
        case maximum = "maximum"
        case minimum = "minimum"
    }
}

// MARK: - Result
struct MovieListModel: Decodable {
    let id: Int?
    let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case posterPath = "poster_path"
    }
}

extension MovieListModel: MovieListItemModel {
    var imageUrlString: String {
        "https://image.tmdb.org/t/p/original/\(posterPath ?? "")"
    }
    
}
