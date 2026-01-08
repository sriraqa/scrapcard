//
//  Network.swift
//  scrapcard
//
//  Created by Sarah Qiao on 2025-09-20.
//

import Foundation

enum HTTPMethod: String {
  case GET
  case POST
  case PUT
  case DELETE
}

class APIService {
  static let shared = APIService()
  private init() {}
  
  private let url = "http://localhost:5050"
  
  func request<T: Decodable>(
    endpoint: String,
    method: HTTPMethod = .GET,
    body: Encodable? = nil,
    completion: @escaping (Result<T, Error>) -> Void
  ) {
    guard let url = URL(string: "\(url)\(endpoint)") else {
      completion(.failure(NSError(domain: "Invalid URL", code: 0)))
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    if let body = body {
                do {
                    request.httpBody = try JSONEncoder().encode(body)
                } catch {
                    completion(.failure(error))
                    return
                }
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "No data", code: 0)))
                    return
                }
                
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
  }
}
