//
//  MovieDetailsViewModelTests.swift
//  banquemisr.challenge05.*Tests
//
//  Created by Sarah on 02/10/2024.
//

import XCTest
@testable import banquemisr_challenge05__

final class MovieDetailsViewModelTests: XCTestCase {
    
    var viewModel: MovieDetailsViewModel!
    var mockNetworkManager: MockNetworkManager!
    var mockAPIManager: MockAPIManager!
    var mockCoreDataManager: MockCoreDataManager!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        mockAPIManager = MockAPIManager()
        mockCoreDataManager = MockCoreDataManager()
 
        viewModel = MovieDetailsViewModel(movieID: 1, networkManager: mockNetworkManager, apiManager: mockAPIManager, coreDataManager: mockCoreDataManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkManager = nil
        mockAPIManager = nil
        mockCoreDataManager = nil
        super.tearDown()
    }
    
    
    func testGetMovieDetailsFromAPI_Success() {
        let expectedMovieDetails = MovieDetails(id: 1, title: "Mock Movie", overview: "Mock Overview", runtime: 120, poster_path: "mockpath.jpg")
        mockNetworkManager.addMockResponse(for: MovieDetails.self, response: expectedMovieDetails)
        mockNetworkManager.shouldReturnError = false
        
        let expectation = self.expectation(description: "Movie details should be fetched successfully from API")
        
        viewModel.bindResultToViewController = {
            XCTAssertEqual(self.viewModel.movie?.title, expectedMovieDetails.title)
            expectation.fulfill()
        }
        
        viewModel.getMovieDetails()

        waitForExpectations(timeout: 7, handler: nil)
    }
    
    
    func testGetMovieDetailsFromAPI_Failure() {
        // Simulate API failure
        mockNetworkManager.shouldReturnError = true
        
        let expectation = self.expectation(description: "Network error should be handled")
        
        viewModel.bindErrorToViewController = { errorMessage in
            XCTAssertEqual(errorMessage, "Network error: Network error")
            expectation.fulfill()
        }
        
        viewModel.getMovieDetails()
        
        waitForExpectations(timeout: 7, handler: nil)
    }
    
}
