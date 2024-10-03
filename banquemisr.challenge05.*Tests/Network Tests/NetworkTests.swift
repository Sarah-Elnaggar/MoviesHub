//
//  NetworkTests.swift
//  banquemisr.challenge05.*Tests
//
//  Created by Sarah on 02/10/2024.
//

import XCTest
@testable import banquemisr_challenge05__

final class NetworkTests: XCTestCase {
    
    var networkManager: NetworkManager!
    var mockSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        networkManager = NetworkManager(session: mockSession)
    }
    
    override func tearDown() {
        networkManager = nil
        mockSession = nil
        super.tearDown()
    }
    
    func testFetchMoviesSuccess() {
        let jsonResponse = """
            {
                "results": [
                    {
                        "id": 1,
                        "title": "Movie 1"
                    }
                ],
            }
            """
        mockSession.data = jsonResponse.data(using: .utf8)
        mockSession.response = HTTPURLResponse(url: URL(string: "https://mockurl.com")!,
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)
        mockSession.error = nil
        
        let expectation = self.expectation(description: "Fetch Movie Data")
        
        networkManager.fetch(url: "https://mockurl.com", type: MovieResponse.self) { response, error in
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            XCTAssertEqual(response?.results?.first?.title, "Movie 1")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    
    func testFetchInvalidURL() {
        let expectation = self.expectation(description: "Invalid URL")
        
        networkManager.fetch(url: "", type: MovieResponse.self) { response, error in
            XCTAssertNil(response)
            
            if let networkError = error as? NetworkError {
                // Ensure you're comparing the error correctly
                XCTAssertEqual(networkError, .invalidURL)
                XCTAssertEqual(networkError.errorMessage, "The URL provided was invalid.")
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }


    
    func testFetchNoData() {
        mockSession.data = nil
        mockSession.response = HTTPURLResponse(url: URL(string: "https://mockurl.com")!,
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)
        mockSession.error = nil
        
        let expectation = self.expectation(description: "No Data")
        
        networkManager.fetch(url: "https://mockurl.com", type: MovieResponse.self) { response, error in
            XCTAssertNil(response)
            XCTAssertEqual((error as? NetworkError), NetworkError.noData)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
