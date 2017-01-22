//
//  MovieListViewCell.swift
//  MovieList
//
//  Created by Leonardo Saragiotto on 1/21/17.
//  Copyright © 2017 Leonardo Saragiotto. All rights reserved.
//

import UIKit

class MovieListViewCell: UICollectionViewCell {
    
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    
//    var secure_image_base_url = ""
//    
//    var genres = [Int: String]()
    
    var movieIndex: Int? {
        didSet {
            updateCell()
        }
    }
    
    var movieApp: MovieListStart?
    
    private func updateCell() {
        
        let cellMovie = self.movieApp!.movieList[movieIndex!]
        
        if let title = cellMovie.title {
            self.movieName.text = title
        } else {
            if let origTitle = cellMovie.original_title {
                self.movieName.text = origTitle
            }
        }
        
        if cellMovie.genres_ids.count > 0 {
            self.movieGenre.text = self.movieApp!.genres![cellMovie.genres_ids[0]]
        } else {
            self.movieGenre.text = ""
        }
        
        if let releaseDate = cellMovie.release_date {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let releaseDateFormatted = dateFormatter.date(from: releaseDate)
            
            let newDateFormat = DateFormatter()
            newDateFormat.dateStyle = .medium
            
            self.movieReleaseDate.text = newDateFormat.string(from: releaseDateFormatted!)
        } else {
            self.movieReleaseDate.text = ""
        }
        
        if let posterImg = cellMovie.posterImage {
            
            self.moviePoster.image = posterImg
            self.setNeedsDisplay()
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                
                let movieId = cellMovie.id 
                
                if let url = NSURL(string:self.movieApp!.secure_image_base_url! + "w300" + cellMovie.poster_path) {
                    
                    if let imgData = NSData(contentsOf: url as URL) {
                        
                        if let img = UIImage(data: imgData as Data) {
                            
                            DispatchQueue.main.async {
                                
                                if movieId == cellMovie.id {
                                    
                                    self.movieApp!.movieList[self.movieIndex!].posterImage = img
                                    self.moviePoster.image = img
                                    self.setNeedsDisplay()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
