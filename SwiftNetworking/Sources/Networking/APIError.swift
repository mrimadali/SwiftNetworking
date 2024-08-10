//
//  File.swift
//  
//
//  Created by Imaad  on 8/8/24.
//

import Foundation

enum APIError: Error, Equatable {
    
    case invalidURL
    case invalidRequest
    case invalidResponse
    case networkError(_ message: String)
    case decodingError
    case missingToken
    case notImplemented
    
    var description: String {
        
        switch self {
        case .invalidURL,
             .invalidRequest,
             .invalidResponse,
             .decodingError,
             .missingToken:
            
            return "Network Error. Please check your connection and try again."
            
        case .networkError(let message):
            
            return message

        case .notImplemented:
            
            return "Not Implemented"
            
        }
        
    }
}
