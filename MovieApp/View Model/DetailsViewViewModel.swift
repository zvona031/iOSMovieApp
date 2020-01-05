//
//  DetailsViewViewModel.swift
//  MovieApp
//
//  Created by Zvonimir Pavlović on 04/01/2020.
//  Copyright © 2020 Zvonimir Pavlović. All rights reserved.
//

import Foundation

protocol DetailsViewModelDelegate: class {
    func setTrailer(key: String)
    func favoriteAdded()
    func favoriteRemoved()
}

class DetailsViewViewModel {
    
    let dataService = DataService()
    let localDatabase = LocalDatabase()
    var movieViewModel: MovieViewModel?
    var movieTrailer: String?
    weak var delegate: DetailsViewModelDelegate?
    
    func getTrailer(){
        guard let movieId = movieViewModel?.id else  { return }
        dataService.fetchTrailer(id: movieId, completion: {[weak self] result,error in
            guard let welf = self else { return }
            guard let res = result else { return }
            guard let key = res[0]["key"].string else {return}
            welf.delegate?.setTrailer(key: key)
        })
    }
    
    func favoriteImageClicked(){
        guard let currentMovie = movieViewModel else { return }
        if movieViewModel?.isFavorite == true{
            localDatabase.removeFavoriteMovie(movie: currentMovie)
            movieViewModel?.isFavorite = false
            delegate?.favoriteRemoved()
        }
        else {
            localDatabase.insertFavoriteMovie(movie: currentMovie)
            movieViewModel?.isFavorite = true
            delegate?.favoriteAdded()
        }
    }
}
