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
    
    var secure_image_base_url = ""
    
    var movie: Movie? {
        didSet {
            updateCell()
        }
    }
    
    private func updateCell() {
        
        self.movieName.text = self.movie!.title
        self.movieReleaseDate.text = self.movie!.release_date
        
        //
        //        if let posterImage = self.movieList[indexPath.row].posterImage {
        //            cell.moviePoster = UIImageView(image: posterImage)
        //            cell.setNeedsDisplay()
        //        } else {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let movieId = self.movie!.id
            
            if let url = NSURL(string:self.secure_image_base_url + "w300" + self.movie!.poster_path) {
                
                if let imgData = NSData(contentsOf: url as URL) {
                    
                    if let img = UIImage(data: imgData as Data) {
                        
                        DispatchQueue.main.async {
                            
                            if movieId == self.movie!.id {
                                
                                self.movie!.posterImage = img
                                self.moviePoster.image = img
                                
                            }
                        }
                    }
                }
            }
        }

    }
}
