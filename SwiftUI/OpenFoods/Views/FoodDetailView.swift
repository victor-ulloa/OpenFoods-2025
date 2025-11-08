//
//  FoodDetailView.swift
//  OpenFoods
//
//  Created by Victor Ulloa on 2025-11-08.
//

import SwiftUI

struct FoodDetailView: View {
    let food: FoodItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: food.photoURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 4)

                VStack(alignment: .leading, spacing: 8) {
                    Text(food.name)
                        .font(.title)
                        .bold()

                    Text("\(food.countryOfOrigin.countryFlag) \(food.countryOfOrigin)")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    Text(food.description)
                        .font(.body)
                        .padding(.top, 8)

                    Text("Last updated: \(food.lastUpdatedDate)")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                }
                .padding(.horizontal)
            }
        }
        .presentationDetents([.medium, .large])
    }
}
