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
        var productRoot: [Product]? = nil
        func onAppear() {
            Task.detached { [weak self] in
                await self?.getProductsRequest()
            }
        }
        
        func getProductsRequest() async {
            print("------getProductsRequest------")
            Task {
                let result = await self.productRepository.fetchProducts()
                switch result {
                case let .success(products):
                    self.productRoot = products
                    print("-------getProductsRequest.Success-----")
                    print(self.productRoot)
                case let .failure(error):
                    print("get Order Congratulation fail: \(error)")

                }
            }
        }

    }
}
