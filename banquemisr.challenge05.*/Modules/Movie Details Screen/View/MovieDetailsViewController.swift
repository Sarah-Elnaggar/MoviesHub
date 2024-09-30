//
//  MovieDetailsViewController.swift
//  banquemisr.challenge05.*
//
//  Created by Sarah on 30/09/2024.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var movieImage: UIImageView!
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
        movieDetailsViewModel.bindToViewController = { [weak self] in
            DispatchQueue.main.async {
                self?.indicator?.stopAnimating()
                self?.updateUI()
            }
        }
    }
    
    func updateUI() {
        guard let movie = movieDetailsViewModel.movie else { return }
        movieTitle.text = movie.title
        movieRating.text = "\(Int(movie.vote_average ?? 0.0))/10"
        movieDate.text = movie.release_date
        movieRuntime.text = "\(movie.runtime ?? 0) m"
        movieOverview.text = movie.overview
        
        
        if let imageUrl = movie.backdrop_path {
            let fullImageUrl = "https://image.tmdb.org/t/p/w500\(imageUrl)"
            self.movieImage.downloadImage(from: fullImageUrl)
        } else {
            self.movieImage.image = UIImage(named: "MovieHubIcon")
        }
        
        if let genres = movie.genres {
            let genreNames = genres.compactMap { $0.name }.joined(separator: " | ")
            self.movieGenres.text = genreNames.isEmpty ? " " : genreNames
        } else {
            self.movieGenres.text = " "
        }
        
    }

}
