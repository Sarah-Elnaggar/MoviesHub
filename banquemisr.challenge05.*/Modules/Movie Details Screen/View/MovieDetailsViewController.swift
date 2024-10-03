//
//  MovieDetailsViewController.swift
//  banquemisr.challenge05.*
//
//  Created by Sarah on 30/09/2024.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDate: UILabel!
    @IBOutlet weak var movieGenres: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieRuntime: UILabel!
    
    var movieDetailsViewModel = MovieDetailsViewModel(movieID: 0)
    var indicator: UIActivityIndicatorView?
    let dummyImage = "https://davidkoepp.com/wp-content/themes/blankslate/images/Movie%20Placeholder.jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupActivityIndicator()
        bindViewModel()
        
        movieDetailsViewModel.getMovieDetails()
        
    }
    

    func setupActivityIndicator() {
        indicator = UIActivityIndicatorView(style: .large)
        indicator?.center = self.view.center
        indicator?.startAnimating()
        self.view.addSubview(indicator!)
    }
        
    func bindViewModel() {
        movieDetailsViewModel.bindResultToViewController = { [weak self] in
            DispatchQueue.main.async {
                self?.indicator?.stopAnimating()
                self?.updateUI()
            }
        }
        
        movieDetailsViewModel.bindErrorToViewController = { [weak self] errorMessage in
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
    
    
    func updateUI() {
        guard let movie = movieDetailsViewModel.movie else { return }
        movieTitle.text = movie.title ?? ""
        movieRating.text = "\(Int(movie.vote_average ?? 0.0))/10"
        movieDate.text = movie.release_date ?? ""
        movieOverview.text = movie.overview ?? ""
        
        if let movieTime = movie.runtime {
            let hours = movieTime / 60
            let minutes = movieTime % 60
            movieRuntime.text = "\(hours)h \(minutes)m"
        } else {
            movieRuntime.text = ""
        }
        
        movieImage.alpha = 0.7
        if let imageUrl = movie.backdrop_path {
            let fullImageUrl = "https://image.tmdb.org/t/p/w500\(imageUrl)"
            self.movieImage.downloadImage(from: fullImageUrl)
        } else {
            self.movieImage.image = UIImage(named: "MovieHubIcon")
        }
        
        moviePoster.layer.cornerRadius = 20
        if let imageUrl = movie.poster_path {
            let fullImageUrl = "https://image.tmdb.org/t/p/w500\(imageUrl)"
            self.moviePoster.downloadImage(from: fullImageUrl)
        } else {
            self.moviePoster.image = UIImage(named: "MovieHubIcon")
        }
        
        if let genres = movie.genres {
            let genreNames = genres.compactMap { $0.name }.joined(separator: " | ")
            self.movieGenres.text = genreNames.isEmpty ? " " : genreNames
        } else {
            self.movieGenres.text = " "
        }
        
    }

}
