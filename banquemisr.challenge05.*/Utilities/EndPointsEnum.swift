//
//  EndPointsEnum.swift
//  banquemisr.challenge05.*
//
//  Created by Sarah on 30/09/2024.
//

import Foundation

enum EndPoint: Any {
    case nowPlaying
    case upcoming
    case popular
    case movieDetails(movieId: Int)
    
    var path: String {
        switch self {
        case .nowPlaying:
            return "now_playing"
        case .upcoming:
            return "upcoming"
        case .popular:
            return "popular"
        case .movieDetails(let movieId):
            return "\(movieId)"
        }
    }
}
