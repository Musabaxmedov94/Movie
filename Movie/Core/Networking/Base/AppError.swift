//
//  AppError.swift
//  Movie
//
//  Created by musabaxmedov on 19.04.26.
//

enum AppError: Error {
    case noData
    case decodeError
    case networkError(String)
    case unknown
    
    var message: String {
        switch self {
        case .noData:
            return "Data not found"
        case .decodeError:
            return "Decode error"
        case .networkError(let message):
            return message
        case .unknown:
            return "Unknown error"
        }
    }
}
