//
//  File.swift
//  
//
//  Created by Imaad  on 8/8/24.
//

import Foundation

public enum APIError: Error, Equatable {
    
    case invalidURL
    case invalidRequest
    case invalidResponse
    case decodingError
    case missingToken
    case notImplemented
    case badRequest
    case unauthorized
    case notFound
    case internalServerError
    case networkError(_ message: String)

    var description: String {
        
        switch self {
        case .invalidURL,
             .invalidRequest,
             .invalidResponse,
             .decodingError,
             .missingToken,
             .notImplemented:
            
            return "Network Error. Please check your connection and try again."
            
        case .badRequest:
            return "The server cannot or will not process the request due to an apparent client error"
            
        case .unauthorized:
            return "Unauthenticated, the user does not have valid authentication credentials for the target resource."
            
        case .notFound:
            return "Not found, the requested resource could not be found"
            
        case .internalServerError:
            
            return "Internal server error, the server either does not recognize the request method"
            
        case .networkError(let message):
            
            return message
            
        }
        
    }
}
