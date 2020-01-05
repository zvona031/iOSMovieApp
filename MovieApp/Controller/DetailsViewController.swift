//
//  DetailsViewController.swift
//  MovieApp
//
//  Created by Zvonimir Pavlović on 04/01/2020.
//  Copyright © 2020 Zvonimir Pavlović. All rights reserved.
//

import UIKit
import Cosmos
import YoutubePlayer_in_WKWebView

protocol DetailsMovieViewDelegate: class {
    func favoriteChanged(movie: MovieViewModel)
}

class DetailsViewController: UIViewController,DetailsViewModelDelegate {
    
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var youtubePlayer: WKYTPlayerView!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var favoriteImage: UIBarButtonItem!
    
    var detailsViewViewModel: DetailsViewViewModel = DetailsViewViewModel()
    weak var delegate: DetailsMovieViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setMovieDetails()
        setFavoriteImage()
        setFavoriteImageAction()
        detailsViewViewModel.delegate = self
        detailsViewViewModel.getTrailer()
    }
    
    func setMovieDetails(){
        guard let currentMovie = detailsViewViewModel.movieViewModel else { return }
        // Setting movie star rating
        cosmosView.settings.updateOnTouch = false
        cosmosView.settings.fillMode = .precise
        cosmosView.rating = currentMovie.vote_average / 2
        cosmosView.text = String(currentMovie.vote_average/2)
        // Setting overview label
        overview.text = currentMovie.overview
    }
    
    func setFavoriteImage(){
        // Setting favorite image
        if detailsViewViewModel.movieViewModel?.isFavorite == true{
            DispatchQueue.main.async {
                self.favoriteImage.image = UIImage(named: "heart-filled")
            }
        }
        else {
            DispatchQueue.main.async {
                self.favoriteImage.image = UIImage(named: "heart-empty")
            }
        }
    }
    
    func setFavoriteImageAction(){
        favoriteImage.target = self
        favoriteImage.action = #selector(onFavoriteClick)
    }
    
    @objc func onFavoriteClick(){
        detailsViewViewModel.favoriteImageClicked()
        guard let movie = detailsViewViewModel.movieViewModel else { return }
        delegate?.favoriteChanged(movie: movie)
    }
    
    func setTrailer(key: String) {
        youtubePlayer.load(withVideoId: key)
    }
    
    func favoriteAdded() {
        DispatchQueue.main.async {
            self.favoriteImage.image = UIImage(named: "heart-filled")
        }
    }
    
    func favoriteRemoved() {
        DispatchQueue.main.async {
            self.favoriteImage.image = UIImage(named: "heart-empty")
        }
    }
}
