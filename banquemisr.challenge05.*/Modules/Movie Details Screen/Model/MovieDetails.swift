//
//  MovieDetails.swift
//  banquemisr.challenge05.*
//
//  Created by Sarah on 30/09/2024.
//

import Foundation

struct MovieDetails: Codable {
    let id: Int?
    let title: String?
    let overview: String?
    let genres: [Genre]?
    let runtime: Int?
    let poster_path: String?
    let backdrop_path: String?
    let release_date: String?
    let vote_average: Double?
}

struct Genre: Codable {
    let id: Int?
    let name: String?
}
