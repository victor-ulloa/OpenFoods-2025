//
//  FoodResponse.swift
//  OpenFoods
//
//  Created by Victor Ulloa on 2025-11-07.
//

struct FoodResponse: Decodable, Sendable {
    let foods: [FoodItem]
    let totalCount: Int
}
