//
//  MovieDetailsViewModel.swift
//  banquemisr.challenge05.*
//
//  Created by Sarah on 30/09/2024.
//

import Foundation

protocol MovieDetailsProtocol {
    func getMovieDetails()
}

class MovieDetailsViewModel: MovieDetailsProtocol {
    var networkManager: NetworkProtocol?
    var apiManager: APIManagerProtocol?
    var bindToViewController: (() -> Void) = {}
    var movie: MovieDetails? {
        didSet {
            bindToViewController()
        }
    }
    var movieID: Int
    
    
    init(movieID: Int) {
        networkManager = NetworkManager()
        apiManager = APIManager()
        self.movieID = movieID
    }
    
    func getMovieDetails() {
        let url = apiManager?.getUrl(for: .movieDetails(movieId: movieID))
        networkManager?.fetch(url: url ?? "", type: MovieDetails.self, completion: { [weak self] result, error in
            guard let result = result else {
                return
            }
            self?.movie = result.self
        })
    }
    
}
