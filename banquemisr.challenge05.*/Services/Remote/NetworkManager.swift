//
//  NetworkManager.swift
//  banquemisr.challenge05.*
//
//  Created by Sarah on 30/09/2024.
//

import Foundation

protocol NetworkProtocol {
    func fetch<T: Codable> (url: String, type: T.Type, completion: @escaping (T?, Error?) -> Void)
}


class NetworkManager: NetworkProtocol {
    
    private let session: URLSession
       
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetch<T: Codable> (url: String, type: T.Type, completion: @escaping (T?, Error?) -> Void) {
        
        guard let url = URL(string: url) else {
            completion(nil, NetworkError.invalidURL)
            return
        }
        print("Fetching data from URL: \(url)")
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, NetworkError.other(error))
                return
            }
            guard let data = data else {
                completion(nil, NetworkError.noData)
                return
            }
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                completion(nil, NetworkError.httpError(httpResponse.statusCode))
                return
            }
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(result, nil)
            } catch {
                completion(nil, NetworkError.decodingError(error.localizedDescription))
            }
        }
        task.resume()
    }
}

