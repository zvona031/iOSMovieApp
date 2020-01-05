//
//  MovieCell.swift
//  MovieApp
//
//  Created by Zvonimir Pavlović on 04/01/2020.
//  Copyright © 2020 Zvonimir Pavlović. All rights reserved.
//

import UIKit

protocol MovieCellDelegate: class{
    func favoriteClicked(_ sender: MovieCell)
}

class MovieCell : UICollectionViewCell {
    
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var favoriteImage: UIImageView!
    weak var delegate: MovieCellDelegate?
    var viewModel: MovieViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    private func bindViewModel() {
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onFavoriteClick))
        favoriteImage.isUserInteractionEnabled = true
        favoriteImage.addGestureRecognizer(imageTapRecognizer)
        // Setting movie poster
        guard let path = self.viewModel?.poster_path else {return}
        guard let URL = URL(string: "https://image.tmdb.org/t/p/w185" + path) else { return }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: URL) else { return }
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.moviePoster.image = image
            }
        }
        // Setting favorite image
        if viewModel?.isFavorite == true {
            DispatchQueue.main.async {
                self.favoriteImage.image = UIImage(named: "heart-filled")
            }
        }
        else{
            DispatchQueue.main.async {
                self.favoriteImage.image = UIImage(named: "heart-empty")
            }
        }
    }
    @objc func onFavoriteClick(){
        delegate?.favoriteClicked(self)
    }
}
