//
//  MovieListViewModelTests.swift
//  banquemisr.challenge05.*Tests
//
//  Created by Sarah on 02/10/2024.
//

import XCTest
@testable import banquemisr_challenge05__

final class MoviesListViewModelTests: XCTestCase {
    
    var viewModel: MoviesListViewModel!
    var mockNetworkManager: MockNetworkManager!
    var mockAPIManager: MockAPIManager!
    var mockCoreDataManager: MockCoreDataManager!
   // var mockReachability: MockReachability!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        mockAPIManager = MockAPIManager()
        mockCoreDataManager = MockCoreDataManager()
      // mockReachability = MockReachability()
        
        viewModel = MoviesListViewModel(screenType: .nowPlaying, networkManager: mockNetworkManager, apiManager: mockAPIManager, coreDataManager: mockCoreDataManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkManager = nil
        mockAPIManager = nil
        mockCoreDataManager = nil
        super.tearDown()
    }
    
    
    func testGetMoviesListFromAPI_Success() {
        let movie = Movie(id: 1, poster_path: "poster.png", release_date: "2024-01-01", title: "Test Movie")
        let response = MovieResponse(results: [movie])
        mockNetworkManager.addMockResponse(for: MovieResponse.self, response: response)
        
        let expectation = self.expectation(description: "Fetching movies from API")
        var isExpectationFulfilled = false
        
        viewModel.bindResultToViewController = {
            guard !isExpectationFulfilled else { return }
            isExpectationFulfilled = true
            XCTAssertEqual(self.viewModel.movies?.count, 1)
            XCTAssertEqual(self.viewModel.movies?.first?.title, "Test Movie")
            expectation.fulfill()
        }
        
        viewModel.getMoviesList()
        
        waitForExpectations(timeout: 7, handler: nil)
    }
  
    
    func testGetMoviesListFromAPI_Failure() {
        // Simulate API failure
        mockNetworkManager.shouldReturnError = true
        
        let expectation = self.expectation(description: "API Failure Handling")
        
        viewModel.bindErrorToViewController = { errorMessage in
            XCTAssertEqual(errorMessage, "Network error: Network error")
            expectation.fulfill()
        }
        
        viewModel.getMoviesList()
        waitForExpectations(timeout: 7, handler: nil)
    }
    
}
