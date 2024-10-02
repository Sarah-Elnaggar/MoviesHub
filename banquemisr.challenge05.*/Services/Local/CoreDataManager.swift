//
//  CoreDataManager.swift
//  banquemisr.challenge05.*
//
//  Created by Sarah on 01/10/2024.
//

import Foundation
import UIKit
import CoreData

protocol CoreDataManagerProtocol {
    func setContext(_ context: NSManagedObjectContext)
    func storeMovieInList(movie: Movie ,movieType: String)
    func getMoviesList(movieType: String,completion: @escaping (Result<[NSManagedObject], Error>) -> Void)
    func storeMovieDetails(movie: MovieDetails)
    func getMovieDetails(movieID: Int, completion: @escaping (Result<[NSManagedObject], Error>) -> Void) 
    func deleteAllMovies(movieType: String)
}


class CoreDataManager: CoreDataManagerProtocol {
    
    var context : NSManagedObjectContext!
    static let shared = CoreDataManager()
    
    
    private init() {
        self.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    
    func setContext(_ context: NSManagedObjectContext) {
        self.context = context
    }
    
    
    func storeMovieInList(movie: Movie ,movieType: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: "StoredMovie", in: self.context) else { return }
        let storedMovie = NSManagedObject(entity: entity, insertInto: self.context)
        
        storedMovie.setValue(movieType, forKey: "type")
        storedMovie.setValue(movie.id, forKey: "id")
        storedMovie.setValue(movie.title, forKey: "title")
        storedMovie.setValue(movie.poster_path, forKey: "poster_path")
        storedMovie.setValue(movie.release_date, forKey: "release_date")
        
        do {
            try self.context.save()
            print("Movie Saved Successfully!!")
        } catch let error {
            print("Failed to save")
            print(error.localizedDescription)
        }
    }
    
    
    func getMoviesList(movieType: String, completion: @escaping (Result<[NSManagedObject], Error>) -> Void) {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "StoredMovie")
        fetchRequest.predicate = NSPredicate(format: "type == %@", movieType)
        
        do {
            let storedMovies = try self.context.fetch(fetchRequest)
            if storedMovies.isEmpty {
                print("No data found")
            }
            completion(.success(storedMovies))
            print("Fetched from CoreData")
        } catch let error {
            print("Failed to fetch")
            print(error.localizedDescription)
            completion(.failure(error))
        }
    }
    
    
    func storeMovieDetails(movie: MovieDetails) {
        
        deleteOneMovie(movieID: movie.id ?? 0)
        
        guard let entity = NSEntityDescription.entity(forEntityName: "StoredMovieDetails", in: self.context) else { return }
        let storedMovie = NSManagedObject(entity: entity, insertInto: self.context)
        
        storedMovie.setValue(movie.id, forKey: "id")
        storedMovie.setValue(movie.title, forKey: "title")
        storedMovie.setValue(movie.overview, forKey: "overview")
        storedMovie.setValue(movie.runtime, forKey: "runtime")
        storedMovie.setValue(movie.poster_path, forKey: "poster_path")
        storedMovie.setValue(movie.backdrop_path, forKey: "backdrop_path")
        storedMovie.setValue(movie.release_date, forKey: "release_date")
        storedMovie.setValue(movie.vote_average, forKey: "vote_average")
        
        let genreNames = movie.genres?.compactMap { $0.name }.joined(separator: " | ")
        storedMovie.setValue(genreNames, forKey: "genres")
        
        do {
            try self.context.save()
            print("Movie Details Saved Successfully!!")
        } catch let error {
            print("Failed to save")
            print(error.localizedDescription)
        }
    }
    
    
    func getMovieDetails(movieID: Int, completion: @escaping (Result<[NSManagedObject], Error>) -> Void) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "StoredMovieDetails")
        fetchRequest.predicate = NSPredicate(format: "id == %d", movieID)
        fetchRequest.fetchLimit = 1
        
        do {
            let storedMovie = try self.context.fetch(fetchRequest)
            if storedMovie.isEmpty {
                print("No data found")
            }
            completion(.success(storedMovie))
            print("Fetched from CoreData")
        } catch let error {
            print("Failed to fetch")
            print(error.localizedDescription)
            completion(.failure(error))
        }
    }
    
    
    func deleteAllMovies(movieType: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StoredMovie")
        fetchRequest.predicate = NSPredicate(format: "type == %@", movieType)
        do {
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            for item in result {
                context.delete(item)
            }
            try context.save()
            print("All movies deleted successfully")
        } catch {
            print("Failed to delete movies")
            print(error.localizedDescription)
        }
    }
    
    
    private func deleteOneMovie(movieID: Int) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "StoredMovieDetails")
        fetchRequest.predicate = NSPredicate(format: "id == %d", movieID)
        do {
            let result = try context.fetch(fetchRequest) 
            for item in result {
                context.delete(item)
            }
            try context.save()
            print("A movie deleted successfully")
        } catch {
            print("Failed to delete a movie")
            print(error.localizedDescription)
        }
    }
    
    
}
