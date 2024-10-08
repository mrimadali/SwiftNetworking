//
//  ContentView+ViewModel.swift
//  SwiftNetworkingExample
//
//  Created by Imaad  on 8/11/24.
//

import Foundation

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        
        let productRepository: ProductRepository
        init(productRepository: ProductRepository = ProductRepository.shared) {
            self.productRepository = productRepository
        }
        @Published var products: [Product]? = nil
        @Published var isLoading: Bool = false

        func onAppear() {
            isLoading  = true
            Task.detached { [weak self] in
                await self?.getProductsRequest()
            }
        }
        
        func getProductsRequest() async {
            print("------getProductsRequest------")
            Task {
                let result = await self.productRepository.fetchProducts()
                self.isLoading = false
                switch result {
                case let .success(products):
                    self.products = products
                    print("-------getProductsRequest.Success-----")
                    print(self.products)
                case let .failure(error):
                    print("getProductsRequest.fail: \(error)")

                }
            }
        }

    }
}
