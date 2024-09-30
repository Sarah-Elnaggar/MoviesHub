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
}
