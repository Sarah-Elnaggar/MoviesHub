//
//  MoviesListViewController.swift
//  banquemisr.challenge05.*
//
//  Created by Sarah on 30/09/2024.
//

import UIKit

class MoviesListViewController: UIViewController, UITabBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var MoviesTableView: UITableView!
    
    var moviesViewModel = MoviesListViewModel(screenType: .nowPlaying)
    var indicator: UIActivityIndicatorView?
    let dummyImage = "https://davidkoepp.com/wp-content/themes/blankslate/images/Movie%20Placeholder.jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupTabBar()
        
        tabBar.selectedItem = tabBar.items?[0]
        showView(for: 0)
        
        setupActivityIndicator()
        
        moviesViewModel.getMoviesList()
        bindViewModel()
    }
    
    func setupTableView() {
        MoviesTableView.delegate = self
        MoviesTableView.dataSource = self
    }
    
    func setupTabBar() {
        tabBar.delegate = self
    }
    
    func setupActivityIndicator() {
           indicator = UIActivityIndicatorView(style: .large)
           indicator?.center = self.view.center
           indicator?.startAnimating()
           self.view.addSubview(indicator!)
       }
    
    func bindViewModel() {
        moviesViewModel.bindResultToViewController = { [weak self] in
            DispatchQueue.main.async {
                self?.indicator?.stopAnimating()
                self?.MoviesTableView.reloadData()
            }
        }
        
        moviesViewModel.bindErrorToViewController = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showAlert(message: errorMessage)
            }
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        showView(for: item.tag)
    }

    func showView(for index: Int) {
        switch index {
        case 1: 
            navigationItem.title = "Upcoming Movies"
            moviesViewModel.screenType = .upcoming
            moviesViewModel.movieType = "Upcoming"
        case 2: 
            navigationItem.title = "Popular Movies"
            moviesViewModel.screenType = .popular
            moviesViewModel.movieType = "Popular"
        default:
            navigationItem.title = "Now Playing Movies"
            moviesViewModel.screenType = .nowPlaying
            moviesViewModel.movieType = "Now Playing"
        }
        moviesViewModel.getMoviesList()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return moviesViewModel.movies?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MoviesTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = moviesViewModel.movies?[indexPath.section]
        cell.configureCell(image: movie?.poster_path ?? dummyImage, title: movie?.title ?? "", date: movie?.release_date ?? "")
        
        cell.layer.cornerRadius = 30
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let movieDetails = self.storyboard?.instantiateViewController(withIdentifier: "movieDetails") as? MovieDetailsViewController {
            guard let movieID = moviesViewModel.movies?[indexPath.section].id else { return }
            
            movieDetails.movieDetailsViewModel = MovieDetailsViewModel(movieID: movieID)
            self.navigationController?.pushViewController(movieDetails, animated: true)
        }
    }
   
}
