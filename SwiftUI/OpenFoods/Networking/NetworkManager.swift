//
//  NetworkManager.swift
//  OpenFoods
//
//  Created by Victor Ulloa on 2025-11-07.
//

import Foundation

// MARK: - HTTPMethod
enum HTTPMethod: String {
    case GET, POST, PUT, PATCH, DELETE
}

// MARK: - URLSessionProtocol for testability
protocol URLSessionProtocol: Sendable {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

// MARK: - NetworkServicing
protocol NetworkServicing: Sendable {
    func fetchFoods(page: Int) async throws -> FoodResponse
    func likeFood(foodId: Int) async throws
    func unlikeFood(foodId: Int) async throws
}

// MARK: - NetworkManager
final actor NetworkManager: NetworkServicing {
    private let session: URLSessionProtocol
    private var config: NetworkConfig
    private let decoder = JSONDecoder()
    
    init(config: NetworkConfig,
         session: URLSessionProtocol = URLSession.shared) {
        self.config = config
        self.session = session
    }
    
    // MARK: - Public API
    func setConfig(_ newConfig: NetworkConfig) {
        self.config = newConfig
    }
    
    func fetchFoods(page: Int) async throws -> FoodResponse {
        let endpoint: APIEndpoint = .listFoods(page: page)
        let data = try await perform(endpoint)
        do {
            return try decoder.decode(FoodResponse.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(underlying: error)
        }
    }
    
    func likeFood(foodId: Int) async throws {
        let endpoint: APIEndpoint = .likeFood(foodId: foodId)
        _ = try await perform(endpoint)
    }
    
    func unlikeFood(foodId: Int) async throws {
        let endpoint: APIEndpoint = .unlikeFood(foodId: foodId)
        _ = try await perform(endpoint)
    }
    
    // MARK: - Helpers
    private func perform(_ endpoint: APIEndpoint) async throws -> Data {
        do {
            let request = try buildRequest(for: endpoint)
            let (data, response) = try await session.data(for: request)
            try validate(response: response, data: data)
            return data
        } catch {
            throw mapError(error)
        }
    }
    
    private func buildRequest(for endpoint: APIEndpoint) throws -> URLRequest {
        guard var components = URLComponents(url: config.baseURL.appendingPathComponent(endpoint.path(with: config.userId)), resolvingAgainstBaseURL: false) else {
            throw NetworkError.invalidURL
        }
        components.queryItems = endpoint.queryItems
        
        guard let url = components.url else { throw NetworkError.invalidURL }
        var request = URLRequest(url: url, timeoutInterval: config.timeout)
        request.httpMethod = endpoint.method.rawValue
        
        var headers = config.defaultHeaders
        if let extra = endpoint.headers { headers.merge(extra) { _, new in new } }
        for (key, value) in headers { request.setValue(value, forHTTPHeaderField: key) }
        
        return request
    }
    
    private func validate(response: URLResponse, data: Data) throws {
        guard let http = response as? HTTPURLResponse else { throw NetworkError.invalidResponse }
        switch http.statusCode {
        case 200...299:
            return
        case 204:
            return
        default:
            throw NetworkError.unacceptableStatusCode(http.statusCode, data.isEmpty ? nil : data)
        }
    }
    
    private func mapError(_ error: Error) -> NetworkError {
        if let urlError = error as? URLError {
            if urlError.code == .cancelled { return .cancelled }
            return .requestFailed(underlying: urlError)
        }
        if let net = error as? NetworkError { return net }
        return .requestFailed(underlying: error)
    }
}
