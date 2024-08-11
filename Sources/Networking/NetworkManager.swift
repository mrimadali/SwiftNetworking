//
//  NetworkManager.swift
//
//
//  Created by Imaad  on 8/8/24.
//

import Foundation

public typealias NetworkResponse = (data: Data, response: URLResponse)

public protocol NetworkManagerProtocol {
    
    /// Execute with the default json decoder.
    func execute<U: Decodable>(_ config: any APIConfiguration) async -> Result<U, APIError>
    
    /// Execute with a custom json decoder.
    func execute<U: Decodable>(_ config: any APIConfiguration,
                               _ jsonDecoder: JSONDecoder) async -> Result<U, APIError>
    
    /// Execute without decoding (void response).
    func execute(_ config: any APIConfiguration) async -> APIError?
    
    /// This method is mainly to process requests which return empty responses.
    /// It is possbile that requests of type DELETE, PATCH or POST etc would qualify to use this function.
    func processRequest(_ config: any APIConfiguration) async throws -> NetworkResponse
    
    /// Get a network error message for a set of data.
    /// If the data contains no network error, a default
    /// error message will be returned.
    func networkErrorMessage(_ data: Data) -> String
    
}

public class NetworkManager: NetworkManagerProtocol {
    
    public static let shared = NetworkManager()
    
    public func execute<U: Decodable>(_ config: any APIConfiguration) async -> Result<U, APIError> {
        return await self.execute(config, JSONDecoder())
    }
    
    public func execute<U: Decodable>(_ config: any APIConfiguration, _ jsonDecoder: JSONDecoder) async -> Result<U, APIError> {
        print("-----Processing a request:\(config.method)-------")
        guard let url = URL(string: config.urlPath),
              var request = getRequest(config, url: url) else {
            
            print("------URL conversion from string failed for \(config.urlPath)------")
            return .failure(APIError.invalidURL)
            
        }
        print("-------Request URL: \(url)-------")
        if config.isAuthenticated, let token = config.headers?["Authorization"] {
            print("------Authenticating using bearer token------")
            request.allHTTPHeaderFields?["Authorization"] = "Bearer \(token)"
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            print("-----Processing a sucessful response: \(config.method)-------")
            guard let response = response as? HTTPURLResponse, response.statusCode == 400 else {
                return .failure(.badRequest)
            }
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(.invalidRequest)
            }
            
            guard response.statusCode == 401 else {
                return .failure(.unauthorized)
            }
            
            guard 402...499 ~= response.statusCode else {
                return .failure(.notFound)
            }
            
            guard 500...599 ~= response.statusCode else {
                return .failure(.internalServerError)
            }
            
            guard 200...299 ~= response.statusCode else {
                let message = networkErrorMessage(data)
                print("failed signing in \(message)")
                return .failure(.networkError(message))
            }
            
            do {
                let result = try jsonDecoder.decode(U.self, from: data)
                return .success(result)
            }
            catch {
                print("------Decoding error occurred during \(config.urlPath), \(error.localizedDescription.debugDescription)-------")
                return .failure(.decodingError)
            }
        }
        catch {
            return .failure(.invalidRequest)
        }
        
    }
    
    public func execute(_ config: any APIConfiguration) async -> APIError? {
        guard let url = URL(string: config.urlPath),
              var request = getRequest(config, url: url) else {
            
            print("-----URL conversion from string failed for \(config.urlPath)------")
            return .invalidURL
        }
        print("-------Request URL: \(url)-------")
        if config.isAuthenticated, let token = config.headers?["Authorization"] {
            print("------Authenticating using bearer token------")
            request.allHTTPHeaderFields?["Authorization"] = "Bearer \(token)"
        }
        do {
            let (data, response) = try await URLSession
                .shared
                .data(for: request)
            
            guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                let message = networkErrorMessage(data)
                print("-------failed signing in \(message)------")
                return .networkError(message)
            }
            return nil
        }
        catch {
            return .invalidRequest
        }
        
    }
    
    public func processRequest(_ config: any APIConfiguration) async throws -> NetworkResponse {
        guard let url = URL(string: config.urlPath),
              var request = getRequest(config, url: url) else {
            print("------URL conversion from string failed for \(config.urlPath)------")
            throw APIError.invalidURL
        }
        
        if config.isAuthenticated {
            if config.isAuthenticated, let token = config.headers?["Authorization"] {
                print("------Authenticating using bearer token------")
                request.allHTTPHeaderFields?["Authorization"] = "Bearer \(token)"
            }
        }
        return try await URLSession
            .shared
            .data(for: request)
    }
    
    public func networkErrorMessage(_ data: Data) -> String {
        do {
            let error = try JSONDecoder().decode(
                NetworkError.self,
                from: data
            )
            print("------" + error.message + "------")
            return error.message
        }
        catch {
            print("----Network Error. Please check your connection and try again-----")
            // May return default error message here
            return "Network Error. Please check your connection and try again."
        }
        
    }
    
    // MARK: Private
    
    public func getRequest<Y: APIConfiguration>(_ config: Y, url: URL) -> URLRequest? {
        var urlComponents = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
        )
        
        if !config.parameters.isEmpty {
            urlComponents?.queryItems = config.parameters
        }
        
        if let fullURL = urlComponents?.url {
            
            var request = URLRequest(url: fullURL)
            request.httpMethod = config.method.description
            request.allHTTPHeaderFields = config.headers
            request.httpBody = config.body?.jsonEncodedData
            return request
            
        }
        return nil
    }
    
}

extension Encodable {
    public var jsonEncodedData: Data? {
        try? JSONEncoder().encode(self)
    }
}
