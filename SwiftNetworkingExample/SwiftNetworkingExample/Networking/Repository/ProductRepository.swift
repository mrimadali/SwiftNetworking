//
//  ProductRepository.swift
//  SwiftNetworkingExample
//
//  Created by Imaad  on 8/11/24.
//

import Foundation
import SwiftNetworking

protocol ProductProtocol {
    func fetchProducts() async -> Result<ProductRoot, APIError>
    
}

class ProductRepository: ProductProtocol {
    static let shared = ProductRepository()
    
    let manager: NetworkManager
    
    init(manager: NetworkManager = NetworkManager.shared) {
        self.manager = manager
    }
    
    func fetchProducts() async -> Result<ProductRoot, APIError> {
        return await manager.execute(ProductEndpoint.getProducts)
    }
}

