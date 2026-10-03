//
//  APIClient.swift
//  PinDrop
//
//  Created by Ivan on 28.09.2026.
//

import Foundation

enum ApiError: Error {
    case invalidURL
    case noData
    case decodingFailed
    case requestFailed(Error)
    case serverError(statusCode: Int)
    
}

protocol ApiClientProtocol {
    
    func request<T: Decodable>(url: URL, headers: [String: String], completion: @escaping (Result<T, ApiError>) -> Void)
    
}

final class APIClient: ApiClientProtocol {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T>(url: URL, headers: [String : String], completion: @escaping (Result<T, ApiError>) -> Void) where T : Decodable {
        
        var request = URLRequest(url: url)
        
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                
                completion(.failure(.requestFailed(error)))
                return
            }
            
            if let httpRespobse = response as? HTTPURLResponse, !(200...299).contains(httpRespobse.statusCode) {
                
                completion(.failure(.serverError(statusCode: httpRespobse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                
                let decodre = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodre))
                
                
            } catch {
                completion(.failure(.decodingFailed))
            }
        }
        
        task.resume()
    }
    
    
    
}
