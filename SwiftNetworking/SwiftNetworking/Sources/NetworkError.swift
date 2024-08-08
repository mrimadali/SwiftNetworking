//
//  NetworkError.swift
//
//
//  Created by Imaad  on 8/8/24.
//

import Foundation

struct NetworkError: Decodable, Error {
    let message: String
    let statusCode: Int?

    init(message: String? = Self.unknown, statusCode: Int? = nil) {
        self.message = message ?? Self.unknown
        self.statusCode = statusCode
    }

    static let unknown = "Network error. Please check your connection."
    static var defaultError = NetworkError()
}
