//
//  MovieDetailsViewModel.swift
//  banquemisr.challenge05.*
//
//  Created by Sarah on 30/09/2024.
//

import Foundation
import CoreData
import Network


class MovieDetailsViewModel {
    var networkManager: NetworkProtocol?
    var apiManager: APIManagerProtocol?
    var coreDataManager: CoreDataManagerProtocol?
    var bindResultToViewController: (() -> Void) = {}
    var bindErrorToViewController: ((String) -> ())?
    var movie: MovieDetails? {
        didSet {
            bindResultToViewController()
        }
    }
    var movieID: Int
    
    private let monitor = NWPathMonitor()
    private var isConnected: Bool = false
    private let queue = DispatchQueue.global(qos: .background)
    private var reachabilityService: ReachabilityServiceProtocol
    
    init(movieID: Int, networkManager: NetworkProtocol = NetworkManager(), apiManager: APIManagerProtocol = APIManager(), coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared, reachabilityService: ReachabilityServiceProtocol = DefaultReachabilityService()) {
        self.networkManager = networkManager
        self.apiManager = apiManager
        self.coreDataManager = coreDataManager
        self.reachabilityService = reachabilityService
        self.movieID = movieID
        
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = (path.status == .satisfied)
        }
        monitor.start(queue: queue)
    }
    
    
    func getMovieDetails() {
        print("Is connected to the internet: \(isConnected)")
        
        if isConnected {
            getMovieDetailsFromAPI()
        } else {
            // Perform additional reachability check
            reachabilityService.isReachable { [weak self] reachable in
                DispatchQueue.main.async {
                    if reachable {
                        self?.getMovieDetailsFromAPI()
                    } else {
                        self?.getMovieDetailsFromCoreData()
                    }
                }
            }
        }
    }
        
    
    private func getMovieDetailsFromAPI() {
        guard let url = apiManager?.getUrl(for: .movieDetails(movieId: movieID)) else {
            bindErrorToViewController?("Invalid URL.")
            return
        }
        networkManager?.fetch(url: url, type: MovieDetails.self, completion: { [weak self] result, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                self?.bindErrorToViewController?("Network error: \(error.localizedDescription)")
                return
            }
                        
            guard let result = result else {
                print("No result returned from the API")
                self?.bindErrorToViewController?("No result returned from the API.")
                return
            }
            self?.movie = result
            DispatchQueue.main.async {
                self?.storeMovieDetailsToCoreData(movie: result)
            }
        })
    }
    
    
    private func getMovieDetailsFromCoreData() {
        CoreDataManager.shared.getMovieDetails(movieID: movieID) { [weak self] result in
            switch result {
            case .success(let storedMovie):
                guard let movieDetails = storedMovie.first else {
                    print("Movie not found in Core Data.")
                    self?.bindErrorToViewController?("No Connection ! !\n Movie not found in Core Data.")
                    return
                }
                var moviedetails = MovieDetails()
                moviedetails.id = movieDetails.value(forKey: "id") as? Int
                moviedetails.title = movieDetails.value(forKey: "title") as? String
                moviedetails.overview = movieDetails.value(forKey: "overview") as? String
                moviedetails.runtime = movieDetails.value(forKey: "runtime") as? Int
                moviedetails.poster_path = movieDetails.value(forKey: "poster_path") as? String
                moviedetails.backdrop_path = movieDetails.value(forKey: "backdrop_path") as? String
                moviedetails.release_date = movieDetails.value(forKey: "release_date") as? String
                moviedetails.vote_average = movieDetails.value(forKey: "vote_average") as? Double
                
                if let genresString = movieDetails.value(forKey: "genres") as? String {
                    let genreNames = genresString.components(separatedBy: " | ")
                    moviedetails.genres = genreNames.map { Genre(name: $0) }
                }
                
                self?.movie = moviedetails
                self?.bindResultToViewController()
                
            case .failure(let error):
                print("Failed to fetch movie details from Core Data: \(error.localizedDescription)")
                self?.bindErrorToViewController?("No Connection ! ! \n Failed to fetch movie details from Core Data: \(error.localizedDescription)")
            }
        }
    }
                                               
    
    private func storeMovieDetailsToCoreData(movie: MovieDetails) {
        CoreDataManager.shared.storeMovieDetails(movie: movie)
    }
   
}
