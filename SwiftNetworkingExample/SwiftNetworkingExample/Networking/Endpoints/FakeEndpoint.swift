//
//  FakeEndpoint.swift
//  SwiftNetworkingExample
//
//  Created by Imaad  on 8/11/24.
//

import Foundation
import SwiftNetworking

enum AuthEndpoint {
    case getProducts
}


extension AuthEndpoint: APIConfiguration {
    var baseURLString: String {
        return "https://fakestoreapi.com/"
    }

    var urlPath: String {
        let path: String
        switch self {
        case .getProducts:
            path =  "/products"
        }
        return baseURLString + path
    }
    
    var parameters: [URLQueryItem] {
        return []
    }
    
    var method: APIMethod {
        let method: APIMethod
        switch self {
        case .updateUserProfile:
            method = .put
        }
        return method
    }

    
    
}
