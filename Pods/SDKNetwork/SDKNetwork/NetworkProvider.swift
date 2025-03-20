//
//  NetworkProvider.swift
//  SDKNetwork
//
//  Created by Gilmar Manoel de Mendonça Junior on 04/11/24.
//

import Foundation

public typealias NetworkCompletion<T> = (Result<T, Error>) -> Void

public protocol NetworkProviderProtocol {
    func request<T: Decodable>(url: String,
                               headers: [String: String],
                               body: Data?,
                               queryParams: [String: String],
                               method: String,
                               completion: @escaping NetworkCompletion<T>)
}

public class NetworkProvider: NetworkProviderProtocol {
    
    public init() {}
    
    public func request<T: Decodable>(url: String,
                               headers: [String : String],
                               body: Data?,
                               queryParams: [String : String],
                               method: String,
                               completion: @escaping NetworkCompletion<T>) {
        guard var components = URLComponents(string: url) else {
            return
        }
        
        components.queryItems = queryParams.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        guard let url = URL(string: components.string ?? "") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        
        headers.forEach{
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    if let responseString = String(data: data, encoding: .utf8) {
                       print("Response: \(responseString)")
                    }
                    let entity = try JSONDecoder().decode(T.self, from: data)
                    return completion(.success(entity))
                } catch let error {
                    return completion(.failure(error))
                }
            }
            
            if let error = error {
                return completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
}
