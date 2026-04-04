//
//  ResponceModel.swift
//  Movie
//
//  Created by musabaxmedov on 13.02.26.
//

import Foundation

enum NetworkResponse<T> {
    case error(String)
    case success(T)
}
