//
//  MoviesViewViewModel.swift
//  MovieApp
//
//  Created by Zvonimir Pavlović on 04/01/2020.
//  Copyright © 2020 Zvonimir Pavlović. All rights reserved.
//

import Foundation

protocol MoviesViewModelDelegate: class {
    func reloadCollectionView()
    func reloadItem(index: Int)
}

class MoviesViewViewModel {
    
    let localDatabase = LocalDatabase()
    let dataService = DataService()
    var moviesViewModel : [MovieViewModel] = []
    weak var delegate: MoviesViewModelDelegate?
    
    func getMovies(tab: Int){
        switch tab {
        case 0..<2:
            getOnlineMovies(tab: tab)
        default:
            getFavoriteMovies()
        }
    }
    
    func getOnlineMovies(tab: Int) {
        var query: String = "popular"
        switch tab {
        case 0:
            query = "popular"
        case 1:
            query = "top_rated"
        default:
            query = "popular"
        }
        dataService.fetchMovies(key: query, completion: {[weak self] result,error in
            guard let welf = self else { return }
            guard let res = result else { return }
            for movie in res{
                guard let currentMovie = Movie(json: movie) else { return }
                let movieViewModel = MovieViewModel(movie: currentMovie)
                let isFavorite = welf.localDatabase.checkIsFavorite(movie: movieViewModel)
                if isFavorite == true {
                    movieViewModel.isFavorite = true
                }
                welf.moviesViewModel.append(movieViewModel)
            }
            welf.delegate?.reloadCollectionView()
            
//            guard let welf = self else { return }
//            if result != nil {
//                guard let res = result else { return }
//                for movie in res{
//                    guard let currentMovie = Movie(json: movie) else { return }
//                    let movieViewModel = MovieViewModel(movie: currentMovie)
//                    let isFavorite = welf.localDatabase.checkIsFavorite(movie: movieViewModel)
//                    if isFavorite == true {
//                        movieViewModel.isFavorite = true
//                    }
//                    welf.moviesViewModel.append(movieViewModel)
//                }
//                welf.delegate?.reloadCollectionView()
//            }
//            if error == .failure {
//                print("Network error")
//            }
            
        })
    }
    
    func compareFavorites(){
        var favoriteMovies: [MovieViewModel] = []
        favoriteMovies = localDatabase.getFavoriteMovies()
        for movie in moviesViewModel {
            if movie.isFavorite == true {
                if !favoriteMovies.contains(movie) {
                    guard let index = moviesViewModel.firstIndex(of: movie) else { return }
                    moviesViewModel[index].isFavorite = false
                    delegate?.reloadItem(index: index)
                }
            }
        }
    }
    
    func getFavoriteMovies() {
        let newFavoriteMovies = localDatabase.getFavoriteMovies()
        if(moviesViewModel != newFavoriteMovies){
            moviesViewModel = localDatabase.getFavoriteMovies()
            delegate?.reloadCollectionView()
        }
    }
    
    func addFavorite(index: Int){
        moviesViewModel[index].isFavorite = true
        localDatabase.insertFavoriteMovie(movie: moviesViewModel[index])
        delegate?.reloadItem(index: index)
    }
    
    func removeFavorite(index: Int){
        moviesViewModel[index].isFavorite = false
        localDatabase.removeFavoriteMovie(movie: moviesViewModel[index])
        delegate?.reloadItem(index: index)
    }
}
