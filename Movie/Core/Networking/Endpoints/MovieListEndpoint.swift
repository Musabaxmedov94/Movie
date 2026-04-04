//
//  MovieListEndPoint.swift
//  Movie
//
//  Created by musabaxmedov on 02.02.26.
//

enum MovieListEndpoint: String {
    case nowPlaying = "/movie/now_playing"
    case upComing = "/movie/upcoming"
    case topRated = "/movie/top_rated"
    case popular = "/movie/popular"
    
    var path: String {
        rawValue
    }
    
}
