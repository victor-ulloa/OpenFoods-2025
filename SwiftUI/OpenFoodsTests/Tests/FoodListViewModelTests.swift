//
//  FoodListViewModelTests.swift
//  OpenFoodsTests
//
//  Created by Victor Ulloa on 2025-11-09.
//

import Testing

@MainActor
struct FoodListViewModelTests {
    
    @Test("Fetch foods populates the first page correctly")
    func testInitialFetch() async throws {
        let mockNetwork = MockNetworkService()
        await mockNetwork.setMockResponse(
            FoodResponse(
                foods: [
                    FoodItem(
                        id: 1,
                        name: "Pizza",
                        isLiked: false,
                        photoURL: "https://example.com/pizza.jpg",
                        description: "Cheesy and delicious",
                        countryOfOrigin: "Italy",
                        lastUpdatedDate: "2025-11-01"
                    )
                ],
                totalCount: 5
            )
        )
        
        let viewModel = FoodListViewModel(network: mockNetwork)
        await viewModel.fetchFoods()
        
        #expect(viewModel.foods.count == 1)
        #expect(viewModel.foods.first?.name == "Pizza")
        #expect(viewModel.canLoadMore == true)
    }
    
    @Test("Pagination appends results and updates correctly")
    func testPagination() async throws {
        let mockNetwork = MockNetworkService()
        
        // First page
        await mockNetwork.setMockResponse(
            FoodResponse(
                foods: [
                    FoodItem(
                        id: 1,
                        name: "Pizza",
                        isLiked: false,
                        photoURL: "https://example.com/pizza.jpg",
                        description: "Cheesy and delicious",
                        countryOfOrigin: "Italy",
                        lastUpdatedDate: "2025-11-01"
                    )
                ],
                totalCount: 4
            )
        )
        
        let viewModel = FoodListViewModel(network: mockNetwork)
        await viewModel.fetchFoods()
        
        // Second page
        await mockNetwork.setMockResponse(
            FoodResponse(
                foods: [
                    FoodItem(
                        id: 2,
                        name: "Burger",
                        isLiked: false,
                        photoURL: "https://example.com/burger.jpg",
                        description: "Juicy and tasty",
                        countryOfOrigin: "USA",
                        lastUpdatedDate: "2025-11-02"
                    )
                ],
                totalCount: 4
            )
        )
        
        await viewModel.fetchFoods()
        
        #expect(viewModel.foods.count == 2)
        #expect(viewModel.foods.last?.name == "Burger")
        #expect(viewModel.canLoadMore == true)
    }
    
    @Test("Toggling like updates local state and mock network")
    func testToggleLike() async throws {
        let mockNetwork = MockNetworkService()
        await mockNetwork.setMockResponse(
            FoodResponse(
                foods: [
                    FoodItem(
                        id: 1,
                        name: "Sushi",
                        isLiked: false,
                        photoURL: "https://example.com/sushi.jpg",
                        description: "Fresh fish and rice",
                        countryOfOrigin: "Japan",
                        lastUpdatedDate: "2025-11-01"
                    )
                ],
                totalCount: 1
            )
        )
        
        let viewModel = FoodListViewModel(network: mockNetwork)
        await viewModel.fetchFoods()
        
        var item = viewModel.foods.first!
        await viewModel.toggleLike(for: item)
        
        // Verify liked
        item = viewModel.foods.first!
        #expect(item.isLiked == true)
        
        let likedIds = await mockNetwork.likedFoodIds
        #expect(likedIds.contains(1))
        
        // Unlike
        await viewModel.toggleLike(for: item)
        
        let likedIdsAfterUnlike = await mockNetwork.likedFoodIds
        #expect(!likedIdsAfterUnlike.contains(1))
        #expect(viewModel.foods.first?.isLiked == false)
    }
    
    @Test("fetchFoodsIfNeeded only fetches when canLoadMore and not loading")
    func testFetchFoodsIfNeededConditions() async throws {
        let mockNetwork = MockNetworkService()
        await mockNetwork.setMockResponse(
            FoodResponse(
                foods: [
                    FoodItem(
                        id: 1,
                        name: "Taco",
                        isLiked: false,
                        photoURL: "https://example.com/taco.jpg",
                        description: "Spicy Mexican taco",
                        countryOfOrigin: "Mexico",
                        lastUpdatedDate: "2025-11-03"
                    )
                ],
                totalCount: 1
            )
        )
        
        let viewModel = FoodListViewModel(network: mockNetwork)
        viewModel.canLoadMore = false
        await viewModel.fetchFoodsIfNeeded()
        #expect(viewModel.foods.isEmpty)
    }
}
