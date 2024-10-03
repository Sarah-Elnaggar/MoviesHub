//
//  MockAPIManager.swift
//  banquemisr.challenge05.*Tests
//
//  Created by Sarah on 02/10/2024.
//

import XCTest
@testable import banquemisr_challenge05__

class MockAPIManager: APIManagerProtocol {
    
    func getUrl(for endpoint: EndPoint) -> String {
        return "https://mockurl.com"
    }
    
}
