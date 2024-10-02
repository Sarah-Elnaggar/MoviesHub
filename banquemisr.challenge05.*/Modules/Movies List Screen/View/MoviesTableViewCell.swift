//
//  MoviesTableViewCell.swift
//  banquemisr.challenge05.*
//
//  Created by Sarah on 30/09/2024.
//

import UIKit

class MoviesTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        movieImage.layer.cornerRadius = 20
    }
    
    func configureCell(image: String, title: String, date: String) {
        movieTitle.text = title
        movieDate.text = date
        
        let fullImageUrl = "https://image.tmdb.org/t/p/w500" + image
        movieImage.downloadImage(from: fullImageUrl)
        
    }


}
