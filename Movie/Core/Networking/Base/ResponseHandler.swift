//
//  ResponceHandler.swift
//  Movie
//
//  Created by musabaxmedov on 13.02.26.
//

import Foundation

protocol ResponseHandler {
    func handle<T: Decodable>(data: Data?) -> NetworkResponse<T>
}

private struct APIErrorResponse: Decodable {
    let statusCode: Int?
    let statusMessage: String?

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

extension ResponseHandler {
    func handle<T: Decodable>(data: Data?) -> NetworkResponse<T> {
        guard let data else { return .error("Data not found") }

        if let model = try? JSONDecoder().decode(T.self, from: data) {
            return .success(model)
        }

        if let errorModel = try? JSONDecoder().decode(APIErrorResponse.self, from: data),
           let message = errorModel.statusMessage,
           !message.isEmpty {
            return .error(message)
        }

        return .error("Decode error")
    }
}
