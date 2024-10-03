//
//  MockCoreDataManager.swift
//  banquemisr.challenge05.*Tests
//
//  Created by Sarah on 02/10/2024.
//

import XCTest
import CoreData
@testable import banquemisr_challenge05__


class MockCoreDataManager: CoreDataManagerProtocol {
    
    var storedMovies: [Movie] = []
    
    func setContext(_ context: NSManagedObjectContext) { }
    
    func storeMovieInList(movie: Movie, movieType: String) {
        storedMovies.append(movie)
    }
    
    func getMoviesList(movieType: String, completion: @escaping (Result<[NSManagedObject], Error>) -> Void) {
        if storedMovies.isEmpty {
            completion(.failure(NSError(domain: "CoreDataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No movies found"])))
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "StoredMovie", in: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))!
            let result: [NSManagedObject] = storedMovies.map { movie in
                let mockObject = NSManagedObject(entity: entity, insertInto: nil)
                mockObject.setValue(movie.id, forKey: "id")
                mockObject.setValue(movie.title, forKey: "title")
                mockObject.setValue(movie.poster_path, forKey: "poster_path")
                mockObject.setValue(movie.release_date, forKey: "release_date")
                return mockObject
            }
            completion(.success(result))
        }
    }
    
    func storeMovieDetails(movie: MovieDetails) {}
    func getMovieDetails(movieID: Int, completion: @escaping (Result<[NSManagedObject], Error>) -> Void) {}
    func deleteAllMovies(movieType: String) {
        storedMovies.removeAll()
    }
}
