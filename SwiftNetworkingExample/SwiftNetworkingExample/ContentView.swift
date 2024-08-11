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
            VStack(alignment: .leading) {
                if viewModel.isLoading {
                    ProgressView("Loading...") // Activity Indicator
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)

                }else {
                    if let products = self.viewModel.products {
                        List {
                            ForEach(products) { product in
                                HStack {
                                    if let urlString = product.image, let url = URL(string: urlString) {
                                        AsyncImage(url: url) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 100, height: 100)
                                                .clipShape(Rectangle())
                                        } placeholder: {
                                            ProgressView()
                                                .frame(width: 100, height: 100)
                                        }
                                        
                                    }
                                    VStack(alignment: .leading) {
                                        Text(product.title ?? "")
                                            .font(.headline)
                                            .lineLimit(1)
                                        Text(product.description ?? "")
                                            .font(.subheadline)
                                            .lineLimit(2)
                                        
                                        let price = String(format: "$%.2f", product.price!)
                                        Text(price)
                                            .font(.caption)
                                    }
                                }
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
