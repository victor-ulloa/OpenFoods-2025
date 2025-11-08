//
//  NetworkError.swift
//  OpenFoods
//
//  Created by Victor Ulloa on 2025-11-07.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case requestFailed(underlying: Error)
    case invalidResponse
    case unacceptableStatusCode(Int, Data?)
    case decodingFailed(underlying: Error)
    case cancelled
    case noData

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .requestFailed(let underlying):
            return "The request failed: \(underlying.localizedDescription)"
        case .invalidResponse:
            return "The server response was invalid."
        case .unacceptableStatusCode(let code, _):
            return "Received unacceptable status code: \(code)."
        case .decodingFailed(let underlying):
            return "Failed to decode the response: \(underlying.localizedDescription)"
        case .cancelled:
            return "The request was cancelled."
        case .noData:
            return "No data was returned by the server."
        }
    }
}
