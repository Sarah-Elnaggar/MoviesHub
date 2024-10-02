//
//  MovieDetails.swift
//  banquemisr.challenge05.*
//
//  Created by Sarah on 30/09/2024.
//

import Foundation

struct MovieDetails: Codable {
    var id: Int?
    var title: String?
    var overview: String?
    var genres: [Genre]?
    var runtime: Int?
    var poster_path: String?
    var backdrop_path: String?
    var release_date: String?
    var vote_average: Double?
}

struct Genre: Codable {
    var id: Int?
    var name: String?
}
