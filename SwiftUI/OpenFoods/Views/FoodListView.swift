//
//  FoodListView.swift
//  OpenFoods
//
//  Created by Victor Ulloa on 2025-11-08.
//

import SwiftUI

struct FoodListView: View {
    @StateObject private var viewModel = FoodListViewModel()
    @State private var selectedFood: FoodItem?

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.foods.isEmpty {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.foods.isEmpty {
                    Text("No foods found.")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.foods, id: \.id) { food in
                                Button {
                                    selectedFood = food
                                } label: {
                                    FoodRowView(item: food)
                                }
                                .buttonStyle(.plain)
                                .onAppear {
                                    if food == viewModel.foods.last {
                                        Task {
                                            await viewModel.fetchFoodsIfNeeded()
                                        }
                                    }
                                }
                            }

                            if viewModel.isLoading {
                                ProgressView()
                                    .padding(.vertical, 20)
                            } else if !viewModel.canLoadMore {
                                Text("No more results")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                                    .padding(.vertical, 10)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Foods")
            .task {
                if viewModel.foods.isEmpty {
                    await viewModel.fetchFoods()
                }
            }
            .sheet(item: $selectedFood) { food in
                FoodDetailView(food: food)
            }
        }
    }
}
