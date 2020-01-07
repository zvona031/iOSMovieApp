//
//  MovieViewModel.swift
//  MovieApp
//
//  Created by Zvonimir Pavlović on 04/01/2020.
//  Copyright © 2020 Zvonimir Pavlović. All rights reserved.
//

import Foundation

class MovieViewModel: Equatable {

    let movie: Movie
    var isFavorite: Bool
    
    init(movie: Movie){
        self.movie = movie
        self.isFavorite = false
    }
    init(movie: Movie, isFavorite: Bool){
        self.movie = movie
        self.isFavorite = isFavorite
    }
    
    var poster_path: String {
        return movie.poster_path ?? "nil"
    }
    var original_title: String {
        return movie.original_title ?? "No original title"
    }
    var overview: String {
        return movie.overview ?? "No overview"
    }
    var vote_average: Double {
        return movie.vote_average ?? 0
    }
    var id: String {
        return String(movie.id)
    }

    static func == (lhs: MovieViewModel, rhs: MovieViewModel) -> Bool {
        return lhs.id == rhs.id
    }
}
