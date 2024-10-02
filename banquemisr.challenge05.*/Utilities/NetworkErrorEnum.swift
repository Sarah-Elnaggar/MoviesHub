//
//  NetworkErrorEnum.swift
//  banquemisr.challenge05.*
//
//  Created by Sarah on 30/09/2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError(String)
    case httpError(Int)
    case other(Error)
    
    
    var errorMessage: String {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .noData:
            return "No data was received from the server."
        case .decodingError(let message):
            return "Failed to decode the data: \(message)"
        case .httpError(let statusCode):
            return "Received an HTTP error with status code: \(statusCode)"
        case .other(let error):
            return "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
    
}
