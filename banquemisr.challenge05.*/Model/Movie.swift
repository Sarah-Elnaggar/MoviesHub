//
//  Movie.swift
//  banquemisr.challenge05.*
//
//  Created by Sarah on 30/09/2024.
//

import Foundation

struct MovieResponse: Codable {
    var page: Int
    var results: [Movie]
    var total_pages: Int
    var total_results: Int
}

struct Movie: Codable {
    let adult: Bool
    let backdrop_path: String?
    let genre_ids: [Int]
    let id: Int
    let original_language: String
    let original_title: String
    let overview: String
    let popularity: Double
    let poster_path: String?
    let release_date: String
    let title: String
    let video: Bool
    let vote_average: Double
    let vote_count: Int
    
}
