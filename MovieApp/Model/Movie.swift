//
//  Movie.swift
//  MovieApp
//
//  Created by Zvonimir Pavlović on 04/01/2020.
//  Copyright © 2020 Zvonimir Pavlović. All rights reserved.
//

import Foundation
import SwiftyJSON
import SQLite

class Movie{
  
  let id: Int
  let poster_path: String?
  let original_title: String?
  let vote_average: Double?
  let overview: String?
    
    init?(json: JSON){
    guard let id = json["id"].int else { return nil }
    let title = json["original_title"].string
    let vote_average = json["vote_average"].double
    let overview = json["overview"].string
    let poster = json["poster_path"].string
    self.id = id
    self.poster_path = poster
    self.original_title = title
    self.vote_average = vote_average
    self.overview = overview
    }
    
    init(id: Int,path: String, title: String, vote: Double, overview: String) {
        self.id = id
        self.poster_path = path
        self.original_title = title
        self.vote_average = vote
        self.overview = overview
    }
}
