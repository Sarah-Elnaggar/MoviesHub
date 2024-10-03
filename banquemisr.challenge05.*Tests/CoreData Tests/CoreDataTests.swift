//
//  CoreDataTests.swift
//  banquemisr.challenge05.*Tests
//
//  Created by Sarah on 02/10/2024.
//

import XCTest
import CoreData
@testable import banquemisr_challenge05__

final class CoreDataTests: XCTestCase {

    var coreDataManager: CoreDataManager!
       var mockContext: NSManagedObjectContext!

       override func setUp() {
           super.setUp()
           
           coreDataManager = CoreDataManager.shared
           
           let persistentContainer = NSPersistentContainer(name: "banquemisr_challenge05__")
           let description = NSPersistentStoreDescription()
           description.type = NSInMemoryStoreType
           persistentContainer.persistentStoreDescriptions = [description]
           persistentContainer.loadPersistentStores { (description, error) in
               XCTAssertNil(error)
           }
           mockContext = persistentContainer.viewContext
           
           coreDataManager.setContext(mockContext)
       }

       override func tearDown() {
           super.tearDown()
           coreDataManager = nil
           mockContext = nil
       }
    
    func testStoreMovieInList() {
        let movie = Movie(id: 123, poster_path: "poster.png", release_date: "2024-01-01", title: "Test Movie")
        coreDataManager.storeMovieInList(movie: movie, movieType: "Popular")
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "StoredMovie")
        let movies = try? mockContext.fetch(fetchRequest)
        
        XCTAssertEqual(movies?.count, 1, "Movie count should be 1")
        
        let storedMovie = movies?.first
        XCTAssertEqual(storedMovie?.value(forKey: "id") as? Int, 123)
        XCTAssertEqual(storedMovie?.value(forKey: "title") as? String, "Test Movie")
        XCTAssertEqual(storedMovie?.value(forKey: "type") as? String, "Popular")
    }

    func testGetMoviesList() {
        let movie = Movie(id: 123, poster_path: "poster.png", release_date: "2024-01-01", title: "Test Movie")
        coreDataManager.storeMovieInList(movie: movie, movieType: "Favorites")
        
        let expectation = self.expectation(description: "Completion handler invoked")
        
        coreDataManager.getMoviesList(movieType: "Favorites") { result in
            switch result {
            case .success(let movies):
                XCTAssertEqual(movies.count, 1, "There should be 1 movie in the list")
            case .failure:
                XCTFail("Fetch should not fail")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testDeleteAllMovies() {
        let movie = Movie(id: 123, poster_path: "poster.png", release_date: "2024-01-01", title: "Test Movie")
        coreDataManager.storeMovieInList(movie: movie, movieType: "Favorites")
        
        coreDataManager.deleteAllMovies(movieType: "Favorites")
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "StoredMovie")
        fetchRequest.predicate = NSPredicate(format: "type == %@", "Favorites")
        let movies = try? mockContext.fetch(fetchRequest)
        
        XCTAssertEqual(movies?.count, 0, "All movies should be deleted")
    }


    func testStoreMovieDetails() {
        let movieDetails = MovieDetails(id: 123, title: "Test Movie", overview: "This is a test", genres: [Genre(name: "Action")], runtime: 120, poster_path: "poster.png", backdrop_path: "backdrop.png", release_date: "2024-01-01", vote_average: 8.0)
        
        coreDataManager.storeMovieDetails(movie: movieDetails)
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "StoredMovieDetails")
        let details = try? mockContext.fetch(fetchRequest)
        
        XCTAssertEqual(details?.count, 1, "There should be 1 stored movie details")
        XCTAssertEqual(details?.first?.value(forKey: "id") as? Int, 123)
        XCTAssertEqual(details?.first?.value(forKey: "title") as? String, "Test Movie")
        XCTAssertEqual(details?.first?.value(forKey: "genres") as? String, "Action")
    }
    
    func testGetMovieDetails() {
        let movieDetails = MovieDetails(id: 123, title: "Test Movie", overview: "This is a test", genres: [Genre(name: "Action")], runtime: 120, poster_path: "poster.png", backdrop_path: "backdrop.png", release_date: "2024-01-01", vote_average: 8.0)
        coreDataManager.storeMovieDetails(movie: movieDetails)
        
        let expectation = self.expectation(description: "Completion handler invoked")
        
        coreDataManager.getMovieDetails(movieID: 123) { result in
            switch result {
            case .success(let details):
                XCTAssertEqual(details.count, 1, "There should be 1 stored movie detail")
            case .failure:
                XCTFail("Fetch should not fail")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }


}
