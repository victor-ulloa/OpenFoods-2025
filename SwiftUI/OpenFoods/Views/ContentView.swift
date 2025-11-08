//
//  ContentView.swift
//  OpenFoods
//
//  Created by Oliver Kirkland on 30/03/2025.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    var viewModel: MainViewModel = .init()
    
    var body: some View {
        VStack {
            FoodListView()
        }
    }
}

#Preview {
    ContentView()
}
