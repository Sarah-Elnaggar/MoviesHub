//
//  ImageExtension.swift
//  banquemisr.challenge05.*
//
//  Created by Sarah on 30/09/2024.
//

import Foundation
import UIKit

extension UIImageView {
    
    func downloadImage(from url: String) {
        
        let placeholderImage = UIImage(named: "MovieHubIcon")
        
        guard let url = URL(string: url) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Error downloading image: \(error)")
                DispatchQueue.main.async {
                    self.image = placeholderImage
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                DispatchQueue.main.async {
                    self.image = placeholderImage
                }
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    print("No data or invalid image")
                    self.image = placeholderImage
                }
                return
            }
            
            DispatchQueue.main.async {
                self.image = image
            }
        }
        task.resume()
    }

}
