//
//  MoviesListViewModel.swift
//  banquemisr.challenge05.*
//
//  Created by Sarah on 30/09/2024.
//

import Foundation

protocol MoviesListProtocol {
    func getMoviesList()
}

class MoviesListViewModel: MoviesListProtocol {
    var networkManager: NetworkProtocol?
    var apiManager: APIManagerProtocol?
    var screenType: EndPoint?
    var bindToViewController: (() -> Void) = {}
    var movies: [Movie]? = [] {
        didSet {
            bindToViewController()
        }
    }
    
    init(screenType: EndPoint?) {
        networkManager = NetworkManager()
        apiManager = APIManager()
        self.screenType = screenType
    }
    
    func getMoviesList() {
        let url = apiManager?.getUrl(for: screenType ?? .nowPlaying)
        networkManager?.fetch(url: url ?? "", type: MovieResponse.self, completion: { [weak self] result, error in
            guard let result = result else {
                return
            }
            self?.movies = result.results
        })
    }
}

