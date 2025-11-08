//
//  FoodRowView.swift
//  OpenFoods
//
//  Created by Victor Ulloa on 2025-11-08.
//

import SwiftUI

struct FoodRowView: View {
    let item: FoodItem
    var onLikeToggle: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: URL(string: item.photoURL)) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 70, height: 70)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name).font(.headline)
                Text("\(item.countryOfOrigin.countryFlag) \(item.countryOfOrigin)")
                    .font(.subheadline).foregroundStyle(.secondary)
                Text(item.description)
                    .font(.caption).foregroundStyle(.gray)
                    .lineLimit(2)
            }

            Spacer()

            Button {
                onLikeToggle?()
            } label: {
                Image(systemName: item.isLiked ? "heart.fill" : "heart")
                    .foregroundColor(item.isLiked ? .red : .gray)
                    .imageScale(.large)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2, y: 1)
    }
}
