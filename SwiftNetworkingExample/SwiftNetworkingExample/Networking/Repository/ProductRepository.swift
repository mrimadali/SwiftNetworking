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
    func fetchProducts() async -> Result<ProductRoot, APIError> {
        static let shared = AuthRepository()
        
        let service: NetworkManager
        
        init(
            service: NetworkManager = NetworkManager.shared,
        ) {
            self.service = service
        }

    }
}
