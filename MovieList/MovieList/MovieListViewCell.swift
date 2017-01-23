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
    
    var movieIndex: Int? {
        didSet {
            updateCell()
        }
    }
    
    var movieApp: MovieListStart?
    
    private var cellMovie = Movie()
    
    private func updateCell() {
        
        moviePoster?.image = nil
        movieName?.text = nil
        movieGenre?.text = nil
        movieReleaseDate?.text = nil
        
        cellMovie = self.movieApp!.movieList[movieIndex!]
        
        if let title = cellMovie.title {
            self.movieName.text = title
        } else {
            if let origTitle = cellMovie.originalTitle {
                self.movieName.text = origTitle
            } else {
                self.movieName.text = "Title not available"
            }
        }
        
        if cellMovie.genres_ids.isEmpty {
            self.movieGenre.text = "-"
        } else {
            self.movieGenre.text = self.movieApp!.genres![cellMovie.genres_ids[0]]
        }
        
        if let releaseDate = cellMovie.releaseDate {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let releaseDateFormatted = dateFormatter.date(from: releaseDate)
            
            let newDateFormat = DateFormatter()
            newDateFormat.dateStyle = .medium
            
            self.movieReleaseDate.text = newDateFormat.string(from: releaseDateFormatted!)
        } else {
            self.movieReleaseDate.text = "To be announced"
        }
        
        self.moviePoster.image = UIImage(named: "LaunchPoster.png")!
        
        if let posterImg = cellMovie.posterImage {
            self.moviePoster.image = posterImg
            self.setNeedsDisplay()
        } else {
            
            if let posterPath = cellMovie.posterPath {
                
                DispatchQueue.global(qos: .userInitiated).async {
                    
                    let movieId = self.cellMovie.id
                    
                    if let url = NSURL(string:"\(self.movieApp!.secure_image_base_url!)\(self.movieApp!.preferedPosterSize!)\(posterPath)") {
                        
                        if let imgData = NSData(contentsOf: url as URL) {
                            
                            if let img = UIImage(data: imgData as Data) {
                                
                                DispatchQueue.main.async {
                                    
                                    if movieId == self.cellMovie.id {
                                        
                                        self.movieApp!.movieList[self.movieIndex!].posterImage = img
                                        self.moviePoster.image = img
                                        self.setNeedsDisplay()
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                self.moviePoster.image = UIImage(named: "NoPoster.png")!
            }
        }
    }
}
