//
//  NetworkManager.swift
//  Movie
//
//  Created by musabaxmedov on 01.02.26.
//

import Foundation

final class NetworkManager: URLBuilder, ResponseHandler {
    var baseUrl: String {
        "https://api.themoviedb.org/3"
    }
    
    var token: String {
        "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkMTNlZjQwYzMyZDhiZTI4ZmZlYWFiMjE1NTNkNDc4MSIsIm5iZiI6MTc2ODgzMjI4NS44OTY5OTk4LCJzdWIiOiI2OTZlM2QxZDZhMmMyM2M3NGJhYWIwOTMiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.ezIA-19X1l94eZQt7tPR2IeSt2dvzZreGP2m_9loizg"
    }
    
    static let shared: NetworkManager = NetworkManager(session: .shared)
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    @discardableResult
    func request<T: Decodable>(model: RequestModel, completion: @escaping (NetworkResponse<T>) -> Void) -> URLSessionDataTask? {
        guard let urlRequest = getUrlRequest(model: model)  else { return nil }
        let dataTask = session.dataTask(with: urlRequest) {
            data, responce, error in
            DispatchQueue.main.async {
                [weak self ] in
                guard let self else { return }
                completion(self.handle(data: data))
            }
        }
        dataTask.resume()
        return dataTask
    }
    
    @discardableResult
    func loadData(urlString: String, completion: @escaping (Data?) -> Void) -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return nil
        }
        let dataTask = session.dataTask(with: url) {
            data, response, error in
            DispatchQueue.main.async {
                completion(data)
            }
        }
        dataTask.resume()
        return dataTask
    }
}
