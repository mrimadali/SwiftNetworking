//
//  ProductEndpoint.swift
//  SwiftNetworkingExample
//
//  Created by Imaad  on 8/11/24.
//

import Foundation
import SwiftNetworking

enum ProductEndpoint {
    case getProducts
}


extension ProductEndpoint: APIConfiguration {
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
        case .getProducts:
            method = .get
        }
        return method
    }

    var headers: [String: String]? {

        var keyValPair = [
            "Content-type": "application/json",
            "accept": "application/json",
        ]
        
        switch self {
       /* case let .login:
            keyValPair["Authorization"] = "Bearer \(authToken)"*/
        default:
            break
        }

        return keyValPair
    }

    var body: Encodable? {
        switch self {
       /* case let .login(model):
            return model*/
        default:
            return nil
        }
    }

    
    
}
