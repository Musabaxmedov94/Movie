//
//  AddToWatchListResponse.swift
//  Movie
//
//  Created by musabaxmedov on 01.04.26.
//

import Foundation

// MARK: - AddToWatchListResponse
struct AddToWatchListResponse: Codable {
    let success: Bool?
    let statusCode: Int?
    let statusMessage: String?

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
