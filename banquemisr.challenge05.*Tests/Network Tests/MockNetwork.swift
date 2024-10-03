//
//  MockNetwork.swift
//  banquemisr.challenge05.*Tests
//
//  Created by Sarah on 02/10/2024.
//

import XCTest
@testable import banquemisr_challenge05__


class MockURLSession: URLSession {
    
    var data: Data?
    var response: URLResponse?
    var error: Error?
    var responseCode: Int = 200 // Default to 200 OK

    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let mockResponse = HTTPURLResponse(url: url, statusCode: responseCode, httpVersion: nil, headerFields: nil)
        return MockURLSessionDataTask {
            completionHandler(self.data, self.response, self.error)
        }
    }
}


class MockURLSessionDataTask: URLSessionDataTask {
    private let completionHandler: (() -> Void)?
    
    init(completionHandler: @escaping () -> Void) {
        self.completionHandler = completionHandler
    }
    
    override func resume() {
        DispatchQueue.global().asyncAfter(deadline: .now()) {
            self.completionHandler?()
        }
    }
}
