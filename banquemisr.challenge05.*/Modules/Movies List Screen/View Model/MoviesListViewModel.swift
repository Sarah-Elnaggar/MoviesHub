//
//  MoviesListViewModel.swift
//  banquemisr.challenge05.*
//
//  Created by Sarah on 30/09/2024.
//

import Foundation
import CoreData
import Network


class MoviesListViewModel {
    var networkManager: NetworkProtocol?
    var apiManager: APIManagerProtocol?
    var screenType: EndPoint?
    var movieType: String?
    var coreDataManager: CoreDataManagerProtocol?
    var bindResultToViewController: (() -> Void) = {}
    var bindErrorToViewController: ((String) -> Void)?
    var movies: [Movie]? = [] {
        didSet {
            bindResultToViewController()
        }
    }
    
    private let monitor = NWPathMonitor()
    private var isConnected: Bool = false
    private let queue = DispatchQueue.global(qos: .background)
    private var reachabilityService: ReachabilityServiceProtocol
    
    init(screenType: EndPoint?, networkManager: NetworkProtocol = NetworkManager(), apiManager: APIManagerProtocol = APIManager(), coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared, reachabilityService: ReachabilityServiceProtocol = DefaultReachabilityService()) {
        self.networkManager = networkManager
        self.apiManager = apiManager
        self.screenType = screenType
        self.coreDataManager = coreDataManager
        self.reachabilityService = reachabilityService
        
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = (path.status == .satisfied)
        }
        monitor.start(queue: queue)
    }
           
    func getMoviesList() {
        print("Is connected to the internet: \(isConnected)")
        
        if isConnected {
            getMoviesListFromAPI()
        } else {
            // Perform additional reachability check
            reachabilityService.isReachable { [weak self] reachable in
                DispatchQueue.main.async {
                    if reachable {
                        self?.getMoviesListFromAPI()
                    } else {
                        self?.getMoviesListFromCoreData()
                    }
                }
            }
        }
    }
    
    private func getMoviesListFromAPI() {
        guard let url = apiManager?.getUrl(for: screenType ?? .nowPlaying) else {
            bindErrorToViewController?("Invalid URL.")
            return
        }
        networkManager?.fetch(url: url, type: MovieResponse.self, completion: { [weak self] result, error in
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
            
            self?.movies = result.results
            self?.bindResultToViewController()
            DispatchQueue.main.async {
                CoreDataManager.shared.deleteAllMovies(movieType: self?.movieType ?? "")
            }
            if let fetchedMovies = result.results {
                DispatchQueue.main.async {
                    self?.storeMoviesToCoreData(movies: fetchedMovies)
                }
            }
        })
    }
    
    private func getMoviesListFromCoreData() {
        DispatchQueue.main.async { [self] in
            coreDataManager?.getMoviesList(movieType: self.movieType ?? "") { [weak self] result in
                switch result {
                case .success(let storedMovies):
                    if storedMovies == [] {
                        print("Movies List not found in Core Data.")
                        self?.bindErrorToViewController?("No Connection ! !\n Movies List not found in Core Data.")
                    }
                    self?.movies = storedMovies.map { movie in
                        var mov = Movie()
                        mov.id = movie.value(forKey: "id") as? Int
                        mov.title = movie.value(forKey: "title") as? String
                        mov.poster_path = movie.value(forKey: "poster_path") as? String
                        mov.release_date = movie.value(forKey: "release_date") as? String
                        return mov
                    }
                    self?.bindResultToViewController()
                    
                case .failure(let error):
                    print("Failed to fetch movies from Core Data: \(error.localizedDescription)")
                    self?.bindErrorToViewController?("No Connection ! ! \n Failed to fetch movies from Core Data: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func storeMoviesToCoreData(movies: [Movie]) {
        DispatchQueue.main.async {
            for movie in movies {
                self.coreDataManager?.storeMovieInList(movie: movie, movieType: self.movieType ?? "")
            }
        }
    }
}

