//
//  APIManagerTests.swift
//  banquemisr.challenge05.*Tests
//
//  Created by Sarah on 02/10/2024.
//

import XCTest
@testable import banquemisr_challenge05__

final class APIManagerTests: XCTestCase {
    
    var apiManager: APIManagerProtocol!
    
    override func setUp() {
        super.setUp()
        apiManager = APIManager()
    }
    
    override func tearDown() {
        apiManager = nil
        super.tearDown()
    }
    
    func testNowPlayingURL() {
        let expectedURL = "https://api.themoviedb.org/3/movie/now_playing?api_key=6974796546c7f41cece685a979189536"
        let resultURL = apiManager.getUrl(for: .nowPlaying)
        XCTAssertEqual(resultURL, expectedURL, "The now playing URL is incorrect")
    }
    
    func testUpcomingURL() {
        let expectedURL = "https://api.themoviedb.org/3/movie/upcoming?api_key=6974796546c7f41cece685a979189536"
        let resultURL = apiManager.getUrl(for: .upcoming)
        XCTAssertEqual(resultURL, expectedURL, "The upcoming URL is incorrect")
    }
    
    func testPopularURL() {
        let expectedURL = "https://api.themoviedb.org/3/movie/popular?api_key=6974796546c7f41cece685a979189536"
        let resultURL = apiManager.getUrl(for: .popular)
        XCTAssertEqual(resultURL, expectedURL, "The popular URL is incorrect")
    }
    
    func testMovieDetailsURL() {
        let movieId = 12345
        let expectedURL = "https://api.themoviedb.org/3/movie/12345?api_key=6974796546c7f41cece685a979189536"
        let resultURL = apiManager.getUrl(for: .movieDetails(movieId: movieId))
        XCTAssertEqual(resultURL, expectedURL, "The movie details URL is incorrect")
    }
    
}
