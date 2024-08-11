//
//  ContentView.swift
//  SwiftNetworkingExample
//
//  Created by Imaad  on 8/8/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: Self.ViewModel
    var body: some View {
        NavigationStack {
            ScrollView {
                if let products = self.viewModel.products {
                    List {
                        ForEach(products) { product in
                            VStack {
                                Text(product.title ?? "")
                                    .font(.title)
                                Text(product.description ?? "")
                                    .font(.subheadline)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Products")
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

#Preview {
    ContentView(viewModel: ContentView.ViewModel())
}
