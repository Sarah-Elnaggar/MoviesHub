//
//  MockNetworkManager.swift
//  banquemisr.challenge05.*Tests
//
//  Created by Sarah on 02/10/2024.
//

import XCTest
@testable import banquemisr_challenge05__


class MockNetworkManager: NetworkProtocol {
    
    var shouldReturnError = false
    var mockResponses: [String: Any] = [:]
    
    func fetch<T>(url: String, type: T.Type, completion: @escaping (T?, Error?) -> Void) where T : Decodable, T : Encodable {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            if self.shouldReturnError {
                completion(nil, NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Network error"]))
            } else {
                if let response = self.mockResponses[String(describing: type)] as? T {
                    completion(response, nil)
                } else {
                    completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No mock data for the given type"]))
                }
            }
        }
    }
    
    
    func addMockResponse<T>(for type: T.Type, response: T) where T: Decodable {
        mockResponses[String(describing: type)] = response
    }
}
