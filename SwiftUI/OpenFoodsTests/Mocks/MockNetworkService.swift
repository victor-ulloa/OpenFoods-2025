//
//  MockNetworkService.swift
//  OpenFoods
//
//  Created by Victor Ulloa on 2025-11-09.
//

import Foundation

actor MockNetworkService: NetworkServicing {
    var mockResponse: FoodResponse?
    var likedFoodIds: Set<Int> = []
    
    func fetchFoods(page: Int) async throws -> FoodResponse {
        guard let mockResponse else { throw URLError(.badServerResponse) }
        return mockResponse
    }
    
    func likeFood(foodId: Int) async throws {
        likedFoodIds.insert(foodId)
    }
    
    func unlikeFood(foodId: Int) async throws {
        likedFoodIds.remove(foodId)
    }
    
    func setMockResponse(_ response: FoodResponse) async {
        mockResponse = response
    }
}
