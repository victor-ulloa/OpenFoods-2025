//
//  ViewModel.swift
//  OpenFoods
//
//  Created by Victor Ulloa on 2025-11-07.
//

import Combine

@MainActor
final class MainViewModel: ObservableObject {
    @Published private(set) var foods: [FoodItem] = []
    @Published private(set) var isLoading = false
    @Published private(set) var canLoadMore = true
    
    private let network: NetworkServicing = NetworkManager(config: NetworkConfig())
    private var currentPage = 0
    
    func fetchFoods() async {
        guard !isLoading else { return }
        isLoading = true
        
        do {
            let response = try await network.fetchFoods(page: currentPage)
            if currentPage == 0 {
                foods = response.foods
            } else {
                foods.append(contentsOf: response.foods)
            }
            canLoadMore = foods.count < response.totalCount
            currentPage += 1
        } catch {
            print("Error fetching foods:", error)
        }
        
        isLoading = false
    }
    
    func fetchFoodsIfNeeded() async {
        if canLoadMore && !isLoading {
            await fetchFoods()
        }
    }
}
