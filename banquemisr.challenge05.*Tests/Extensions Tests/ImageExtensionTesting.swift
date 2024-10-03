//
//  ImageExtensionTesting.swift
//  banquemisr.challenge05.*Tests
//
//  Created by Sarah on 02/10/2024.
//

import XCTest
@testable import banquemisr_challenge05__

class ImageExtensionTesting: XCTestCase {
    
    var imageView: UIImageView!
    
    override func setUp() {
        super.setUp()
        imageView = UIImageView()
    }
    
    override func tearDown() {
        imageView = nil
        super.tearDown()
    }
    
    
    func testLoadImageFromInvalidURL() {

        let placeholderImage = UIImage(named: "MovieHubIcon")
        let invalidURLString = "invalid-url"
        let expectation = self.expectation(description: "Placeholder image should be displayed for invalid URL")
        
        imageView.downloadImage(from: invalidURLString)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.imageView.image, placeholderImage, "Image should be placeholder for invalid URL")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    
    func testLoadImageWithError() {
        let placeholderImage = UIImage(named: "MovieHubIcon")
        let mockSession = MockURLSession()
        mockSession.error = NSError(domain: "TestError", code: 500, userInfo: nil) // Simulate network error
        let validURLString = "https://example.com/image.png"
        let expectation = self.expectation(description: "Placeholder image should be displayed when network error occurs")
        
        imageView.downloadImage(from: validURLString)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.imageView.image, placeholderImage, "Image should be placeholder on network error")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    
    func testLoadImageWithNoData() {
        let placeholderImage = UIImage(named: "MovieHubIcon")
        let mockSession = MockURLSession()
        mockSession.data = nil // Simulate no data returned
        let validURLString = "https://example.com/image.png"
        let expectation = self.expectation(description: "Placeholder image should be displayed when no data is returned")
        
        imageView.downloadImage(from: validURLString)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.imageView.image, placeholderImage, "Image should be placeholder when no data is returned")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    
    func testLoadImageWithInvalidStatusCode() {
        let placeholderImage = UIImage(named: "MovieHubIcon")
        let mockSession = MockURLSession()
        mockSession.responseCode = 404 // Simulate 404 error
        let validURLString = "https://example.com/image.png"
        let expectation = self.expectation(description: "Placeholder image should be displayed for non-2xx HTTP status codes")
        
        imageView.downloadImage(from: validURLString)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.imageView.image, placeholderImage, "Image should be placeholder for non-2xx HTTP status codes")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

}
