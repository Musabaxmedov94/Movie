//
//  AddToWatchListRequestBody.swift
//  Movie
//
//  Created by musabaxmedov on 31.03.26.
//

import Foundation

// MARK: - AddToWatchListRequestBody
struct AddToWatchListRequestBody: Encodable {
    let mediaId: Int
    let watchlist: Bool
    let mediaType: String
   

    enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
        case mediaId = "media_id"
        case watchlist = "watchlist"
    }
}
