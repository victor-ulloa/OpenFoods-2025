//
//  FoodItem.swift
//  OpenFoods
//
//  Created by Victor Ulloa on 2025-11-07.
//

struct FoodItem: Decodable, Sendable, Equatable, Identifiable {
    let id: Int
    let name: String
    var isLiked: Bool
    let photoURL: String
    let description: String
    let countryOfOrigin: String
    let lastUpdatedDate: String
}
