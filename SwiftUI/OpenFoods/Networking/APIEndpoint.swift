//
//  APIEndpoint.swift
//  OpenFoods
//
//  Created by Victor Ulloa on 2025-11-07.
//

import Foundation

enum APIEndpoint {
    case listFoods(page: Int)
    case likeFood(foodId: Int)
    case unlikeFood(foodId: Int)

    var method: HTTPMethod {
        switch self {
        case .listFoods: return .GET
        case .likeFood, .unlikeFood: return .PUT
        }
    }

    func path(with userId: String) -> String {
        switch self {
        case let .listFoods(page):
            return "/api/v1/\(userId)/food/\(page)"
        case let .likeFood(foodId):
            return "/api/v1/\(userId)/food/\(foodId)/like"
        case let .unlikeFood(foodId):
            return "/api/v1/\(userId)/food/\(foodId)/unlike"
        }
    }

    var headers: [String: String]? { nil }
    var queryItems: [URLQueryItem]? { nil }
    var bodyData: Data? { nil }
}
