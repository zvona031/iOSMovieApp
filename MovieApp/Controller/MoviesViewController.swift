//
//  ViewController.swift
//  MovieApp
//
//  Created by Zvonimir Pavlović on 04/01/2020.
//  Copyright © 2020 Zvonimir Pavlović. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, MoviesViewModelDelegate, MovieCellDelegate, DetailsMovieViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel: MoviesViewViewModel = MoviesViewViewModel()
    let cellIdentifier = "MovieCell"
    let detailsViewIdentifier = "Details"
    var layout: UICollectionViewFlowLayout!
    var tab: Int?
    var searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        tab = tabBarController?.selectedIndex
        setView()
        getMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if tab == 2 {
            viewModel.getFavoriteMovies() // Refresha listu favorita u Favorite tabu
        }
        else {
            viewModel.compareFavorites() // Stavlja prazna srca u Popular i Latest na ona koja su bila u favoritima ali su maknuta iz favorita u Favorite tabu
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setLayout()
    }
    
    func setView(){
        switch tab {
        case 0:
            self.title = "Latest"
        case 1:
            self.title = "Popular"
        case 2:
            self.title = "Favorite"
        case 3:
            self.title = nil
            searchController.searchBar.sizeToFit()
            navigationItem.titleView = searchController.searchBar
            searchController.searchBar.placeholder = "Search Movies"
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.hidesNavigationBarDuringPresentation = false
            searchController.searchResultsUpdater = self
            definesPresentationContext = true
        default:
            self.title = nil
        }
    }
    
    func getMovies(){
        viewModel.delegate = self
        guard let tabItem = tab else { return }
        viewModel.getMovies(tab: tabItem)
    }

    func setLayout() {
        if layout == nil {
            let numberOfItemsForRow: CGFloat = 2
            let lineSpacing: CGFloat = 0
            let interItemSpacing: CGFloat = 0
            let width = (collectionView.safeAreaLayoutGuide.layoutFrame.width) / numberOfItemsForRow
            let height = width * (16/9)

            layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: width, height: height)
            layout.sectionInset = UIEdgeInsets.zero
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = lineSpacing
            layout.minimumInteritemSpacing = interItemSpacing

            self.collectionView.setCollectionViewLayout(layout, animated: true)
        }
    }
    
    func favoriteChanged(movie: MovieViewModel) {
        guard let index = viewModel.moviesViewModel.firstIndex(of: movie) else { return }
        var indexPath: [IndexPath] = []
        indexPath.append(IndexPath(row: index, section: 0))
        DispatchQueue.main.async {
            self.collectionView.reloadItems(at: indexPath)
        }
    }
    
    func favoriteClicked(_ sender: MovieCell) {
        guard let tappedIndexPath = collectionView.indexPath(for: sender) else { return }
        if viewModel.moviesViewModel[tappedIndexPath.row].isFavorite {
            viewModel.removeFavorite(index: tappedIndexPath.row)
        }else {
            viewModel.addFavorite(index: tappedIndexPath.row)
        }
    }
    
    
    func reloadCollectionView() {
        let index = IndexSet(arrayLiteral: 0)
        DispatchQueue.main.async {
            self.collectionView.performBatchUpdates({
                self.collectionView.reloadSections(index)
            }, completion: nil)
            
        }
    }
    
    func reloadItem(index: Int) {
        var indexPath = [IndexPath]()
        indexPath.append(IndexPath(row: index, section: 0))
        if tab == 2 { // ukoliko je na tabu Favorites uklonjen favorit, taj item se briše iz liste
            DispatchQueue.main.async {
                self.viewModel.moviesViewModel.remove(at: index)
                self.collectionView.deleteItems(at: indexPath)
                self.collectionView.reloadData()
            }
        }else{  // ukoliko je favorit uklonjen/dodan na bilo kojem drugom tabu, item se reloada tj. slika srca se mijenja
            DispatchQueue.main.async {
                self.collectionView.reloadItems(at: indexPath)
            }
            
        }
        
        
    }
}

extension MoviesViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.moviesViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MovieCell
        cell.viewModel = viewModel.moviesViewModel[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.moviesViewModel[indexPath.item]
        openMovieDetails(movie: movie)
    }
    
    func openMovieDetails(movie: MovieViewModel){
        let vc = storyboard?.instantiateViewController(withIdentifier: detailsViewIdentifier) as! DetailsViewController
        vc.title = movie.original_title
        vc.detailsViewViewModel.movieViewModel = movie
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MoviesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmedSearchText.isEmpty {
                viewModel.searchMovies(query: trimmedSearchText)
            }else {
                viewModel.moviesViewModel.removeAll()
                reloadCollectionView()
            }
        }
    }

}
