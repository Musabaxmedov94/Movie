//
//  RequestModel.swift
//  Movie
//
//  Created by musabaxmedov on 02.02.26.
//

import Foundation

enum HttpMethod: String {
    case get  = "GET"
    case post = "POST"
}

struct RequestModel {
    let method: HttpMethod
    let path: String
    let query: [String: String]?
    let body: Data?
}
