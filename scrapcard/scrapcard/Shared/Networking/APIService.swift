//
//  APIService.swift
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

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int)
    case noData

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request URL is invalid."
        case .invalidResponse:
            return "The server returned an invalid response."
        case .serverError(let statusCode):
            return "The server returned status code \(statusCode)."
        case .noData:
            return "The server returned no data."
        }
    }
}

final class APIService {
    static let shared = APIService()

    private let baseURL = URL(string: "http://localhost:5050")!
    private let urlSession: URLSession
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder

    private init(
        urlSession: URLSession = .shared,
        jsonEncoder: JSONEncoder = JSONEncoder(),
        jsonDecoder: JSONDecoder = JSONDecoder()
    ) {
        self.urlSession = urlSession
        self.jsonEncoder = jsonEncoder
        self.jsonDecoder = jsonDecoder
    }

    func request<Response: Decodable>(
        endpoint: String,
        method: HTTPMethod = .GET
    ) async throws -> Response {
        try await request(endpoint: endpoint, method: method, body: Optional<EmptyRequestBody>.none)
    }

    func request<Response: Decodable, RequestBody: Encodable>(
        endpoint: String,
        method: HTTPMethod = .GET,
        body: RequestBody?
    ) async throws -> Response {
        let request = try makeURLRequest(endpoint: endpoint, method: method, body: body)
        let (data, response) = try await urlSession.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw APIError.serverError(statusCode: httpResponse.statusCode)
        }

        guard !data.isEmpty else {
            throw APIError.noData
        }

        return try jsonDecoder.decode(Response.self, from: data)
    }

    private func makeURLRequest<RequestBody: Encodable>(
        endpoint: String,
        method: HTTPMethod,
        body: RequestBody?
    ) throws -> URLRequest {
        guard let url = URL(string: endpoint, relativeTo: baseURL) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if let body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try jsonEncoder.encode(body)
        }

        return request
    }
}

private struct EmptyRequestBody: Encodable {}
