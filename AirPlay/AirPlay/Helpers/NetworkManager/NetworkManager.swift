//
//  NetworkManager.swift
//  AirPlay
//
//  Created by Aj on 17/08/24.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

// Protocol for creating URLRequest
protocol RequestCreatable {
    func createRequest(url: URL, method: HTTPMethod, queryParams: [String: String], body: Data?) -> URLRequest
}

// Protocol for handling network responses
protocol NetworkRequestable {
    func performRequest<T: Codable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void)
}


class NetworkManager: RequestCreatable, NetworkRequestable {
    
    // Singleton instance
    static let shared = NetworkManager()
    
    // Private initializer to ensure singleton usage
    private init() {}
    
    // MARK: - RequestCreatable Protocol
    func createRequest(url: URL, method: HTTPMethod, queryParams: [String: String] = [:], body: Data? = nil) -> URLRequest {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        if !queryParams.isEmpty {
            components.queryItems = queryParams.map { URLQueryItem(name: $0, value: $1) }
        }
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = method.rawValue
        if let body = body {
            request.httpBody = body
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    // MARK: - NetworkRequestable Protocol
    func performRequest<T: Codable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                let error = NSError(domain: "com.networkManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(error))
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch let decodingError {
                completion(.failure(decodingError))
            }
        }
        task.resume()
    }
}
