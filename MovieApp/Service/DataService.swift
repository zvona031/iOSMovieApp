//
//  DataService.swift
//  MovieApp
//
//  Created by Zvonimir Pavlović on 04/01/2020.
//  Copyright © 2020 Zvonimir Pavlović. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class DataService {
    
    private let  baseUrl = "https://api.themoviedb.org/3/movie"
    
    enum NetworkError: Error {
        case failure
        case success
    }
    
    func fetchMovies(key: String,completion: @escaping ([JSON]?, NetworkError) -> ()) {
        let requestUrl = "\(baseUrl)/\(key)?api_key=99460c4f7bd0cd6322c499e1c5d99677"
        Alamofire.request(requestUrl).validate().responseJSON{
            response in
            switch response.result {
            case .success:
                guard let data = response.data else {
                    completion(nil, .failure)
                    return
                }
                let json = try? JSON(data: data)
                let results = json?["results"].arrayValue  // JSON tip varijable popunjen filmovima
                guard let empty = results?.isEmpty, !empty else {
                    completion(nil, .failure)
                    return
                }
                var array: [Movie] = [] // Array tip varijable popunjen filmovima
                results?.forEach{ movie in array.append(Movie(json: movie)!)}
                completion(results, .success)  // ako tu želim poslati array tip, moram promjeniti gore u parametru funkcije tip iz [JSON] u [Movie]
                
            case .failure:
                completion(nil, .failure)
            }
        }
    }
    
    func fetchTrailer(id: String,completion: @escaping ([JSON]?, NetworkError) -> ()) {
        let requestUrl = "\(baseUrl)/\(id)/videos?api_key=99460c4f7bd0cd6322c499e1c5d99677"
        Alamofire.request(requestUrl).validate().responseJSON{
            response in
            switch response.result {
            case .success:
                guard let data = response.data else {
                    print("data = nil")
                    completion(nil, .failure)
                    return
                }
                let json = try? JSON(data: data)
                let results = json?["results"].arrayValue  // JSON tip varijable popunjen filmovima
                guard let empty = results?.isEmpty, !empty else {
                    print("results is empty")
                    completion(nil, .failure)
                    return
                }
                completion(results, .success)
            case .failure:
                print("failure")
                completion(nil, .failure)
            }
        }
    }
}
