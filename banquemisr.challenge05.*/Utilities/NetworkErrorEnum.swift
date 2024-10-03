//
//  NetworkErrorEnum.swift
//  banquemisr.challenge05.*
//
//  Created by Sarah on 30/09/2024.
//

import Foundation


enum NetworkError: Error, Equatable {
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
    
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case (.noData, .noData):
            return true
        case (.decodingError(let lhsMessage), .decodingError(let rhsMessage)):
            return lhsMessage == rhsMessage
        case (.httpError(let lhsCode), .httpError(let rhsCode)):
            return lhsCode == rhsCode
        case (.other(let lhsError), .other(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
