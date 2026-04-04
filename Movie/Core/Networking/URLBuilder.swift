//
//  URLBulder.swift
//  Movie
//
//  Created by musabaxmedov on 01.02.26.
//
///
import Foundation

protocol URLBuilder {
    var  baseUrl:   String { get }
    var  token:     String { get }
    func getUrl(model: RequestModel) -> URL?
    func getUrlRequest(model: RequestModel) -> URLRequest?
    
}

extension URLBuilder {
    
    func getUrl(model: RequestModel) -> URL? {
        guard var url = URL(string: "\(baseUrl)\(model.path)") else { return nil}
        model.query?.forEach { key, value in
            url.append(queryItems: [URLQueryItem(name: key, value: value)])
        }
       /*
        if let query =  model.query {
            for (key, value) in query {
                url.append(queryItems: [URLQueryItem(name: key, value: value)])
            }
        }
        */
        return url
    }
    
    func getUrlRequest(model: RequestModel) -> URLRequest? {
        guard let url = getUrl(model: model) else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = model.method.rawValue
        urlRequest.httpBody = model.body
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "accept")
        if model.body != nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return urlRequest
    }
    
    
}
