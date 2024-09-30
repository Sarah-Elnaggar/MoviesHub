//
//  APIManager.swift
//  banquemisr.challenge05.*
//
//  Created by Sarah on 30/09/2024.
//

import Foundation

protocol APIManagerProtocol {
    func getUrl(for endpoint: EndPoint) -> String
}


class APIManager: APIManagerProtocol {
    
    private let baseURL = "https://api.themoviedb.org/3/movie/"
    private let apiKey = "6974796546c7f41cece685a979189536"
    

    func getUrl(for endpoint: EndPoint) -> String {
        
        let path =  endpoint.path
        let url = "\(baseURL)\(path)?api_key=\(apiKey)"
        
        return url
    }
}
