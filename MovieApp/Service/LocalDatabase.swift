//
//  LocalDatabase.swift
//  MovieApp
//
//  Created by Zvonimir Pavlović on 04/01/2020.
//  Copyright © 2020 Zvonimir Pavlović. All rights reserved.
//

import Foundation
import SQLite

class LocalDatabase {
    
    let id = Expression<String>("id")
    let posterPath = Expression<String>("poster_path")
    let originalTitle = Expression<String>("original_title")
    let voteAverage = Expression<Double>("vote_average")
    let overview = Expression<String>("overview")
    let isFavorite = Expression<Bool>("isFavotite")
    let movies = Table("movies")
    let db: Connection = {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return try! Connection("\(path)/movie.sqlite")
    }()
    
    init() {
        createTable()
    }
    
    func createTable(){
        do{
            try db.run(movies.create(ifNotExists: true) { t in
        t.column(id,primaryKey: true)
        t.column(posterPath)
        t.column(originalTitle)
        t.column(voteAverage)
        t.column(overview)
        t.column(isFavorite)
        })}
        catch{
            print("Error creating table")
        }
    }
    
    func getFavoriteMovies() -> Array<MovieViewModel>{
        var favoriteMovies = [MovieViewModel]()
        do{
            let movieRows = Array(try db.prepare(movies))
            for movie in movieRows {
                let current = Movie(id: Int(movie[id])!, path: movie[posterPath], title: movie[originalTitle], vote: movie[voteAverage], overview: movie[overview])
                favoriteMovies.append(MovieViewModel(movie: current, isFavorite: true))
            }
        }
        catch{
            print("Error ")
        }
        return favoriteMovies
    }
    
    func insertFavoriteMovie(movie: MovieViewModel){
        do{
            try db.run(movies.insert(or: .replace,id <- movie.id, posterPath <- movie.poster_path, originalTitle <- movie.original_title, voteAverage <- movie.vote_average, overview <- movie.overview, isFavorite <- true))}catch{
            print("Error inserting movie in table")
        }
    }
    
    func removeFavoriteMovie(movie: MovieViewModel){
        do{
            let currentMovie = movies.filter(id == movie.id)
            try db.run(currentMovie.delete())
        } catch{
            print("Error removing movie in table")
        }
    }
    
    func checkIsFavorite(movie: MovieViewModel) -> Bool {
        // Provjerava sadrzi li lokalna baza film poslan u funkciji.......ovo moram pojednostavniti!!!!
        var isFavorite = false
        var favoriteMovies = [MovieViewModel]()
        do{
            let movieRows = Array(try db.prepare(movies))
            for row in movieRows {
                let current = Movie(id: Int(row[id])!, path: row[posterPath], title: row[originalTitle], vote: row[voteAverage], overview: row[overview])
                if current.id == Int(movie.id) {
                    favoriteMovies.append(MovieViewModel(movie: current))
                }
            }
            if favoriteMovies.count != 0{
                isFavorite = true
            }
        }
        catch{
            print("Error ")
        }
        return isFavorite
        }
}

