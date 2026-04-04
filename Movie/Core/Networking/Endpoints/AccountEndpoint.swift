//
//  AccountEndpoint.swift
//  Movie
//
//  Created by musabaxmedov on 31.03.26.
//

enum AccountEndpoint {
    case addToWatchList
    case watchListMovies

    private static let accountID = 22675683
    private static let sessionID = "b2cb7eb8e80a0c984f2b147b5421f8976ea23a50"

    var path: String {
        switch self {
        case .addToWatchList:
            return "/account/\(Self.accountID)/watchlist"
        case .watchListMovies:
            return "/account/\(Self.accountID)/watchlist/movies"
        }
    }

    var query: [String: String]? {
        guard !Self.sessionID.isEmpty else { return nil }
        return ["session_id": Self.sessionID]
    }
}
