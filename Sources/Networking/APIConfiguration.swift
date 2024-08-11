//
//  APIConfiguration.swift
//  
//
//  Created by Imaad  on 8/8/24.
//

import Foundation

// Template to construct API endpoints
public protocol APIConfiguration {
    var urlPath: String { get }
    var parameters: [URLQueryItem] { get }
    var method: APIMethod { get }
    var headers: [String: String]? { get }
    var body: Encodable?{ get }
}

public extension APIConfiguration {
    var isAuthenticated: Bool {
        if let accessToken = headers?["Authorization"], accessToken.count > 0 {
            return true
        }
        return false
    }
}

public enum APIMethod {
    case get, post, patch, put, delete
    
    var description: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .patch:
            return "PATCH"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        }
    }
}
