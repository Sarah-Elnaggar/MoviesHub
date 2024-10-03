//
//  ReachabilityServices.swift
//  banquemisr.challenge05.*
//
//  Created by Sarah on 03/10/2024.
//

import Foundation

protocol ReachabilityServiceProtocol {
    func isReachable(completion: @escaping (Bool) -> Void)
}

class DefaultReachabilityService: ReachabilityServiceProtocol {
    
    func isReachable(completion: @escaping (Bool) -> Void) {
        var request = URLRequest(url: URL(string: "https://www.google.com")!)
        request.timeoutInterval = 5.0
        URLSession.shared.dataTask(with: request) { (_, response, _) in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }.resume()
    }
}
